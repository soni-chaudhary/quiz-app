import 'package:quiz_app/api/api_response_handler.dart';
import 'package:http/http.dart' as http;

class ApiCallV1 {
  static const String apiUrl =
      "https://api.groq.com/openai/v1/chat/completions"; // Update if needed
  static const String apiKey =
      "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";

  Future<Map<String, dynamic>> postCall(dynamic payload) async {
    var client = new http.Client();

    final headers = {
      "Authorization": "Bearer $apiKey",
      "Content-Type": "application/json",
    };
    try {
      var uriResponse = await client.post(
        Uri.parse(apiUrl),
        body: payload,
        headers: headers,
      );

      if (uriResponse.statusCode == 200) {
        return ApiResponseHandler.output(uriResponse);
      }
    } catch (error) {
      return ApiResponseHandler.outputError();
    }
    return ApiResponseHandler.outputError();
  }
}
