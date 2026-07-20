import '../../domain/models/ble_device.dart';

/// Data-layer DTO for the JSON wire format. A pure data holder: it knows how to
/// (de)serialize JSON and how to map to the [BleDevice] domain entity, and
/// nothing about runtime concerns like connection status.
class BleDeviceModel {
  const BleDeviceModel({
    required this.id,
    required this.name,
    required this.rssi,
  });

  final String id;
  final String name;
  final int rssi;

  factory BleDeviceModel.fromJson(Map<String, dynamic> json) {
    return BleDeviceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      rssi: (json['rssi'] as num).toInt(), // tolerate 42 vs 42.0 from JSON
    );
  }

  BleDevice toEntity() => BleDevice(id: id, name: name, rssi: rssi);
}
