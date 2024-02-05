import 'package:flutter/material.dart';

import 'package:random_string/random_string.dart';

import '../services/database.dart';
import '../widgets/widgets.dart';

class AddQuestion extends StatefulWidget {

  final String quizId;
  AddQuestion(this.quizId);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {

  final _formKey = GlobalKey<FormState>();
  String question="", answer="", o2="", o3="", o4="", questionId="";

  bool _isLoading = false;

  DatabaseService _databaseService = new DatabaseService(uid: '', email: '');

  _uploadQuestionData() async{
    if(_formKey.currentState!.validate()){

      setState(() {
        _isLoading = true;
      });

      questionId = randomAlphaNumeric(16);

      Map<String, dynamic> questionData = {
        "question" : question,
        "answer" : answer,
        "o2" : o2,
        "o3" : o3,
        "o4" : o4,
        "questionId" : questionId
      };

      await _databaseService.addQuestionData(questionData, widget.quizId, questionId).then((value) => {
        setState(() {
          _isLoading = false;
        })
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Lets Learn Together'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: _isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) : Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Question"
                ),
                onChanged: (val){
                  question = val;
                },
                validator: (val){
                  return val!.isEmpty ? "Enter question" : null;
                },
              ),
              SizedBox(height: 6,),
              TextFormField(
                decoration: InputDecoration(
                    hintText: " Answer"
                ),
                onChanged: (val){
                  answer = val;
                },
                validator: (val){
                  return val!.isEmpty ? "Enter option one" : null;
                },
              ),
              SizedBox(height: 6,),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Option 2"
                ),
                onChanged: (val){
                  o2 = val;
                },
                validator: (val){
                  return val!.isEmpty ? "Enter option two" : null;
                },
              ),
              SizedBox(height: 6,),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Option 3"
                ),
                onChanged: (val){
                  o3 = val;
                },
                validator: (val){
                  return val!.isEmpty ? "Enter option three" : null;
                },
              ),
              SizedBox(height: 6,),
              TextFormField(
                decoration: InputDecoration(
                    hintText: "Option 4"
                ),
                onChanged: (val){
                  o4 = val;
                },
                validator: (val){
                  return val!.isEmpty ? "Enter option four" : null;
                },
              ),
              SizedBox(height: 6,),


              Column(
                children: [
                  SizedBox(height: 20), // Add some space at the top

                  GestureDetector(
                    onTap: () {
                      _uploadQuestionData();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12), // Adjust the padding as needed
                      child: orangeButton(context, "Add Question", MediaQuery.of(context).size.width / 2 - 36, Colors.blue),
                    ),
                  ),

                  SizedBox(height: 12), // Adjust the height of the SizedBox for vertical spacing

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12), // Adjust the padding as needed
                      child: orangeButton(context, "Submit", MediaQuery.of(context).size.width / 2 - 36, Colors.blue),
                    ),
                  ),

                  SizedBox(height: 40.0), // Add some space at the bottom
                ],
              ),

              SizedBox(height: 40.0)
            ],
          ),
        ),
      ),
    );
  }
}
