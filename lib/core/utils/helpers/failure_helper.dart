import 'package:flutter_tdd_course/core/constants/app_constants.dart';
import 'package:flutter_tdd_course/core/error/failures.dart';
import 'package:flutter_tdd_course/core/utils/helpers/input_converter.dart';

class FailureHelper {
  static String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return AppConstants.failures.serverFailureMessage;
      case const (CacheFailure):
        return AppConstants.failures.cacheFailureMessage;
      case const (InvalidInputFailure):
        return AppConstants.failures.invalidInputFailureMessage;
      default:
        return 'Unexpected Error';
    }
  }
}
