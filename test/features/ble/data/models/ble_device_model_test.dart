import 'package:device_app/features/ble/data/models/ble_device_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BleDeviceModel.fromJson', () {
    test('parses a well-formed entry', () {
      final model = BleDeviceModel.fromJson(const {
        'id': 'AA:BB:11:01',
        'name': 'goTenna Mesh',
        'rssi': -42,
      });

      expect(model.id, 'AA:BB:11:01');
      expect(model.name, 'goTenna Mesh');
      expect(model.rssi, -42);
    });

    test('coerces a double rssi to int (JSON number-typing footgun)', () {
      final model = BleDeviceModel.fromJson(const {
        'id': 'AA:BB:11:02',
        'name': 'goTenna Pro X',
        'rssi': -58.0,
      });

      expect(model.rssi, -58);
      expect(model.rssi, isA<int>());
    });

    test('throws on a malformed entry (missing key) — fail loud', () {
      // The asset is author-controlled, so a bad entry is a bug we want
      // surfaced, not silently skipped.
      expect(
        () => BleDeviceModel.fromJson(const {
          'name': 'No Id Device',
          'rssi': -70,
        }),
        throwsA(isA<TypeError>()),
      );
    });
  });
}
