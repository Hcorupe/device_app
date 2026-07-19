part of 'ble_bloc.dart';

abstract class BleEvent extends Equatable {
  const BleEvent();

  @override
  List<Object?> get props => [];
}

/// Load devices (via the get-devices use case, which also dedups).
class LoadDevices extends BleEvent {
  const LoadDevices();
}

/// Connect the device with [id].
class ConnectDevice extends BleEvent {
  const ConnectDevice(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Disconnect the device with [id].
class DisconnectDevice extends BleEvent {
  const DisconnectDevice(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
