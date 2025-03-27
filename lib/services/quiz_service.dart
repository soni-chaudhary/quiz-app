import 'dart:convert';
import 'package:http/http.dart' as http;


class GroqApiServices {
  static const String apiUrl =
      "https://api.groq.com/openai/v1/chat/completions"; // Update if needed
  static const String apiKey =
      "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"; // Replace with actual API key

  static Future<List<dynamic>> fetchQuestions(
      String topic, String selectedDifficulty) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
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
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final String contentString =
            jsonData["choices"][0]["message"]["content"];
        String cleanedJson =
            contentString.replaceAll(RegExp(r'```json|```'), '').trim();

        // Decode the JSON string into a Dart object
        final Map<String, dynamic> contentJson = jsonDecode(cleanedJson);

        // Extract and return the list of questions
        return contentJson["questions"];
      } else {
        throw Exception("Failed to load quiz questions.");
      }
    } catch (e) {
      throw Exception("Error fetching quiz questions: $e");
    }
  }
}
