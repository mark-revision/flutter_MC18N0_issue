// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

// flutter drive --target=test_driver/app.dart

void main() {
  group('Counter App', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final counterTextFinder = find.byValueKey('counter');
    final buttonFinder = find.byValueKey('increment');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('starts at 0', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(counterTextFinder), "0");
    });

    test('increments the counter', () async {
      // First, tap the button.
      int totalTaps = 1000;
      final testStart = DateTime.now();
      print('Test started at ' + testStart.toIso8601String());
      print('About to tap $totalTaps times');
      int totalTestTime = 0;
      for (int i = 0; i < totalTaps; i++) {
        final start = DateTime.now();
        await driver.tap(buttonFinder);
        final end = DateTime.now();
        final duration = end.difference(start);
        totalTestTime = totalTestTime + duration.inMilliseconds;
        print(duration.inMilliseconds.toString());
      }
      final testEnd = DateTime.now();
      print('Test ended at ' + testEnd.toIso8601String());
      final testDuration = testEnd.difference(testStart);
      print('Average per tap: ' +
          (testDuration.inMilliseconds / totalTaps).toString());

      // Then, verify the counter text is incremented by totalTaps.
      expect(await driver.getText(counterTextFinder), totalTaps.toString());
    }, timeout: Timeout(Duration(minutes: 30)));
  });
}
