import 'dart:convert';

import 'package:quiz_app/models/exception.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/services/groq_api.dart';
import 'package:quiz_app/util/string_constants.dart';
import 'package:quiz_app/util/utils.dart';

class GetQuizDataRepo {
  final GroqApiService groqApiService;
  GetQuizDataRepo({required this.groqApiService});
  Future<List<Question>> fetchQuestionsRepo(
      String topic, String selectedDifficulty) async {
    var data = await groqApiService.fetchQuestions(topic, selectedDifficulty);

    if (data["statusCode"] == 200) {
      var output;
      if (data['result'] != null) {
        var result = json.decode(data['result']);
        output = result['choices'][0]["message"]["content"];
      } else {
        output = {};
      }
      try {
        var questions = json.decode(output);
        List<dynamic> questionList = questions['questions'];
        List<Question> resultQuestions = questionList.map((q) => Question.fromJson(q)).toList(); 
        return resultQuestions;
      } catch (e) {
        throw CustomException(0, StringConstants.unexpected_error_text);
      }
    } else {
      throw CustomException(data["statusCode"],
          Utils.getErrorMessage(statusCode: data["statusCode"]));
    }
  }
}
