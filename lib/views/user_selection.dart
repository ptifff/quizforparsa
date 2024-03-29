import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'inlog_ui.dart';


void main() {
  runApp(TopicSelection());
}

class TopicSelection extends StatelessWidget {
  final currentUser = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer:Drawer(
      //   child: Column(
      //     children: [
      //       StreamBuilder(
      //           stream: FirebaseFirestore.instance.collection("Users").
      //           where("uid",isEqualTo: currentUser.currentUser!.uid).snapshots(),
      //            builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
      //         if(snapshot.hasData){
      //           return ListView.builder(
      //               itemCount:snapshot.data!.docs.length,
      //               shrinkWrap: true,
      //               itemBuilder: (context,i){
      //                 var data = snapshot.data!.docs[i];
      //                 return UserAccountsDrawerHeader(accountName: Text(data['name']), accountEmail:Text(data['email']));
      //           });
      //         }else{
      //           return CircularProgressIndicator();
      //         }
      //       })
      //     ],
      //   ),
      // ),
      // drawer: Drawer(
      //   child: ListView(
      //     children: [
      //       FeatureDrawerButton( text: 'Gather Knowledge', onTap: () {
      //         Navigator.of(context).pushNamed('/learning_material');
      //       },),
      //       FeatureDrawerButton( text: 'Test Knowledge', onTap: () {
      //         Navigator.of(context).pushNamed('/instructor_booking');
      //       },),
      //       FeatureDrawerButton( text: 'Profile', onTap: () {
      //         Navigator.of(context).pushNamed('/learner_scheduling'); },),
      //       FeatureDrawerButton( text: 'Logout', onTap: () {  },),
      //     ],
      //   ),
      // ),
      appBar: AppBar(
        title: Text('Lets Learn Together',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, // Set to false to remove the back button
        backgroundColor: Colors.blue,
        elevation: 0.0,

        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          )
        ],
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
                    label: 'Article',
                  ),
                ),
                SizedBox(width: 20.0),
                Container(
                  width: 150.0,
                  height: 150.0,
                  child: PanelCard(
                    icon: Icons.book,
                    label: 'Quiz',
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
    if (label == 'Article') {
      // Navigate to the "Gather Knowledge" screen or perform your action.
      Navigator.pushNamed(context, '/user_articles');
    } else if (label == 'Quiz') {
      // Navigate to the "Test Knowledge" screen or perform your action.
      Navigator.pushNamed(context, '/home_student');

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

