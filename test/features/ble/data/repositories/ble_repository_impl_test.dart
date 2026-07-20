
import 'package:device_app/features/ble/data/datasources/ble_local_data_source.dart';
import 'package:device_app/features/ble/data/models/ble_device_model.dart';
import 'package:device_app/features/ble/data/repositories/ble_repository_impl.dart';
import 'package:device_app/features/ble/domain/models/ble_device.dart';
import 'package:flutter_test/flutter_test.dart';

/// Fake data source returning a fixed list of DTOs.
class _FakeLocalDataSource implements BleLocalDataSource {
  const _FakeLocalDataSource(this._models);

  final List<BleDeviceModel> _models;

  @override
  Future<List<BleDeviceModel>> getDevices() async => _models;
}

void main() {
  group('BleRepositoryImpl.getDevices', () {
    test('maps each DTO to a domain entity, preserving fields and order', () async {
      const repository = BleRepositoryImpl(_FakeLocalDataSource([
        BleDeviceModel(id: 'AA:BB:11:01', name: 'Alpha', rssi: -40),
        BleDeviceModel(id: 'AA:BB:11:02', name: 'Bravo', rssi: -50),
      ]));

      final result = await repository.getDevices();

      expect(result, const [
        BleDevice(id: 'AA:BB:11:01', name: 'Alpha', rssi: -40),
        BleDevice(id: 'AA:BB:11:02', name: 'Bravo', rssi: -50),
      ]);
    });

    test('maps entities as disconnected by default', () async {
      const repository = BleRepositoryImpl(_FakeLocalDataSource([
        BleDeviceModel(id: 'AA:BB:11:01', name: 'Alpha', rssi: -40),
      ]));

      final result = await repository.getDevices();

      expect(result.single.connectionStatus, ConnectionStatus.disconnected);
    });

    test('returns an empty list when the data source has no devices', () async {
      const repository = BleRepositoryImpl(_FakeLocalDataSource([]));

      expect(await repository.getDevices(), isEmpty);
    });
  });
}