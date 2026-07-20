import '../models/ble_device.dart';

/// Abstract contract for retrieving BLE devices. The domain layer depends on
/// this interface, not on any concrete data source.
abstract class BleRepository {
  Future<List<BleDevice>> getDevices();
}
