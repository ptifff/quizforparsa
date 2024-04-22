class QuestionModel{
  late String quizId; // Add this field to hold the quiz ID
  String questionId="";
  String question="";
  String answer="";
  String o2="";
  String o3="";
  String o4="";
  String correctOption="";
  bool answered = false;
 late bool optionsShuffled; // Flag to track whether options have been shuffled

}