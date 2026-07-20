import '../../../../core/logging/app_logger.dart';
import '../models/ble_device.dart';
import '../repositories/ble_repository.dart';

/// Fetches devices from the repository and removes duplicates by [BleDevice.id],
/// keeping the first occurrence. Deduplication is business logic, so it lives
/// in the domain layer.
class GetDevicesUseCase {
  const GetDevicesUseCase(
      this._repository, {
        AppLogger logger = const NoopAppLogger(),
      }) : _logger = logger;

  final BleRepository _repository;
  final AppLogger _logger;

  Future<List<BleDevice>> call() async {
    final devices = await _repository.getDevices();
    final unique = devices.distinctById();
    _logger.debug('Deduped ${devices.length} -> ${unique.length} devices');
    return unique;
  }
}

/// Deduplication helper for BLE device collections.
extension DedupById on Iterable<BleDevice> {
  /// Returns a list with duplicate [BleDevice.id]s removed, keeping the
  /// first occurrence of each id.
  List<BleDevice> distinctById() {
    final seen = <String>{};
    return where((d) => seen.add(d.id)).toList();
  }
}


