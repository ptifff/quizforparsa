import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_flutter/views/quiz_list.dart';
import 'package:flutter/material.dart';

import '../models/question_model.dart';
import '../services/database.dart';
import '../widgets/widgets.dart';
import 'add_question.dart';
import 'edit_question.dart';

class EditQuiz extends StatefulWidget {
  final String quizId;

  EditQuiz(this.quizId);

  @override
  _EditQuizState createState() => _EditQuizState();
}

class _EditQuizState extends State<EditQuiz> {
  DatabaseService _databaseService = new DatabaseService(uid: '', email: '');
  late QuerySnapshot querySnapshot;

  bool _isLoading = true;

  QuestionModel getQuestionModelFromSnapshot(DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = new QuestionModel();

    Map<String, dynamic> data = questionSnapshot.data() as Map<String, dynamic>;

    questionModel.questionId = data["questionId"];
    questionModel.question = data["question"];

    List<String> options = [
      data["option1"],
      data["option2"],
      data["option3"],
      data["option4"],
    ];
    options.shuffle();

    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];

    questionModel.correctOption = data["correctAnswer"];
    questionModel.correctAnswer = data["correctAnswer"];
    questionModel.answered = false;

    return questionModel;
  }

  _deleteQuizSet() {
    _databaseService.deleteQuizData(widget.quizId).then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => QuizList()));
      setState(() {});
    });
  }

  @override
  void initState() {
    _databaseService.getQuestionData(widget.quizId).then((value) {
      querySnapshot = value;
      _isLoading = false;
      setState(() {});
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddQuestion(widget.quizId),
                  ),
                );
              },
              child: Icon(
                Icons.add,
                size: 26.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.edit,
                size: 26.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                _deleteQuizSet();
              },
              child: Icon(Icons.delete),
            ),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.transparent,
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
              querySnapshot.docs == null
                  ? Container(
                child: Center(
                  child: Text(
                    "No Quiz Available",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                    ),
                  ),
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24),
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: querySnapshot.docs.length,
                itemBuilder: (context, index) {
                  return QuizEditTile(
                    questionModel: getQuestionModelFromSnapshot(
                      querySnapshot.docs[index],
                    ),
                    index: index,
                    quizId: widget.quizId,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizEditTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;
  final String quizId;

  QuizEditTile({
    required this.questionModel,
    required this.index,
    required this.quizId,
  });

  @override
  _QuizEditTileState createState() => _QuizEditTileState();
}

class _QuizEditTileState extends State<QuizEditTile> {
  DatabaseService _databaseService = new DatabaseService(uid: '', email: '');

  _deleteQuestionData(String questionId) {
    _databaseService
        .deleteQuestionData(widget.quizId, questionId)
        .then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EditQuiz(widget.quizId),
        ),
      );
      setState(() {});
    });
  }

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
            height: 10,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  _deleteQuestionData(widget.questionModel.questionId);
                },
                icon: Icon(
                  Icons.delete_forever_sharp,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditQuestion(
                        widget.quizId,
                        widget.questionModel.questionId,
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.edit_attributes_sharp,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.green,
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
