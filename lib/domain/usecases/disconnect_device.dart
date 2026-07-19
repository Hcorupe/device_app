import '../models/ble_device.dart';

/// Returns a new list with the device matching [id] marked as disconnected.
class DisconnectDeviceUseCase {
  const DisconnectDeviceUseCase();

  List<BleDevice> call(List<BleDevice> devices, String id) {
    return devices
        .map((d) => d.id == id
        ? d.copyWith(connectionStatus: ConnectionStatus.disconnected)
        : d)
        .toList();
  }
}