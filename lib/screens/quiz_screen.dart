import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiz_app/bloc/get_quiz_data_bloc/quiz_bloc.dart';
import 'package:quiz_app/services/quiz_service.dart';
import '../models/question_model.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String topic;
  final String selectedDifficulty;
  const QuizScreen(
      {super.key, required this.topic, required this.selectedDifficulty});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> _questions = [];
  int? selectedOption;
  int optionIndex = 0;
  int _currentIndex = 0;
  int _score = 0;
  bool _loading = true;
  bool isRadioEnabled = false;
  String newOption = "";
  Timer? _timer;
  int _timeLeft = 60;
  late QuizDetailsBloc quizDetailsBloc;
  Question? question;
  @override
  void initState() {
    super.initState();
//     quizDetailsBloc = QuizDetailsBloc(
//         detailsRepo: GetQuizDataRepo(groqApiService: GroqApiService()))
//       ..add(
//         FetchQuizDetailsEvent(
//             topic: widget.topic, selectedDifficulty: widget.selectedDifficulty),
// );

    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final fetchedQuestions = await GroqApiServices.fetchQuestions(
          widget.topic, widget.selectedDifficulty);
      setState(() {
        _questions = fetchedQuestions.map((q) => Question.fromJson(q)).toList();
        _loading = false;
      });
      _startTimer();
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _timeLeft = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer?.cancel();
        _moveToNextQuestion();
      }
    });
  }

  void _moveToNextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        selectedOption = null;
        newOption = "";
      });
      _startTimer();
    } else {
      _timer?.cancel();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultScreen(score: _score, total: _questions.length),
        ),
      );
    }
  }

  void _answerQuestion(String? selectedAnswer) {
    if (_questions[_currentIndex].correctAnswer == selectedAnswer) {
      _score++;
    }
    _timer?.cancel();
    _moveToNextQuestion();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_questions.isEmpty || _currentIndex >= _questions.length) {
      return Scaffold(
          body: const Center(child: Text("No questions available")));
    }
    if (_questions.isEmpty) {
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: const Color(0xFF8980B2)),
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        title: Center(
          child: Text(
            widget.topic,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Question ${_currentIndex + 1}/${_questions.length}",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber),
                ),
                Text(
                  "Time: $_timeLeft s",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text(
              _questions[_currentIndex].question,
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),
            ..._questions[_currentIndex].options.map((option) {
              return GestureDetector(
                onTap: () {
                  newOption = option;
                  optionIndex =
                      _questions[_currentIndex].options.indexOf(option);
                  setState(() {
                    selectedOption = optionIndex;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: selectedOption != null &&
                            _questions[_currentIndex]
                                    .options[selectedOption ?? 0] ==
                                option
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Radio<int>(
                      value: _questions[_currentIndex].options.indexOf(option),
                      groupValue: selectedOption,
                      onChanged: (int? value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                      activeColor: selectedOption ==
                              _questions[_currentIndex].options.indexOf(option)
                          ? Colors.white
                          : Colors.black87,
                    ),
                    title: Text(
                      option,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: selectedOption != null &&
                                _questions[_currentIndex]
                                        .options[selectedOption ?? 0] ==
                                    option
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
            const Spacer(),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    newOption != "" ? () => _answerQuestion(newOption) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: newOption != ""
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).unselectedWidgetColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
