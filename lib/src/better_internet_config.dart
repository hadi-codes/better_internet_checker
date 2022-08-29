/// {@template better_internet_config}
/// Internet Internt checker config
/// {@endtemplate}
class BetterInternetConfig {
  /// {@macro better_internet_config}
  const BetterInternetConfig({
    this.url = 'https://www.gstatic.com/generate_204',
    this.timeout = const Duration(seconds: 5),
    this.offlineInterval = const Duration(seconds: 1),
    this.onlineInterval = const Duration(seconds: 5),
    this.httpSuccessCode = 204,
  });

  /// The url to check for internet
  final String url;

  /// The timeout for the request
  final Duration timeout;

  /// The interval to check for internet when offline
  final Duration offlineInterval;

  /// The interval to check for internet when online
  final Duration onlineInterval;

  /// The http success code
  final int httpSuccessCode;
}
