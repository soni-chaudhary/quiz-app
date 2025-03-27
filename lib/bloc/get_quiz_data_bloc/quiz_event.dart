abstract class QuizDataEvent {}

class FetchQuizDetailsEvent extends QuizDataEvent {
  String topic;
  String selectedDifficulty;
  FetchQuizDetailsEvent(
      {required this.selectedDifficulty, required this.topic});
}
