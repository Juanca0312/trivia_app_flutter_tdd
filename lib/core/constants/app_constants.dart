class AppConstants {
  static const String cachedNumberTrivia = 'CACHED_NUMBER_TRIVIA';
  static const FailureMessage failures = FailureMessage();
}

class FailureMessage {
  const FailureMessage();
  String get serverFailureMessage => 'Server failure :(';
  String get cacheFailureMessage => 'Cache Failure :(';
  String get invalidInputFailureMessage => 'Invalid Input - Numnber must be a positive integer or zero :(';
}
