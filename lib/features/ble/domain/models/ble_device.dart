import 'package:equatable/equatable.dart';

/// Connection state of a BLE device.
enum ConnectionStatus { disconnected, connected }

/// Domain entity representing a BLE device. Pure business object with no
/// knowledge of JSON or any data source.
class BleDevice extends Equatable {
  const BleDevice({
    required this.id,
    required this.name,
    required this.rssi,
    this.connectionStatus = ConnectionStatus.disconnected,
  });

  /// Unique device identifier (MAC-like address). Used as the dedup key.
  final String id;
  final String name;

  /// Signal strength in dBm (negative; closer to 0 is stronger).
  final int rssi;
  final ConnectionStatus connectionStatus;

  bool get isConnected => connectionStatus == ConnectionStatus.connected;

  BleDevice copyWith({ConnectionStatus? connectionStatus}) {
    return BleDevice(
      id: id,
      name: name,
      rssi: rssi,
      connectionStatus: connectionStatus ?? this.connectionStatus,
    );
  }

  @override
  List<Object?> get props => [id, name, rssi, connectionStatus];
}
