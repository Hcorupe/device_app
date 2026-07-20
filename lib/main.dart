import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/logging/app_logger.dart';
import 'core/logging/dev_logger.dart';
import 'core/observer/app_bloc_observer.dart';
import 'features/ble/data/datasources/ble_local_data_source.dart';
import 'features/ble/data/repositories/ble_repository_impl.dart';
import 'features/ble/domain/repositories/ble_repository.dart';
import 'features/ble/domain/usecases/connect_device.dart';
import 'features/ble/domain/usecases/disconnect_device.dart';
import 'features/ble/domain/usecases/get_devices.dart';
import 'features/ble/presentation/bloc/ble_bloc.dart';
import 'features/ble/presentation/screens/device_list_screen.dart';

void main() {
  const AppLogger logger = DevAppLogger();
  Bloc.observer = const AppBlocObserver(logger);
  runApp(const BleApp(logger: logger));
}

class BleApp extends StatelessWidget {
  const BleApp({super.key, this.logger = const NoopAppLogger()});

  final AppLogger logger;

  @override
  Widget build(BuildContext context) {
    // Manual dependency wiring: data source -> repository -> use cases -> bloc.
    final BleRepository repository =
    BleRepositoryImpl(BleLocalDataSourceImpl(logger: logger));
    return MaterialApp(
      title: 'BLE Devices',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: BlocProvider(
        create: (_) => BleBloc(
          getDevices: GetDevicesUseCase(repository),
          connectDevice: const ConnectDeviceUseCase(),
          disconnectDevice: const DisconnectDeviceUseCase(),
        )..add(const LoadDevices()),
        child: const DeviceListScreen(),
      ),
    );
  }
}