// import 'package:app_quiz/play_quiz.dart';
// import 'package:flutter/material.dart';
// import 'create_quiz.dart'; // Import the appropriate file for CreateQuiz
// import 'helper.dart'; // Import the appropriate file for your helper functions
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class TestKnowledgeAdmin extends StatefulWidget {
//   @override
//   State<TestKnowledgeAdmin> createState() => _TestKnowledgeAdminState();
// }
//
// class _TestKnowledgeAdminState extends State<TestKnowledgeAdmin> {
//   Stream? quizStream;
//   createquiz viewquiz = createquiz();
//
//
//   Widget quizList() {
//     return SingleChildScrollView(
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 24),
//
//         child: Column(
//           children: [
//             StreamBuilder(
//               stream: quizStream,
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Container();
//                 } else {
//                   QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
//                   List<QueryDocumentSnapshot> documents = querySnapshot.docs;
//                   return ListView.builder(
//                     shrinkWrap: true,
//                     physics: ClampingScrollPhysics(),
//                     itemCount: documents.length,
//                     itemBuilder: (context, index) {
//                       return QuizTitle(
//                         quizImageUrl: documents[index]['quizImgUrl'],
//                         quizTitle: documents[index]['quizTitle'],
//                         quizDesc: documents[index]['quizDesc'],
//                         quizId: documents[index]['quizId'],
//
//                       );
//                     },
//                   );
//                 }
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     quizStream = viewquiz.getQuizData(); // Use the updated method with Stream
//
//     // Optionally, you can add a listener to handle errors and updates in the stream
//     quizStream?.listen((event) {
//       // Handle updates or errors here
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Quiz View For Admin'),
//       ),
//       body: quizList(),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => CreateQuiz()));
//         },
//       ),
//     );
//   }
// }
//
// class QuizTitle extends StatelessWidget {
//   final String quizImageUrl;
//   final String quizTitle;
//   final String quizDesc;
//   final String quizId;
//
//   QuizTitle({
//   required this.quizImageUrl,
//   required this.quizTitle,
//   required this.quizDesc,
//     required this.quizId
// });
//
// @override
// Widget build(BuildContext context) {
//   return
//     GestureDetector(
//     onTap: (){
//       Navigator.push(context, MaterialPageRoute(
//           builder: (context) => PlayQuiz(quizId)));
//     },
//     child:
//     Container(
//       margin: EdgeInsets.only(bottom: 8),
//       height: 150,
//       child: Stack(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Image.network(
//               quizImageUrl,
//               width: MediaQuery.of(context).size.width -48,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) {
//                 // Handle the error, e.g., display a placeholder image or a message
//                 return Container(
//                   width: MediaQuery.of(context).size.width -48,
//                   // Set an appropriate width and height
//                   height: 150,
//                   color: Colors.grey, // You can change this to a placeholder image
//                   child: Center(
//                   ),
//                 );
//               },
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.black26,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             alignment: Alignment.center,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (quizTitle != null) Text(quizTitle, style: TextStyle(color: Colors.blue,fontSize: 25,fontWeight: FontWeight.w600),),
//                 if (quizDesc != null) Text(quizDesc, style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.w600),),
//                 if (quizTitle == null && quizDesc == null) Text('No Title and Description'), // Handle both being null
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//    );
// }
// }
