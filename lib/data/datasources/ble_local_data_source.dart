import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import '../models/ble_device_model.dart';

/// Contract for the local (on-device) source of BLE data.
abstract class BleLocalDataSource {
  Future<List<BleDeviceModel>> getDevices();
}

/// Reads mock BLE devices from a bundled JSON asset. The asset intentionally
/// contains duplicate ids; deduplication happens later in the domain layer.
class BleLocalDataSourceImpl implements BleLocalDataSource {
  /// [bundle] is the asset source, defaulting to the app's [rootBundle]. It is
  /// injectable so tests can supply asset contents without the real bundle.
  BleLocalDataSourceImpl({
    AssetBundle? bundle,
    this.assetPath = 'assets/devices.json',
  }) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  final String assetPath;

  @override
  Future<List<BleDeviceModel>> getDevices() async {
    final raw = await _bundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final devices = json['devices'] as List<dynamic>;
    return devices
        .map((e) => BleDeviceModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}