import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/datasources/ble_local_data_source.dart';
import 'data/repositories/ble_repository_impl.dart';
import 'domain/repositories/ble_repository.dart';
import 'domain/usecases/connect_device.dart';
import 'domain/usecases/disconnect_device.dart';
import 'domain/usecases/get_devices.dart';
import 'presentation/bloc/ble_bloc.dart';
import 'presentation/screens/device_list_screen.dart';

void main() {
  runApp(const BleApp());
}


class BleApp extends StatelessWidget {
  const BleApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Manual dependency wiring: data source -> repository -> use cases -> bloc.
    final BleRepository repository =
        BleRepositoryImpl(BleLocalDataSourceImpl());
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

