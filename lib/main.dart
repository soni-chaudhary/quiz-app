import 'package:flutter/material.dart';
import 'package:quiz_app/screens/home_screen.dart';
import 'package:quiz_app/screens/profile_screen.dart';
import 'package:quiz_app/screens/score_screen.dart';
import 'package:quiz_app/theme.dart';
void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: customthemeData(context),
      debugShowCheckedModeBanner: false,
      home: HomeScreenData(),
    );
  }
}

class HomeScreenData extends StatefulWidget {
  @override
  State<HomeScreenData> createState() => _HomeScreenDataState();
}

class _HomeScreenDataState extends State<HomeScreenData> {
  int currentIndex = 0;

  List screens = [HomeScreen(), ScoreScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 25), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events, size: 25), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 25), label: ''),
        ],
      ),
      body: screens[currentIndex],
    );
  }
}
