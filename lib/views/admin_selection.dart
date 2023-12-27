import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'inlog_ui.dart';

void main() {
  runApp(AdminPanel());
}

class AdminPanel extends StatelessWidget {
  final currentUser = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Lets Learn Together'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Set to false to remove the back button
        backgroundColor: Colors.blue,
        elevation: 0.0,

        actions: [IconButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
        },
            icon: Icon(Icons.logout))],
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Select your topic based on your preferences.',
              style: TextStyle(
                color: Colors.lightBlue,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 150.0,
                  height: 150.0,
                  child: PanelCard(
                    icon: Icons.book,
                    label: 'Create Articles',
                  ),
                ),
                SizedBox(width: 20.0),
                Container(
                  width: 140.0,
                  height: 150.0,
                  child: PanelCard(
                    icon: Icons.book,
                    label: 'Create Quiz',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }
}

class PanelCard extends StatelessWidget {
  final IconData icon;
  final String label;

  PanelCard({
    required this.icon,
    required this.label,
  });

  void _handlePanelTap(BuildContext context) {
    if (label == 'Create Articles') {
      // Navigate to the "Gather Knowledge" screen or perform your action.
      Navigator.pushNamed(context, '/gatherknowledge_admin');

    } else if (label == 'Create Quiz') {
      // Navigate to the "Test Knowledge" screen or perform your action.
      Navigator.pushNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handlePanelTap(context),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48.0,
              color: Colors.blue,
            ),
            SizedBox(height: 10.0),
            Flexible(
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class FeatureDrawerButton extends StatelessWidget {

  final String text;
  final Function() onTap;

  FeatureDrawerButton({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(

        title: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 18.0,
          ),
        ),
        onTap: onTap
    );
  }
}

