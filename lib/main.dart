import 'package:demo_flutter/views/gather_knowledge_admin.dart';
import 'package:demo_flutter/views/gather_knowledge_user.dart';
import 'package:demo_flutter/views/home.dart';
import 'package:demo_flutter/views/inlog_ui.dart';
import 'package:demo_flutter/views/signin.dart';
import 'package:demo_flutter/views/testknowledge_user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'helper/functions.dart';
import 'views/home_student.dart';
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
      home: _isLoggedIn ?? false ? Home() : SignInScreen(),
      initialRoute: '/splash_screen',
      routes: {
        '/splash_screen': (context) => SplashScreen(),
        '/gatherknowledge_admin': (context) => GatherKnowledgeAdmin(),
         '/home': (context) => Home(),
        '/home_student': (context) => HomeStudent(),

        '/gatherknowledge_user': (context) => GatherKnowledgeUser(),
         '/testknowledge_user': (context) => TestKnowledgeUser(),
        '/testknowledge_user': (context) => TestKnowledgeUser(),

      },

    );
  }
}
