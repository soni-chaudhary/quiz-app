import 'dart:convert';

import 'package:quiz_app/models/exception.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/services/groq_api.dart';
import 'package:quiz_app/util/stringConstants.dart';
import 'package:quiz_app/util/utils.dart';

class GetQuizDataRepo {
  final GroqApiService groqApiService;
  GetQuizDataRepo({required this.groqApiService});
  Future<Question> fetchQuestionsRepo(
      String topic, String selectedDifficulty) async {
    var data = await groqApiService.fetchQuestions(topic, selectedDifficulty);

    if (data["statusCode"] == 200) {
      var output;
      if (data['result'] != null)
        output = json.decode(data['result']);
      else
        output = {};
      try {
        Question questions = Question.fromJson(output);
        return questions;
      } catch (e) {
        throw CustomException(0, StringConstants.unexpected_error_text);
      }
    } else {
      throw CustomException(data["statusCode"],
          Utils.getErrorMessage(statusCode: data["statusCode"]));
    }
  }
}
