import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_flutter/views/result.dart';
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
  List<Map<String, String>> questions = [];

  List<String> _optionSelected = [];

  bool _isLoading = true;

  QuestionModel getQuestionModelFromSnapshot(DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = QuestionModel();
    final data = questionSnapshot.data() as Map<String, dynamic>?;

    if (data != null) {
      questionModel.questionId = questionSnapshot.id;
      questionModel.quizId = data["quizId"] as String? ?? ''; // Handle nullable quizId
      questionModel.question = data["question"] as String? ?? '';
      questionModel.answer = data["answer"] as String? ?? '';
      questionModel.o2 = data["o2"] as String? ?? '';
      questionModel.o3 = data["o3"] as String? ?? '';
      questionModel.o4 = data["o4"] as String? ?? '';
      questionModel.correctOption = data["answer"] as String? ?? '';
      questionModel.answered = false;
    }

    return questionModel;
  }

  @override
  void initState() {
    super.initState();
    _loadQuestionData();
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
      querySnapshot = await _databaseService.getQuestionData(widget.quizId);
      _notAttempted = 0;
      _correct = 0;
      _incorrect = 0;
      total = querySnapshot.docs.length;
      _isLoading = false;

      questions = querySnapshot.docs.map((doc) {
        return {
          'questionId': doc.id,
          'question': doc['question'] as String,
          'correctOption': doc['answer'] as String,
        };
      }).toList();

      _optionSelected = List.filled(total, '');
    } catch (e) {
      print("Error loading question data: $e");
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _deleteQuestion(String questionId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Question"),
          content: Text("Are you sure you want to delete this question?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await _databaseService.deleteQuestion(widget.quizId, questionId);
                  setState(() {
                    // Update the local state after deleting the question
                    questions.removeWhere((question) => question['questionId'] == questionId);
                    _optionSelected.removeAt(questions.indexWhere((question) => question['questionId'] == questionId));
                    total = questions.length;
                  });
                  Navigator.of(context).pop(); // Close the AlertDialog
                } catch (e) {
                  print("Error deleting question: $e");
                }
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to the home page when the back button is pressed
        Navigator.pushReplacementNamed(context, '/home');
        return false; // Returning true would allow the back navigation to proceed
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Lets Learn Together',
            style: TextStyle(color: Colors.white),
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
                      questionModel: getQuestionModelFromSnapshot(querySnapshot.docs[index]),
                      index: index,
                      optionSelected: _optionSelected[index],
                      onOptionSelect: (option) {
                        setState(() {
                          _optionSelected[index] = option;
                        });
                      },
                      onDelete: () {
                        _deleteQuestion(querySnapshot.docs[index].id);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.done_outline_sharp,
            color: Colors.white,
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
  final VoidCallback onDelete;

  QuizPlayTile({
    required this.questionModel,
    required this.index,
    required this.optionSelected,
    required this.onOptionSelect,
    required this.onDelete,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Q${widget.index + 1} ${widget.questionModel.question}",
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: widget.onDelete,
              ),
            ],
          ),
          SizedBox(height: 12),
          OptionTile(
            option: "A",
            description: widget.questionModel.answer,
            correctAnswer: widget.questionModel.answer,
            optionSelected: widget.optionSelected,
            onTap: () {
              widget.onOptionSelect(widget.questionModel.answer);
            },
          ),
          SizedBox(height: 4),
          OptionTile(
            option: "B",
            description: widget.questionModel.o2,
            correctAnswer: widget.questionModel.answer,
            optionSelected: widget.optionSelected,
            onTap: () {
              widget.onOptionSelect(widget.questionModel.o2);
            },
          ),
          SizedBox(height: 4),
          OptionTile(
            option: "C",
            description: widget.questionModel.o3,
            correctAnswer: widget.questionModel.answer,
            optionSelected: widget.optionSelected,
            onTap: () {
              widget.onOptionSelect(widget.questionModel.o3);
            },
          ),
          SizedBox(height: 4),
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
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
    );
  }
}
