import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/bloc/get_quiz_data_bloc/quiz_bloc.dart';
import 'package:quiz_app/bloc/get_quiz_data_bloc/quiz_event.dart';
import 'package:quiz_app/bloc/get_quiz_data_bloc/quiz_state.dart';
import 'package:quiz_app/repo/get_quiz_data_repo.dart';
import 'package:quiz_app/services/groq_api.dart';
import 'package:quiz_app/util/string_constants.dart';
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
  int? selectedOption;
  int optionIndex = 0;
  int _currentIndex = 0;
  int _score = 0;
  bool isRadioEnabled = false;
  String newOption = "";
  Timer? _timer;
  int _timeLeft = 60;
  late QuizDetailsBloc quizDetailsBloc;
  List<Question>? question;
  @override
  void initState() {
    super.initState();
    quizDetailsBloc = QuizDetailsBloc(
        detailsRepo: GetQuizDataRepo(groqApiService: GroqApiService()))
      ..add(
        FetchQuizDetailsEvent(
            topic: widget.topic, selectedDifficulty: widget.selectedDifficulty),
      );
    _startTimer();
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
    if (_currentIndex < question!.length - 1) {
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
              ResultScreen(score: _score, total: question?.length ?? 0),
        ),
      );
    }
  }

  void _answerQuestion(String? selectedAnswer) {
    if (question![_currentIndex].correctAnswer == selectedAnswer) {
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
      body: BlocBuilder(
        bloc: quizDetailsBloc,
        builder: (context, state) {
          if (state is QuizDetailsLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }
          if (state is QuizDataBlocError) {
            return Center(
              child: Text(StringConstants.error_text),
            );
          }
          if (state is QuizDataFetched) {
            question = state.question;
            return question?.isEmpty ?? true
                ? Center(child: Text("No questions available"))
                : Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Question ${_currentIndex + 1}/${question?.length ?? 0}",
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
                          question![_currentIndex].question,
                          style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...question![_currentIndex].options.map((option) {
                          return GestureDetector(
                            onTap: () {
                              newOption = option;
                              optionIndex = question![_currentIndex]
                                  .options
                                  .indexOf(option);
                              setState(() {
                                selectedOption = optionIndex;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: selectedOption != null &&
                                        question![_currentIndex]
                                                .options[selectedOption ?? 0] ==
                                            option
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: Radio<int>(
                                  value: question![_currentIndex]
                                      .options
                                      .indexOf(option),
                                  groupValue: selectedOption,
                                  onChanged: (int? value) {
                                    // setState(() {
                                    //   selectedOption = value;
                                    // });
                                  },
                                  activeColor: selectedOption ==
                                          question![_currentIndex]
                                              .options
                                              .indexOf(option)
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                                title: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: selectedOption != null &&
                                            question![_currentIndex].options[
                                                    selectedOption ?? 0] ==
                                                option
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        const Spacer(),
                        SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: newOption != ""
                                ? () => _answerQuestion(newOption)
                                : null,
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
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          }
          return Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          )));
        },
      ),
    );
  }
}
