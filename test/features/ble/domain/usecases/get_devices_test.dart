
import 'package:device_app/features/ble/domain/models/ble_device.dart';
import 'package:device_app/features/ble/domain/usecases/get_devices.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_repositories.dart';




void main() {
  const devicesWithDupes = [
    BleDevice(id: 'AA:BB:11:01', name: 'Alpha', rssi: -40),
    BleDevice(id: 'AA:BB:11:02', name: 'Bravo', rssi: -50),
    BleDevice(id: 'AA:BB:11:01', name: 'Alpha', rssi: -40), // duplicate
    BleDevice(id: 'AA:BB:11:03', name: 'Charlie', rssi: -60),
    BleDevice(id: 'AA:BB:11:02', name: 'Bravo', rssi: -50), // duplicate
  ];

  const uniqueDevices = [
    BleDevice(id: 'AA:BB:11:01', name: 'Alpha', rssi: -40),
    BleDevice(id: 'AA:BB:11:02', name: 'Bravo', rssi: -50),
    BleDevice(id: 'AA:BB:11:03', name: 'Charlie', rssi: -60),
  ];

  group('GetDevicesUseCase', () {
    test('fetches from the repository and removes duplicates by id', () async {
      const useCase = GetDevicesUseCase(FakeBleRepository(devicesWithDupes));
      expect(await useCase(), uniqueDevices);
    });
  });

  group('distinctById', () {
    test('returns an empty list for an empty input', () {
      expect(const <BleDevice>[].distinctById(), isEmpty);
    });

    test('leaves an all-unique list unchanged, preserving order', () {
      expect(uniqueDevices.distinctById(), uniqueDevices);
    });

    test('drops duplicate ids, keeping the first occurrence and order', () {
      const input = [
        BleDevice(id: 'AA:BB:11:01', name: 'Alpha', rssi: -40),
        BleDevice(id: 'AA:BB:11:02', name: 'Bravo', rssi: -50),
        BleDevice(id: 'AA:BB:11:01', name: 'Alpha (dupe)', rssi: -99),
        BleDevice(id: 'AA:BB:11:03', name: 'Charlie', rssi: -60),
        BleDevice(id: 'AA:BB:11:02', name: 'Bravo (dupe)', rssi: -99),
      ];
      expect(input.distinctById(), uniqueDevices);
    });
  });
}
