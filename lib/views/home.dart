import 'package:demo_flutter/views/play_quiz.dart';
import 'package:demo_flutter/views/signin.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../helper/functions.dart';
import '../services/auth.dart';
import '../services/database.dart';
import '../widgets/widgets.dart';
import 'create_quiz.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream quizStream = Stream.empty();

  AuthService _authService = new AuthService();

  DatabaseService _databaseService = new DatabaseService(uid: '', email: '');

  bool _isLoading = true;

  Future<void> _initializeData() async {
    var value = await _databaseService.getQuizData();
    setState(() {
      quizStream = value;
      _isLoading = false;
    });
  }

  Widget quizList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: Text(
                  "No Quiz Available",
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
            );
          }

          QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;

          return ListView.builder(
            itemCount: querySnapshot.docs.length,
            itemBuilder: (context, index) {
              var quizData =
              querySnapshot.docs[index]?.data() as Map<String, dynamic>?;

              return QuizTile(
                imageUrl: quizData?["quizImgUrl"] ?? "",
                title: quizData?["quizTitle"] ?? "",
                description: quizData?["quizDescription"] ?? "",
                quizId: quizData?["quizId"] ?? "",
              );
            },
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        actions: [
          IconButton(
            onPressed: () {
              // Add your sign out logic here
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.black87,
            ),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: _isLoading
          ? Container(
        child: Center(child: CircularProgressIndicator()),
      )
          : quizList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateQuiz()),
          );
        },
      ),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String quizId;

  QuizTile({
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
          MaterialPageRoute(builder: (context) {
            return PlayQuiz(quizId);
          }),
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
