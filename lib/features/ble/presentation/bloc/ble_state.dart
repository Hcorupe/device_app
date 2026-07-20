part of 'ble_bloc.dart';

enum BleStatus { initial, loading, loaded, error }

class BleState extends Equatable {
  const BleState({
    this.status = BleStatus.initial,
    this.devices = const [],
    this.failure,
  });

  final BleStatus status;
  final List<BleDevice> devices;
  final Failure? failure;

  BleState copyWith({
    BleStatus? status,
    List<BleDevice>? devices,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return BleState(
      status: status ?? this.status,
      devices: devices ?? this.devices,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [status, devices, failure];
}
