import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/models/ble_device.dart';
import '../../domain/usecases/connect_device.dart';
import '../../domain/usecases/disconnect_device.dart';
import '../../domain/usecases/get_devices.dart';

part 'ble_event.dart';
part 'ble_state.dart';

class BleBloc extends Bloc<BleEvent, BleState> {
  BleBloc({
    required GetDevicesUseCase getDevices,
    required ConnectDeviceUseCase connectDevice,
    required DisconnectDeviceUseCase disconnectDevice,
    AppLogger logger = const NoopAppLogger(),
  })  : _getDevices = getDevices,
        _connectDevice = connectDevice,
        _disconnectDevice = disconnectDevice,
        _logger = logger,
        super(const BleState()) {
    on<LoadDevices>(_onLoadDevices);
    on<ConnectDevice>(_onConnectDevice);
    on<DisconnectDevice>(_onDisconnectDevice);
  }

  final GetDevicesUseCase _getDevices;
  final ConnectDeviceUseCase _connectDevice;
  final DisconnectDeviceUseCase _disconnectDevice;
  final AppLogger _logger;

  Future<void> _onLoadDevices(
    LoadDevices event,
    Emitter<BleState> emit,
  ) async {
    emit(state.copyWith(status: BleStatus.loading));
    try {
      final devices = await _getDevices();
      emit(state.copyWith(status: BleStatus.loaded, devices: devices));
    } catch (error, stackTrace) {
      // Log the technical cause here (once); show the user a mapped message.
      _logger.error('Failed to load devices', error, stackTrace);
      emit(state.copyWith(
        status: BleStatus.error,
        failure: const DeviceLoadFailure(),
      ));
    }
  }

  void _onConnectDevice(ConnectDevice event, Emitter<BleState> emit) {
    emit(state.copyWith(devices: _connectDevice(state.devices, event.id)));
  }

  void _onDisconnectDevice(DisconnectDevice event, Emitter<BleState> emit) {
    emit(state.copyWith(devices: _disconnectDevice(state.devices, event.id)));
  }
}