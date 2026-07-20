import 'package:flutter_bloc/flutter_bloc.dart';

import '../logging/app_logger.dart';

/// Centralized logging of bloc lifecycle and state changes. Register once via
/// `Bloc.observer = AppBlocObserver(logger)` — no bloc needs to know about it.
class AppBlocObserver extends BlocObserver {
  const AppBlocObserver(this._log);

  final AppLogger _log;

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _log.debug('onCreate ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _log.debug('onEvent ${bloc.runtimeType} $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _log.debug('onChange ${bloc.runtimeType} $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    _log.error('onError ${bloc.runtimeType}', error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _log.debug('onClose ${bloc.runtimeType}');
  }
}