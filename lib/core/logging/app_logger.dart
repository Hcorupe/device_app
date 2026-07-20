/// Logging abstraction so the app depends on this interface rather than a
/// concrete logging package. The implementation (dart:developer today, a
/// crash reporter like Sentry/Crashlytics later) can be swapped without
/// changing any call site.
abstract class AppLogger {
  void debug(String message);
  void info(String message);
  void warning(String message);
  void error(String message, [Object? error, StackTrace? stackTrace]);
}

/// No-op logger. Used as the default in constructors and in tests, so logging
/// is opt-in and never a hidden dependency on global state.
class NoopAppLogger implements AppLogger {
  const NoopAppLogger();

  @override
  void debug(String message) {}

  @override
  void info(String message) {}

  @override
  void warning(String message) {}

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {}
}
