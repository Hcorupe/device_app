# device_app

A small Flutter app that lists BLE devices and lets you connect or disconnect
from each one. The brief was to parse the device data from JSON and simulate the
connections rather than talk to a real BLE device — so that's what it does. The
Bluetooth is mocked, and the focus is on how the app is put together. 

## Running it

```
flutter pub get
flutter run
```

`flutter test` runs the tests, `flutter analyze` runs the analyzer.

## How it's laid out

Clean architecture, organized by feature. Everything BLE-related lives under
`lib/features/ble`, split into three layers:

- **domain** — the business rules, plain Dart with no Flutter imports: the
  `BleDevice` entity, the `BleRepository` interface, and the use cases.
- **data** — where the data actually comes from. Reads a bundled JSON file and
  maps it into domain objects.
- **presentation** — the BLoC and the widgets.

The rule I stuck to is that dependencies point inward. The domain has no idea
JSON exists, and the UI has no idea where devices come from — it only talks to
the repository interface. Cross-cutting stuff (logging) sits in `lib/core`.

State is handled with flutter_bloc. There's a single `BleState` with a status
enum (initial / loading / loaded / error), and the screen just draws whatever
the current state happens to be.

## What's real and what isn't

Mocked:

- Device data is a JSON file (`assets/devices.json`), not an actual scan.
- Connect/disconnect just flips a flag on the device in memory. Nothing touches
  the Bluetooth stack.

I faked those on purpose so the structure could be the focus. The trade-off is
that the genuinely hard parts of BLE aren't here. A real version would need
runtime permissions (the Android 12 Bluetooth permissions plus location on older
versions are their own thing), a real scan stream, a proper connection state
machine — connecting, timed out, reconnecting, not just on/off — plus GATT,
retries, and handling for Bluetooth being turned off or denied.

The upside of the layering is that most of that is a data-layer swap. The use
cases, the bloc, and the widgets wouldn't change much, because they only depend
on the `BleRepository` interface.

One detail worth calling out: the JSON has duplicate device ids in it. Deduping
is a business rule, so it happens in the domain (`GetDevicesUseCase`), keeping
the first of each id. The data source hands back whatever is in the file.

## Errors and logging

Errors are handled in one place — the bloc. If a load fails, it logs the
technical cause once and emits a `Failure` carrying a friendly message for the
UI. The user never sees a raw exception.

Logging goes through a small `AppLogger` interface so nothing depends on a
specific logging package; the real implementation just wraps `dart:developer`.
A `BlocObserver` logs state changes and errors centrally, and there are a couple
of global handlers in `main` for anything that slips through. I kept it light on
purpose — I didn't want logging just for the sake of it.

## Tests

`flutter test` runs everything. There's coverage at each layer — the dedup
logic, the JSON parsing (including a check against the real asset so a broken
file gets caught), the bloc, and widget tests for the screen and the device row.
Test doubles are hand-written fakes plus mocktail for the bloc.

## Left out on purpose

Given the scope:

- No real BLE (see above).
- Dependency wiring is done by hand in `main.dart` instead of a DI package —
  fine for a single screen.
- No CI set up, though `flutter analyze` and `flutter test` both pass.
