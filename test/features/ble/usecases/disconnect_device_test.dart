
import 'package:device_app/features/ble/domain/models/ble_device.dart';
import 'package:device_app/features/ble/domain/usecases/disconnect_device.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const useCase = DisconnectDeviceUseCase();
  const devices = [
    BleDevice(
      id: 'AA:BB:11:01',
      name: 'Alpha',
      rssi: -40,
      connectionStatus: ConnectionStatus.connected,
    ),
    BleDevice(id: 'AA:BB:11:02', name: 'Bravo', rssi: -50),
  ];

  group('DisconnectDeviceUseCase', () {
    test('disconnects the matching device and leaves the rest untouched', () {
      expect(useCase(devices, 'AA:BB:11:01'), const [
        BleDevice(id: 'AA:BB:11:01', name: 'Alpha', rssi: -40),
        BleDevice(id: 'AA:BB:11:02', name: 'Bravo', rssi: -50),
      ]);
    });

    test('an unknown id leaves the list unchanged', () {
      expect(useCase(devices, 'ZZ:99:99:99'), devices);
    });
  });
}
