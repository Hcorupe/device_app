import 'dart:convert';

import 'package:device_app/features/ble/data/datasources/ble_local_data_source.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory [AssetBundle] serving canned string contents keyed by asset path.
class _FakeAssetBundle extends CachingAssetBundle {
  _FakeAssetBundle(this._contents);

  final Map<String, String> _contents;

  @override
  Future<ByteData> load(String key) async {
    final value = _contents[key];
    if (value == null) {
      throw FlutterError('Unable to load asset: $key');
    }
    return ByteData.view(Uint8List.fromList(utf8.encode(value)).buffer);
  }
}

void main() {
  // Needed for the real-asset test, which reads the shipped bundle via rootBundle.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BleLocalDataSourceImpl.getDevices', () {
    const validJson = '''
{
  "devices": [
    { "id": "AA:BB:11:01", "name": "goTenna Mesh", "rssi": -42 },
    { "id": "AA:BB:11:02", "name": "goTenna Pro X", "rssi": -58 },
    { "id": "AA:BB:11:01", "name": "goTenna Mesh", "rssi": -42 }
  ]
}
''';

    test('parses the JSON asset into models', () async {
      final dataSource = BleLocalDataSourceImpl(
        bundle: _FakeAssetBundle(const {'assets/devices.json': validJson}),
      );

      final result = await dataSource.getDevices();

      expect(result.map((m) => m.id).toList(),
          ['AA:BB:11:01', 'AA:BB:11:02', 'AA:BB:11:01']);
      expect(result.first.name, 'goTenna Mesh');
      expect(result.first.rssi, -42);
    });

    test('preserves duplicates (deduplication is the domain layer\'s job)',
        () async {
      final dataSource = BleLocalDataSourceImpl(
        bundle: _FakeAssetBundle(const {'assets/devices.json': validJson}),
      );

      final result = await dataSource.getDevices();

      // The asset has a duplicate id; the data source must NOT dedup.
      expect(result, hasLength(3));
    });

    test('reads from the configured assetPath', () async {
      const custom = '{ "devices": [] }';
      final dataSource = BleLocalDataSourceImpl(
        assetPath: 'assets/other.json',
        bundle: _FakeAssetBundle(const {'assets/other.json': custom}),
      );

      expect(await dataSource.getDevices(), isEmpty);
    });

    test('throws when the asset is missing', () {
      final dataSource = BleLocalDataSourceImpl(
        bundle: _FakeAssetBundle(const {}),
      );

      expect(dataSource.getDevices(), throwsA(isA<FlutterError>()));
    });

    test('throws on malformed JSON', () {
      final dataSource = BleLocalDataSourceImpl(
        bundle: _FakeAssetBundle(const {'assets/devices.json': 'not json'}),
      );

      expect(dataSource.getDevices(), throwsA(isA<FormatException>()));
    });

    test('the real bundled asset parses and yields non-empty, valid entries',
        () async {
      // Smoke test against the actual shipped assets/devices.json (no fake
      // bundle) to catch schema drift or a corrupted asset before release.
      final result = await BleLocalDataSourceImpl().getDevices();

      expect(result, isNotEmpty);
      expect(result.every((m) => m.id.isNotEmpty && m.name.isNotEmpty), isTrue);
    });
  });
}
