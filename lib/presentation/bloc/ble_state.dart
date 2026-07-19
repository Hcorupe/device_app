part of 'ble_bloc.dart';

enum BleStatus { initial, loading, loaded, error }

class BleState extends Equatable {
  const BleState({
    this.status = BleStatus.initial,
    this.devices = const [],
    this.errorMessage,
  });

  final BleStatus status;
  final List<BleDevice> devices;
  final String? errorMessage;

  BleState copyWith({
    BleStatus? status,
    List<BleDevice>? devices,
    String? errorMessage,
  }) {
    return BleState(
      status: status ?? this.status,
      devices: devices ?? this.devices,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, devices, errorMessage];
}
