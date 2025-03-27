import 'package:quiz_app/models/question_model.dart';

abstract class QuizDetailsState {}

class QuizDetailsStateInitial extends QuizDetailsState {}

class QuizDetailsLoading extends QuizDetailsState {}

class QuizDataFetched extends QuizDetailsState {
  final Question question;

  QuizDataFetched({required this.question});
}

class QuizDataBlocError extends QuizDetailsState {
  final String message;
  QuizDataBlocError({required this.message});
}
