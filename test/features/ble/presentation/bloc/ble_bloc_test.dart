import 'package:bloc_test/bloc_test.dart';
import 'package:device_app/core/error/failure.dart';
import 'package:device_app/features/ble/domain/models/ble_device.dart';
import 'package:device_app/features/ble/domain/usecases/connect_device.dart';
import 'package:device_app/features/ble/domain/usecases/disconnect_device.dart';
import 'package:device_app/features/ble/domain/usecases/get_devices.dart';
import 'package:device_app/features/ble/presentation/bloc/ble_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_repositories.dart';

BleBloc buildBloc(List<BleDevice> devices) => BleBloc(
      getDevices: GetDevicesUseCase(FakeBleRepository(devices)),
      connectDevice: const ConnectDeviceUseCase(),
      disconnectDevice: const DisconnectDeviceUseCase(),
    );

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

  group('BleBloc', () {
    blocTest<BleBloc, BleState>(
      'LoadDevices emits loading then a deduplicated loaded list',
      build: () => buildBloc(devicesWithDupes),
      act: (bloc) => bloc.add(const LoadDevices()),
      expect: () => const [
        BleState(status: BleStatus.loading),
        BleState(status: BleStatus.loaded, devices: uniqueDevices),
      ],
    );

    blocTest<BleBloc, BleState>(
      'ConnectDevice then DisconnectDevice flips only the target device',
      build: () => buildBloc(devicesWithDupes),
      act: (bloc) async {
        bloc.add(const LoadDevices());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const ConnectDevice('AA:BB:11:02'));
        bloc.add(const DisconnectDevice('AA:BB:11:02'));
      },
      skip: 2, // skip loading + loaded states
      expect: () => const [
        BleState(
          status: BleStatus.loaded,
          devices: [
            BleDevice(id: 'AA:BB:11:01', name: 'Alpha', rssi: -40),
            BleDevice(
              id: 'AA:BB:11:02',
              name: 'Bravo',
              rssi: -50,
              connectionStatus: ConnectionStatus.connected,
            ),
            BleDevice(id: 'AA:BB:11:03', name: 'Charlie', rssi: -60),
          ],
        ),
        BleState(status: BleStatus.loaded, devices: uniqueDevices),
      ],
    );

    blocTest<BleBloc, BleState>(
      'LoadDevices emits loading then error when the repository throws',
      build: () => BleBloc(
        getDevices: const GetDevicesUseCase(ThrowingBleRepository()),
        connectDevice: const ConnectDeviceUseCase(),
        disconnectDevice: const DisconnectDeviceUseCase(),
      ),
      act: (bloc) => bloc.add(const LoadDevices()),
      expect: () => [
        const BleState(status: BleStatus.loading),
        isA<BleState>()
            .having((s) => s.status, 'status', BleStatus.error)
            .having((s) => s.failure, 'failure', isA<DeviceLoadFailure>()),
      ],
    );
  });
}
