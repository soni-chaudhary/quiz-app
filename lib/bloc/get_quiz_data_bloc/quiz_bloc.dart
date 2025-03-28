
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/bloc/get_quiz_data_bloc/quiz_event.dart';
import 'package:quiz_app/bloc/get_quiz_data_bloc/quiz_state.dart';
import 'package:quiz_app/models/exception.dart';
import 'package:quiz_app/repo/get_quiz_data_repo.dart';
import 'package:quiz_app/util/string_constants.dart';

class QuizDetailsBloc
    extends Bloc<QuizDataEvent, QuizDetailsState> {
  final GetQuizDataRepo detailsRepo;
  QuizDetailsBloc({required this.detailsRepo})
      : super(QuizDetailsStateInitial()) {
    on<QuizDataEvent>((event, emit) async {
      if (event is FetchQuizDetailsEvent) {
        try {
          emit(QuizDetailsLoading());
          final ageingSummery = await detailsRepo.fetchQuestionsRepo(event.topic,event.selectedDifficulty);
          emit(QuizDataFetched(
              question: ageingSummery));
        } on CustomException catch (e) {
          emit(
            QuizDataBlocError(
                message: e.message ?? StringConstants.unexpected_error_text),
          );
        }
      }
    });
  }
}
