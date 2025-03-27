# quiz_app

A new Flutter project.

# quiz_app📚 Flutter Quiz App with Groq API
This is a Flutter-based quiz application that dynamically generates quiz questions using the Groq API. The project follows the BLoC (Business Logic Component) pattern for state management, ensuring scalability and efficiency.

🚀 Features
# Dynamic Quiz Generation: Fetches quiz questions from the Groq API.

# BLoC State Management: Ensures structured state handling.

# Multiple Question Types: Supports multiple-choice questions.

Difficulty Levels: Choose between easy, medium, or hard levels.

User Feedback: Provides instant validation of answers.

Clean Architecture: Follows best practices in file structuring.

📂 Project Structure
graphql
Copy
Edit
lib/
│── api/                 # API-related logic  
│   ├── groq_api.dart    # API service to interact with Groq  
│  
│── bloc/                # BLoC state management  
│   ├── quiz_bloc.dart   # Handles quiz state and events  
│   ├── quiz_event.dart  # Defines quiz events  
│   ├── quiz_state.dart  # Defines quiz states  
│  
│── models/              # Data models  
│   ├── quiz_model.dart  # Model for quiz question & answers  
│  
│── repo/                # Repository for fetching quiz data  
│   ├── quiz_repository.dart  
│  
│── services/            # Services for API handling  
│   ├── quiz_service.dart  
│  
│── screens/             # UI screens  
│   ├── home_screen.dart # Home UI with quiz generation  
│   ├── quiz_screen.dart # UI for displaying questions  
│  
│── utils/               # Utility functions  
│   ├── constants.dart   # App-wide constants  
│  
└── main.dart            # Entry point of the application  
🔧 Setup & Installation
1️⃣ Clone the Repository
sh
Copy
Edit
git clone https://github.com/your-repo/flutter-quiz-app.git  
cd flutter-quiz-app  
2️⃣ Install Dependencies
sh
Copy
Edit
flutter pub get  
3️⃣ Add API Key
Create a .env file in the root directory and add your Groq API key:

env
Copy
Edit
GROQ_API_KEY=your_api_key_here  
4️⃣ Run the App
sh
Copy
Edit
flutter run  
🌍 API Integration
The app fetches quiz questions using the Groq API.

API Details:
Endpoint: https://api.groq.com/v1/chat/completions

Method: POST

Request Body:

json
Copy
Edit
{  
  "topic": "Science",  
  "difficulty": "easy"  
}  
Response:

json
Copy
Edit
{  
  "question": "What is the chemical symbol for water?",  
  "options": ["A H2O", "B CO2", "C O2", "D CH4"],  
  "answer": "A H2O"  
}  
📌 BLoC Implementation
1️⃣ Define Events (quiz_event.dart)
dart
Copy
Edit
abstract class QuizEvent {}  

class FetchQuiz extends QuizEvent {  
  final String topic;  
  final String difficulty;  
  FetchQuiz(this.topic, this.difficulty);  
}  
2️⃣ Define States (quiz_state.dart)
dart
Copy
Edit
abstract class QuizState {}  

class QuizInitial extends QuizState {}  
class QuizLoading extends QuizState {}  
class QuizLoaded extends QuizState {  
  final QuizModel quiz;  
  QuizLoaded(this.quiz);  
}  
class QuizError extends QuizState {  
  final String message;  
  QuizError(this.message);  
}  
3️⃣ Implement BLoC (quiz_bloc.dart)
dart
Copy
Edit
import 'package:flutter_bloc/flutter_bloc.dart';  
import '../repo/quiz_repository.dart';  
import 'quiz_event.dart';  
import 'quiz_state.dart';  

class QuizBloc extends Bloc<QuizEvent, QuizState> {  
  final QuizRepository repository;  
  QuizBloc(this.repository) : super(QuizInitial()) {  
    on<FetchQuiz>(_onFetchQuiz);  
  }  

  void _onFetchQuiz(FetchQuiz event, Emitter<QuizState> emit) async {  
    emit(QuizLoading());  
    try {  
      final quiz = await repository.getQuiz(event.topic, event.difficulty);  
      emit(QuizLoaded(quiz));  
    } catch (e) {  
      emit(QuizError("Failed to fetch quiz"));  
    }  
  }  
}  
🎨 UI Screens
Home Screen (home_screen.dart)
dart
Copy
Edit
import 'package:flutter/material.dart';  
import 'quiz_screen.dart';  

class HomeScreen extends StatelessWidget {  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(title: Text("Quiz App")),  
      body: Center(  
        child: ElevatedButton(  
          onPressed: () {  
            Navigator.push(  
              context,  
              MaterialPageRoute(builder: (context) => QuizScreen()),  
            );  
          },  
          child: Text("Start Quiz"),  
        ),  
      ),  
    );  
  }  
}  
Quiz Screen (quiz_screen.dart)
dart
Copy
Edit
import 'package:flutter/material.dart';  
import 'package:flutter_bloc/flutter_bloc.dart';  
import '../bloc/quiz_bloc.dart';  
import '../bloc/quiz_event.dart';  
import '../bloc/quiz_state.dart';  

class QuizScreen extends StatelessWidget {  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      appBar: AppBar(title: Text("Quiz")),  
      body: BlocBuilder<QuizBloc, QuizState>(  
        builder: (context, state) {  
          if (state is QuizLoading) {  
            return Center(child: CircularProgressIndicator());  
          } else if (state is QuizLoaded) {  
            return Column(  
              children: [  
                Text(state.quiz.question, style: TextStyle(fontSize: 18)),  
                ...state.quiz.options.map((option) => ElevatedButton(  
                      onPressed: () {},  
                      child: Text(option),  
                    )),  
              ],  
            );  
          } else {  
            return Center(child: Text("Press Start Quiz to Begin"));  
          }  
        },  
      ),  
    );  
  }  
}  
🎯 To Do
 Implement Scoring System

 Add Multiple Categories

 Implement Timer for Each Question

 Store Quiz Results Locally

🙌 Contributing
Feel free to submit pull requests or report issues!

📄 License
This project is open-source and available under the MIT License.

