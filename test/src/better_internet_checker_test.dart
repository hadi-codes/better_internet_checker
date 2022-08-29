// ignore_for_file: prefer_const_constructors
@Timeout(Duration(seconds: 1000))

import 'package:better_internet_checker/better_internet_checker.dart';
import 'package:test/test.dart';

void main() {
  group(
    'BetterInternetChecker',
    () {
      test('can be instantiated', () {
        expect(BetterInternetChecker(), isNotNull);
      });
      final betterInternetChecker = BetterInternetChecker();
      test('checkInternet', () async {
        final result = await betterInternetChecker.hasConnection;
        expect(result, isNotNull);
      });
      test(
        'onConnectionChange',
        () async {
          betterInternetChecker.onConnectivityChanged.listen((event) {
            print(event);
            expect(event, isNotNull);
          });
          await Future<void>.delayed(
           Duration(seconds: 1233),
          );
        },
      );
    },
  );
}
