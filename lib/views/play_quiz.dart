import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_flutter/views/result.dart';
import 'package:flutter/material.dart';

import '../models/question_model.dart';
import '../services/database.dart';
import '../widgets/quiz_play_widget.dart';
import '../widgets/widgets.dart';

class PlayQuiz extends StatefulWidget {
  final String quizId;

  PlayQuiz(this.quizId);

  @override
  _PlayQuizState createState() => _PlayQuizState();
}

int total = 0;
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;

Stream<List<int>> infoStream = Stream<List<int>>.empty();

class _PlayQuizState extends State<PlayQuiz> {
  DatabaseService _databaseService = DatabaseService(uid: '', email: '');
  late QuerySnapshot querySnapshot;
  List<Map<String, String>> questions = []; // Corrected type

  List<String> _optionSelected = [];

  bool _isLoading = true;

  QuestionModel getQuestionModelFromSnapshot(DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = QuestionModel();
    final data = questionSnapshot.data() as Map<String, dynamic>?;

    if (data != null) {
      questionModel.question = data["question"] as String;

      List<String> options = [
        data["answer"] as String,
        data["o2"] as String,
        data["o3"] as String,
        data["o4"] as String,
      ];
      options.shuffle();

      questionModel.answer = options[0];
      questionModel.o2 = options[1];
      questionModel.o3 = options[2];
      questionModel.o4 = options[3];

      questionModel.correctOption = data["answer"] as String;
      questionModel.answered = false;
    }

    return questionModel;
  }

  @override
  void initState() {
    super.initState();
    // Load data when the widget is created
    _loadQuestionData();
    // Initialize the infoStream
    if (infoStream == null) {
      infoStream = Stream<List<int>>.periodic(
        Duration(milliseconds: 100),
            (x) {
          return [_correct, _incorrect];
        },
      );
    }
  }

  Future<void> _loadQuestionData() async {
    try {
      // Fetch data from the database
      querySnapshot = await _databaseService.getQuestionData(widget.quizId);
      // Update the state variables
      _notAttempted = 0;
      _correct = 0;
      _incorrect = 0;
      total = querySnapshot.docs.length;
      _isLoading = false;

      // Populate the questions list
      questions = querySnapshot.docs.map((doc) {
        return {
          'question': doc['question'] as String,
          'correctOption': doc['answer'] as String, // Assuming 'answer' is the correct option
        };
      }).toList();

      // Initialize _optionSelected list with empty strings
      _optionSelected = List.filled(total, '');
    } catch (e) {
      print("Error loading question data: $e");
      // Handle the error, e.g., show an error message to the user
    }
    // Trigger a rebuild after data is loaded
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lets Learn Together',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: _isLoading
          ? Container(
        child: Center(child: CircularProgressIndicator()),
      )
          : SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              InfoHeader(
                length: querySnapshot.docs.length,
              ),
              SizedBox(
                height: 10,
              ),
              querySnapshot.docs.isEmpty
                  ? Row(
                
                    children: [
                      Flexible(
                        child: Container(
                                        child: Center(
                        child: Text(
                          "No Question Available",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        ),
                                        ),
                                      ),
                      ),
                    ],
                  )
                  : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24),
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: querySnapshot.docs.length,
                itemBuilder: (context, index) {
                  return QuizPlayTile(
                    questionModel: getQuestionModelFromSnapshot(
                        querySnapshot.docs[index]),
                    index: index,
                    optionSelected: _optionSelected[index],
                    onOptionSelect: (option) {
                      setState(() {
                        _optionSelected[index] = option;
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue, // Set background color to blue

        child: Icon(Icons.done_outline_sharp,
          color: Colors.white, // Set icon color to white
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Results(
                total: total,
                questions: questions,
                optionSelected: _optionSelected,
              ),
            ),
          );
        },
      ),
    );
  }
}

class InfoHeader extends StatefulWidget {
  final int length;

  InfoHeader({required this.length});

  @override
  _InfoHeaderState createState() => _InfoHeaderState();
}

class _InfoHeaderState extends State<InfoHeader> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: infoStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Container(
            height: 40,
            margin: EdgeInsets.only(left: 14),
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: <Widget>[
                NumberOfQuestionTile(
                  text: "Total",
                  number: widget.length,
                ),
                NumberOfQuestionTile(
                  text: "Correct",
                  number: _correct,
                ),
                NumberOfQuestionTile(
                  text: "Incorrect",
                  number: _incorrect,
                ),
                NumberOfQuestionTile(
                  text: "NotAttempted",
                  number: _notAttempted,
                ),
              ],
            ),
          )
              : Container();
        });
  }
}

class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;
  final String optionSelected;
  final Function(String) onOptionSelect;

  QuizPlayTile({
    required this.questionModel,
    required this.index,
    required this.optionSelected,
    required this.onOptionSelect,
  });

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Q${widget.index + 1} ${widget.questionModel.question}",
            style: TextStyle(fontSize: 18, color: Colors.black87),
          ),
          SizedBox(
            height: 12,
          ),
          OptionTile(
            option: "A",
            description: widget.questionModel.answer,
            correctAnswer: widget.questionModel.answer,
            optionSelected: widget.optionSelected,
            onTap: () {
              widget.onOptionSelect(widget.questionModel.answer);
            },
          ),
          SizedBox(height: 4,),
          OptionTile(
            option: "B",
            description: widget.questionModel.o2,
            correctAnswer: widget.questionModel.answer,
            optionSelected: widget.optionSelected,
            onTap: () {
              widget.onOptionSelect(widget.questionModel.o2);
            },
          ),
          SizedBox(height: 4,),
          OptionTile(
            option: "C",
            description: widget.questionModel.o3,
            correctAnswer: widget.questionModel.answer,
            optionSelected: widget.optionSelected,
            onTap: () {
              widget.onOptionSelect(widget.questionModel.o3);
            },
          ),
          SizedBox(height: 4,),
          OptionTile(
            option: "D",
            description: widget.questionModel.o4,
            correctAnswer: widget.questionModel.answer,
            optionSelected: widget.optionSelected,
            onTap: () {
              widget.onOptionSelect(widget.questionModel.o4);
            },
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }
}

class OptionTile extends StatelessWidget {
  final String option;
  final String description;
  final String correctAnswer;
  final String optionSelected;
  final Function onTap;

  OptionTile({
    required this.option,
    required this.description,
    required this.correctAnswer,
    required this.optionSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = optionSelected == description;

    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey,
                  width: 1.5,
                ),
              ),
              child: Text(
                option,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
