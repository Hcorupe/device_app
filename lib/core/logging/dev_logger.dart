import 'dart:developer' as developer;

import 'app_logger.dart';

/// [AppLogger] backed by `dart:developer`'s `log`, which integrates with
/// Flutter DevTools. Levels map to the standard `package:logging` values
/// (FINE/INFO/WARNING/SEVERE) so a future swap to that package or a crash
/// reporter is a one-file change.
class DevAppLogger implements AppLogger {
  const DevAppLogger({String name = 'ble_devices'}) : _name = name;

  final String _name;

  @override
  void debug(String message) => developer.log(message, name: _name, level: 500);

  @override
  void info(String message) => developer.log(message, name: _name, level: 800);

  @override
  void warning(String message) =>
      developer.log(message, name: _name, level: 900);

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) =>
      developer.log(
        message,
        name: _name,
        level: 1000,
        error: error,
        stackTrace: stackTrace,
      );
}
