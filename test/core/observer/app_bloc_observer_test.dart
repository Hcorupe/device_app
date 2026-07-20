
import 'package:device_app/core/logging/app_logger.dart';
import 'package:device_app/core/observer/app_bloc_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Records calls so we can assert what the observer logged. This is exactly why
/// [AppLogger] is an interface — observability is testable without real logging.
class _SpyLogger implements AppLogger {
  final List<String> debugs = [];
  final List<_ErrorCall> errors = [];

  @override
  void debug(String message) => debugs.add(message);

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) =>
      errors.add(_ErrorCall(message, error, stackTrace));

  @override
  void info(String message) {}

  @override
  void warning(String message) {}
}

class _ErrorCall {
  const _ErrorCall(this.message, this.error, this.stackTrace);
  final String message;
  final Object? error;
  final StackTrace? stackTrace;
}

class _CounterBloc extends Bloc<String, int> {
  _CounterBloc() : super(0) {
    on<String>((event, emit) => emit(state + 1));
  }
}

void main() {
  late _SpyLogger logger;
  late AppBlocObserver observer;
  late _CounterBloc bloc;

  setUp(() {
    logger = _SpyLogger();
    observer = AppBlocObserver(logger);
    bloc = _CounterBloc();
  });

  tearDown(() => bloc.close());

  group('AppBlocObserver', () {
    test('onEvent logs the event at debug', () {
      observer.onEvent(bloc, 'tick');
      expect(logger.debugs.single, allOf(contains('onEvent'), contains('tick')));
    });

    test('onChange logs the change at debug', () {
      observer.onChange(bloc, const Change(currentState: 0, nextState: 1));
      expect(logger.debugs.single, contains('onChange'));
    });

    test('onError forwards the error and stack trace to logger.error', () {
      final error = Exception('boom');
      final stackTrace = StackTrace.current;

      observer.onError(bloc, error, stackTrace);

      expect(logger.errors, hasLength(1));
      expect(logger.errors.single.error, error);
      expect(logger.errors.single.stackTrace, stackTrace);
      expect(logger.errors.single.message, contains('_CounterBloc'));
      expect(logger.debugs, isEmpty); // errors go to error(), not debug()
    });
  });
}
