import '../models/ble_device.dart';

/// Returns a new list with the device matching [id] marked as connected.
class ConnectDeviceUseCase {
  const ConnectDeviceUseCase();

  List<BleDevice> call(List<BleDevice> devices, String id) {
    return devices
        .map((d) => d.id == id
            ? d.copyWith(connectionStatus: ConnectionStatus.connected)
            : d)
        .toList();
  }
}
