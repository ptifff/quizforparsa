import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/database.dart';
import '../widgets/widgets.dart';
import 'edit_quiz.dart';

class QuizList extends StatefulWidget {
  @override
  _QuizListState createState() => _QuizListState();
}

class _QuizListState extends State<QuizList> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> quizStream;

  DatabaseService _databaseService = DatabaseService(uid: '', email: '');

  bool _isLoading = true;

  Widget quizList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: quizStream,
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          return snapshot.hasData
              ? ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return QuizEditTile(
                imageUrl: snapshot.data!.docs[index].data()!["quizImgUrl"],
                title: snapshot.data!.docs[index].data()!["quizTitle"],
                description: snapshot.data!.docs[index].data()!["quizDescription"],
                quizId: snapshot.data!.docs[index].data()!["quizId"],
              );
            },
          )
              : Container(
            child: Center(
              child: Text(
                "No Quiz Available",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    quizStream = _databaseService.getQuizData();
    _isLoading = false; // Assuming you don't need loading state here
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: _isLoading
          ? Container(
        child: Center(child: CircularProgressIndicator()),
      )
          : quizList(),
    );
  }
}

class QuizEditTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String quizId;

  QuizEditTile({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.quizId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return EditQuiz(quizId);
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        height: 150,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: MediaQuery.of(context).size.width - 48,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black26,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    description,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
