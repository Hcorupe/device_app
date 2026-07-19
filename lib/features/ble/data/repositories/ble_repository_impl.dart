import '../../domain/models/ble_device.dart';
import '../../domain/repositories/ble_repository.dart';
import '../datasources/ble_local_data_source.dart';

/// Concrete repository backed by a local data source. Maps data-layer DTOs
/// (`BleDeviceModel`) to domain entities (`BleDevice`) so the domain never
/// sees a wire-format type.
class BleRepositoryImpl implements BleRepository {
  const BleRepositoryImpl(this._localDataSource);

  final BleLocalDataSource _localDataSource;

  @override
  Future<List<BleDevice>> getDevices() async {
    final models = await _localDataSource.getDevices();
    return models.map((m) => m.toEntity()).toList();
  }
}