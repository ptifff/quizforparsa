import 'dart:io';
import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AdminLectureUploads(),
    );
  }
}

class AdminLectureUploads extends StatefulWidget {
  const AdminLectureUploads({Key? key}) : super(key: key);

  @override
  _AdminLectureUploadsState createState() => _AdminLectureUploadsState();
}

class _AdminLectureUploadsState extends State<AdminLectureUploads> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> pdfData = [];

  Future<String> uploadPdf(String fileName, File file) async {
    final reference = FirebaseStorage.instance.ref().child("pdfs/$fileName.pdf");
    final uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() {});
    final downloadLink = await reference.getDownloadURL();
    return downloadLink;
  }

  void pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (pickedFile != null) {
      String fileName = pickedFile.files.first.name;
      File file = File(pickedFile.files.first.path!);
      final downloadLink = await uploadPdf(fileName, file);
      await _firebaseFirestore.collection("pdfs").add({
        "name": fileName,
        "url": downloadLink,
      });
      print("Pdf uploaded Successfully");
    }
  }

  void getAllPdf() async {
    final results = await _firebaseFirestore.collection("pdfs").get();
    pdfData = results.docs.map((e) => e.data() as Map<String, dynamic>).toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllPdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Articles', style: TextStyle(
          color: Colors.white, // Set app bar text color to white
        ),
        ),
        backgroundColor: Colors.blue,

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: pdfData.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PdfViewerScreen(
                            pdfUrl: pdfData[index]["url"],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            "assets/pdf.jpeg", // Replace with the correct image path
                            height: 100,
                            width: 100,
                          ),
                          Text(
                            pdfData[index]["name"] ?? "Pdf Name",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.upload_file,
          color: Colors.white, // Set the icon color to white
        ),
        backgroundColor: Colors.blue,
        onPressed: pickFile,
      ),
    );
  }
}

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;

  const PdfViewerScreen({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PDFDocument document;

  @override
  void initState() {
    super.initState();
    document = PDFDocument(); // Initialize with an empty document
    initialisePdf();
  }

  void initialisePdf() async {
    try {
      document = await PDFDocument.fromURL(widget.pdfUrl);
      setState(() {});
    } catch (e) {
      print("Error loading PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: document.count != null
          ? PDFViewer(
        document: document,
        zoomSteps: 1,
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
