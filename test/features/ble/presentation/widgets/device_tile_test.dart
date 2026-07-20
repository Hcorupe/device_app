import 'package:bloc_test/bloc_test.dart';
import 'package:device_app/features/ble/domain/models/ble_device.dart';
import 'package:device_app/features/ble/presentation/bloc/ble_bloc.dart';
import 'package:device_app/features/ble/presentation/widgets/device_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mock_bloc.dart';

void main() {
  late MockBleBloc bloc;

  setUp(() {
    bloc = MockBleBloc();
    whenListen(bloc, const Stream<BleState>.empty(),
        initialState: const BleState());
  });

  Future<void> pumpTile(WidgetTester tester, BleDevice device) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<BleBloc>.value(
            value: bloc,
            child: DeviceTile(device: device),
          ),
        ),
      ),
    );
  }

  const disconnected = BleDevice(id: 'AA:BB:11:01', name: 'Alpha', rssi: -40);
  const connected = BleDevice(
    id: 'AA:BB:11:02',
    name: 'Bravo',
    rssi: -50,
    connectionStatus: ConnectionStatus.connected,
  );

  group('DeviceTile', () {
    testWidgets('renders name, id/rssi and a Disconnected chip',
        (tester) async {
      await pumpTile(tester, disconnected);
      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('AA:BB:11:01   •   -40 dBm'), findsOneWidget);
      expect(find.text('Disconnected'), findsOneWidget);
    });

    testWidgets('shows a Connected chip for a connected device',
        (tester) async {
      await pumpTile(tester, connected);
      expect(find.text('Connected'), findsOneWidget);
    });

    testWidgets('tapping Connect dispatches ConnectDevice with the id',
        (tester) async {
      await pumpTile(tester, disconnected);
      await tester.tap(find.text('Connect'));
      verify(() => bloc.add(const ConnectDevice('AA:BB:11:01'))).called(1);
    });

    testWidgets('tapping Disconnect dispatches DisconnectDevice with the id',
        (tester) async {
      await pumpTile(tester, connected);
      await tester.tap(find.text('Disconnect'));
      verify(() => bloc.add(const DisconnectDevice('AA:BB:11:02'))).called(1);
    });
  });
}
