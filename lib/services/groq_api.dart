import 'dart:convert';

import 'package:quiz_app/api/api_call.dart';

class GroqApiService {
  static ApiCallV1 apiCallV1 = ApiCallV1();

  Future<Map<String, dynamic>> fetchQuestions(
      String topic, String selectedDifficulty) async {
    Map<String, dynamic> payload = {
      "model": "llama-3.3-70b-versatile",
      "messages": [
        {
          "role": "system",
          "content":
              "You are an AI that generates multiple-choice quizzes in a strict JSON format. Always return a response that exactly follows this structure:"
        },
        {
          "role": "system",
          "content": """{
        "questions": [
          {
            "question": "Sample question 1?",
            "options": ["Option A", "Option B", "Option C", "Option D"],
            "correct": "Option B"
          },
        ]
      }"""
        },
        {
          "role": "user",
          "content":
              "Generate a multiple-choice quiz on $topic with 5 questions, 4 options each, difficulty level $selectedDifficulty, valid json Format, always same format and same key name, and correct answers."
        }
      ]
    };
    return await apiCallV1.postCall(jsonEncode(payload));
  }
}
