import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import '../../../../core/logging/app_logger.dart';
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
  /// [logger] defaults to a no-op; used for a load breadcrumb. Failures are
  /// allowed to propagate and are logged once by the caller (the bloc).
  BleLocalDataSourceImpl({
    AssetBundle? bundle,
    AppLogger logger = const NoopAppLogger(),
    Duration loadDelay = Duration.zero,
    this.assetPath = 'assets/devices.json',
  })  : _bundle = bundle ?? rootBundle,
        _logger = logger,
        _loadDelay = loadDelay;

  final Duration _loadDelay;
  final AssetBundle _bundle;
  final AppLogger _logger;
  final String assetPath;

  @override
  Future<List<BleDeviceModel>> getDevices() async {
    await Future<void>.delayed(_loadDelay);
    final raw = await _bundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final devices = json['devices'] as List<dynamic>;
    final models = devices
        .map((e) => BleDeviceModel.fromJson(e as Map<String, dynamic>))
        .toList();
    _logger.debug('Loaded ${models.length} devices from $assetPath');
    return models;
  }
}
