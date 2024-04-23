import 'package:demo_flutter/views/user_selection.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';
import 'admin_selection.dart';
import 'home.dart';
import 'home_student.dart';

// class Results extends StatelessWidget {
//   final int correct;
//   final int incorrect;
//   final int total;
//   final String optionSelected; // Receive option selected
//
//   Results({required this.correct, required this.incorrect, required this.total, required this.optionSelected});
//
//   @override
//   Widget build(BuildContext context) {
//     bool isCorrect = optionSelected == correctAnswer; // Assuming you have correctAnswer variable
//     Color resultColor = isCorrect ? Colors.green : Colors.red;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Results'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Total Questions: $total',
//             ),
//             Text(
//               'Correct Answers: $correct',
//               style: TextStyle(color: resultColor),
//             ),
//             Text(
//               'Incorrect Answers: $incorrect',
//               style: TextStyle(color: resultColor),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ResultsState extends State<Results> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//           height: MediaQuery.of(context).size.height,
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text("Correct Answer / Total : ${widget.correct}/${widget.total}", style: TextStyle(fontSize: 25),),
//                 SizedBox(height: 8,),
//                 Text("You answered correctly : ${widget.correct}", style: TextStyle(fontSize: 16, color: Colors.green), textAlign: TextAlign.center,),
//                 SizedBox(height: 8,),
//                 Text("Your incorrect answer : ${widget.incorrect}", style: TextStyle(fontSize: 16, color: Colors.red), textAlign: TextAlign.center,),
//
//                 SizedBox(height: 20,),
//                 GestureDetector(
//                     onTap: (){
//                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminPanel()));
//                     },
//                     child: orangeButton(context, "Go To Home", MediaQuery.of(context).size.width/2, Colors.blueAccent)
//                 ),
//               ],
//             ),
//           ),
//         ),
//     );
//   }
// }
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class StudentResult extends StatelessWidget {
  final int total;
  final List<Map<String, String>> questions; // Receive list of questions with correct answers
  final List<String?> optionSelected; // Receive list of selected options

  StudentResult({required this.total, required this.questions, required this.optionSelected });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to your desired page when back button is pressed
        Navigator.pushReplacementNamed(context, '/home_student');
        return false; // Returning true would allow the back navigation to proceed
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Result',
            style: TextStyle(color: Colors.white), // Set text color to white
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          elevation: 0.0,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total Questions: $total',
                ),
                SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: total,
                  itemBuilder: (context, index) {
                    bool isCorrect = optionSelected[index] == questions[index]['correctOption'];
                    Color resultColor = isCorrect ? Colors.green : Colors.red;
                    String correctAnswer = questions[index]['correctOption'] ?? '';

                    return ListTile(
                      title: Text('Question ${index + 1}: ${questions[index]['question']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Your Answer: ${optionSelected[index] ?? ''}'),
                          Text(
                            'Correct Answer: $correctAnswer',
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                      trailing: Text(
                        isCorrect ? 'Correct' : 'Incorrect',
                        style: TextStyle(color: resultColor),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
