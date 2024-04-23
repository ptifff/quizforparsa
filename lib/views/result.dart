import 'package:flutter/material.dart';

class Results extends StatelessWidget {
  final int total;
  final List<Map<String, String>> questions; // Receive list of questions with correct answers
  final List<String?> optionSelected; // Receive list of selected options

  Results({required this.total, required this.questions, required this.optionSelected });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to your desired page when back button is pressed
        Navigator.pushReplacementNamed(context, '/home');
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
