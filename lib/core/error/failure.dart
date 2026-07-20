import 'package:equatable/equatable.dart';

/// A user-facing, domain-level failure. [message] is safe to show to the user;
/// the underlying technical cause is logged separately, never surfaced in the UI.
///
/// Sealed so the set of failures is explicit and exhaustive. A real BLE stack
/// would add cases here — e.g. `PermissionDeniedFailure`, `BluetoothOffFailure`,
/// `ConnectionTimeoutFailure` — each with its own message and recovery hint.
sealed class Failure extends Equatable {
  const Failure();

  String get message;

  @override
  List<Object?> get props => [];
}

/// Loading the device list failed.
class DeviceLoadFailure extends Failure {
  const DeviceLoadFailure();

  @override
  String get message => "Couldn't load devices. Tap refresh to try again.";
}
