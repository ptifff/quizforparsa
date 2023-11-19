import 'package:demo_flutter/views/home.dart';
import 'package:demo_flutter/views/signin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'helper/functions.dart';
import 'views/login.dart';
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? _isLoggedIn;

  @override
  void initState() {
    checkUserLoggedInStatus();
    super.initState();
  }

  checkUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInDetails().then((value) {
      setState(() {
        _isLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _isLoggedIn ?? false ? Home() : Login(),
      initialRoute: '/splash_screen',
      routes: {
        '/splash_screen': (context) => SplashScreen(),
        // '/gatherknowledge_admin': (context) => GatherKnowledgeAdmin(),
        // '/testknowledge_admin': (context) => TestKnowledgeAdmin(),
        // '/create_quiz': (context) => CreateQuiz(),
        // '/gatherknowledge_user': (context) => GatherKnowledgeUser(),
        // '/testknowledge_user': (context) => TestKnowledgeUser(),
      },

    );
  }
}
