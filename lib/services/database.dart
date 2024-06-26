import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String uid, email;

  DatabaseService({required this.uid, required this.email});

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> addUserData(Map<String, dynamic> userData) async {
    FirebaseFirestore.instance
        .collection("User")
        .doc(auth.currentUser?.uid)
        .set(userData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    return await FirebaseFirestore.instance
        .collection("User")
        .doc(auth.currentUser?.uid)
        .get();
  }

  Future<void> addQuizData(Map<String, dynamic> quizData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .set(quizData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> deleteQuiz(String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .delete()
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> deleteQuizData(String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .delete()
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addQuestionData(
      Map<String, dynamic> questionData, String quizId, String questionId) async {
    try {
      await FirebaseFirestore.instance
          .collection("Quiz")
          .doc(quizId)
          .collection("QNA")
          .doc(questionId)
          .set(questionData);
      print("Question added successfully!");
    } catch (e) {
      print("Error adding question: $e");
    }
  }
  Future<void> deleteQuestion(String quizId, String questionId) async {
    try {
      await FirebaseFirestore.instance
          .collection("Quiz")
          .doc(quizId)
          .collection("QNA")
          .doc(questionId)
          .delete();
      print("Question deleted successfully!");
    } catch (e) {
      print("Error deleting question: $e");
      throw e; // Rethrow the exception so it can be caught in the _deleteQuestion method
    }
  }


  Future<void> updateQuestionData(
      Map<String, dynamic> questionData, String quizId, String questionId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .doc(questionId)
        .update(questionData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getQuizData() {
    return FirebaseFirestore.instance.collection("Quiz").snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getQuestionData(String quizId) async {
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .get();
  }

  Future<void> deleteQuestionData(String quizId, String questionId) async {
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .doc(questionId)
        .delete()
        .catchError((e) {
      print(e.toString());
    });
  }
}
