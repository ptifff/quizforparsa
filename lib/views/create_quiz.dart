import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import '../services/database.dart';
import '../widgets/widgets.dart';
import 'add_question.dart';
import 'quiz_list.dart';

class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final _formKey = GlobalKey<FormState>();
  String quizImageUrl = "", quizTitle = "", quizDescription = "", quizId = "";

  bool _isLoading = false;

  DatabaseService _databaseService = new DatabaseService(uid: '', email: '');

  _createQuizOnline() async {
    if (_formKey.currentState!.validate()) {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      quizId = randomAlphaNumeric(16);
      Map<String, String> quizData = {
        "quizId": quizId,
        "quizImgUrl": quizImageUrl,
        "quizTitle": quizTitle,
        "quizDescription": quizDescription,
      };

      await _databaseService.addQuizData(quizData, quizId).then((value) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AddQuestion(quizId)),
            );
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: appBar(context),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizList()),
              );
            },
            icon: Icon(Icons.list_alt_sharp, color: Colors.black87),
          )
        ],
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: _isLoading
          ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
          : Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Quiz Image Url (Optional)"),
                onChanged: (val) {
                  quizImageUrl = val;
                },
                validator: (val) {
                  return val!.isEmpty ? "Enter image url" : null;
                },
              ),
              SizedBox(height: 6),
              TextFormField(
                decoration: InputDecoration(hintText: "Quiz Title"),
                onChanged: (val) {
                  quizTitle = val;
                },
                validator: (val) {
                  return val!.isEmpty ? "Enter quiz title" : null;
                },
              ),
              SizedBox(height: 6),
              TextFormField(
                decoration:
                InputDecoration(hintText: "Quiz Description"),
                onChanged: (val) {
                  quizDescription = val;
                },
                validator: (val) {
                  return val!.isEmpty ? "Enter quiz description" : null;
                },
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  _createQuizOnline();
                },
                child: orangeButton(
                  context,
                  "Create Quiz",
                  MediaQuery.of(context).size.width - 48,
                  Colors.deepOrangeAccent,
                ),
              ),
              SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }
}
