import '../models/ble_device.dart';
import '../repositories/ble_repository.dart';

/// Fetches devices from the repository and removes duplicates by [BleDevice.id],
/// keeping the first occurrence. Deduplication is business logic, so it lives
/// in the domain layer.
class GetDevicesUseCase {
  const GetDevicesUseCase(this._repository);

  final BleRepository _repository;

  Future<List<BleDevice>> call() async {
    final devices = await _repository.getDevices();
    final seen = <String>{};
    return devices.where((d) => seen.add(d.id)).toList();
  }
}
