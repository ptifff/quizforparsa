import 'dart:io' as io;

//import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_pdfview/flutter_pdfview.dart';

class GatherKnowledgeAdmin extends StatefulWidget {
  @override
  _GatherKnowledgeAdminState createState() => _GatherKnowledgeAdminState();
}

class _GatherKnowledgeAdminState extends State<GatherKnowledgeAdmin> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore PDF Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

        ),
      ),
    );
  }
}
