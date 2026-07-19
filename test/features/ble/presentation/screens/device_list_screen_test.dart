
import 'package:bloc_test/bloc_test.dart';
import 'package:device_app/features/ble/domain/models/ble_device.dart';
import 'package:device_app/features/ble/presentation/bloc/ble_bloc.dart';
import 'package:device_app/features/ble/presentation/screens/device_list_screen.dart';
import 'package:device_app/features/ble/presentation/widgets/device_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mock_bloc.dart';

void main() {
  late MockBleBloc bloc;

  setUp(() => bloc = MockBleBloc());

  // Pumps the screen with the bloc pinned to [state].
  Future<void> pumpWithState(WidgetTester tester, BleState state) async {
    whenListen(bloc, const Stream<BleState>.empty(), initialState: state);
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<BleBloc>.value(
          value: bloc,
          child: const DeviceListScreen(),
        ),
      ),
    );
  }

  group('DeviceListScreen', () {
    testWidgets('shows a spinner while loading', (tester) async {
      await pumpWithState(tester, const BleState(status: BleStatus.loading));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows a spinner in the initial state', (tester) async {
      await pumpWithState(tester, const BleState());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows the error message on error', (tester) async {
      await pumpWithState(
        tester,
        const BleState(status: BleStatus.error, errorMessage: 'boom'),
      );
      expect(find.text('Error: boom'), findsOneWidget);
    });

    testWidgets('shows an empty message when loaded with no devices',
        (tester) async {
      await pumpWithState(tester, const BleState(status: BleStatus.loaded));
      expect(find.text('No devices found.'), findsOneWidget);
      expect(find.byType(DeviceTile), findsNothing);
    });

    testWidgets('renders a tile per device when loaded', (tester) async {
      await pumpWithState(
        tester,
        const BleState(
          status: BleStatus.loaded,
          devices: [
            BleDevice(id: 'AA:BB:11:01', name: 'Alpha', rssi: -40),
            BleDevice(id: 'AA:BB:11:02', name: 'Bravo', rssi: -50),
          ],
        ),
      );
      expect(find.byType(DeviceTile), findsNWidgets(2));
    });

    testWidgets('refresh action dispatches LoadDevices', (tester) async {
      await pumpWithState(tester, const BleState(status: BleStatus.loaded));
      await tester.tap(find.byTooltip('Reload'));
      verify(() => bloc.add(const LoadDevices())).called(1);
    });
  });
}
