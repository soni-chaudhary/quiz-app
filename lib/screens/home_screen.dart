import 'package:flutter/material.dart';
import 'package:quiz_app/widgets/quiz_card.dart';
import 'package:quiz_app/widgets/section_title.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedDifficultyLevel = "Easy";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 340,
            child: Stack(
              children: [
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40, left: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Quiz App",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Lets Play and be the first",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Text('LS',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 160,
                    width: MediaQuery.of(context).size.width - 60,
                    margin: EdgeInsets.all(30),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Selection your difficulty level",
                          style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "To play now",
                          style: TextStyle(
                            color: Theme.of(context).unselectedWidgetColor,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 60,
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  value: "Easy",
                                  items: ["Easy", "Medium", "Hard"]
                                      .map((level) => DropdownMenuItem(
                                            value: level,
                                            child: Text(level),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    selectedDifficultyLevel = value!;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SectionTitle(
            title: 'Recent Quiz',
          ),
          SizedBox(
            height: 10,
          ),
          QuizCard(
            title: 'Mathamatic',
            subtitle: '5 Question, Start Quiz',
            icon: Icons.tag,
            color: Colors.amber,
            backgroundColor: const Color.fromARGB(255, 255, 241, 200),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QuizScreen(
                          topic: 'Maths',
                          selectedDifficulty: selectedDifficultyLevel,
                        )),
              );
            },
          ),
          QuizCard(
            title: 'English',
            subtitle: '5 Question, Start Quiz',
            icon: Icons.language,
            color: Colors.green,
            backgroundColor: const Color.fromARGB(255, 218, 255, 219),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QuizScreen(
                          topic: 'English',
                          selectedDifficulty: selectedDifficultyLevel,
                        )),
              );
            },
          ),
        ],
      ),
    );
  }
}
