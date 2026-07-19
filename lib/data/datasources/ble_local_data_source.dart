import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/ble_device_model.dart';

/// Contract for the local (on-device) source of BLE data.
abstract class BleLocalDataSource {
  Future<List<BleDeviceModel>> getDevices();
}

/// Reads mock BLE devices from a bundled JSON asset. The asset intentionally
/// contains duplicate ids; deduplication happens later in the domain layer.
class BleLocalDataSourceImpl implements BleLocalDataSource {
  const BleLocalDataSourceImpl({this.assetPath = 'assets/devices.json'});

  final String assetPath;

  @override
  Future<List<BleDeviceModel>> getDevices() async {
    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final devices = json['devices'] as List<dynamic>;
    return devices
        .map((e) => BleDeviceModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}