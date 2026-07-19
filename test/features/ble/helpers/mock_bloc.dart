
import 'package:bloc_test/bloc_test.dart';
import 'package:device_app/features/ble/presentation/bloc/ble_bloc.dart';

/// Mock [BleBloc] for widget tests. Pin its state with `whenListen` and assert
/// dispatched events with mocktail's `verify`.
class MockBleBloc extends MockBloc<BleEvent, BleState> implements BleBloc {}
