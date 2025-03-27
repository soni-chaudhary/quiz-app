


import 'package:quiz_app/util/stringConstants.dart';

class Utils {
  static String getErrorMessage(
      {required int statusCode,
      String error = StringConstants.unexpected_error_text}) {
    switch (statusCode) {
      case 0:
        return StringConstants.unexpected_error_text;
      case 401:
        return StringConstants.unauthorised_error_text;
      case 500:
        return StringConstants.server_error_text;
      case 422:
        return error;
      default:
        return StringConstants.unexpected_error_text;
    }
  }
 
}

