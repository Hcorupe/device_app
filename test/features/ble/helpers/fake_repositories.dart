import 'package:device_app/features/ble/domain/models/ble_device.dart';
import 'package:device_app/features/ble/domain/repositories/ble_repository.dart';

/// Fake repository returning a fixed in-memory list (may contain duplicate ids).
class FakeBleRepository implements BleRepository {
  const FakeBleRepository(this._devices);

  final List<BleDevice> _devices;

  @override
  Future<List<BleDevice>> getDevices() async => _devices;
}

/// Fake repository that always fails, to exercise error paths.
class ThrowingBleRepository implements BleRepository {
  const ThrowingBleRepository();

  @override
  Future<List<BleDevice>> getDevices() async =>
      throw const FormatException('boom');
}
