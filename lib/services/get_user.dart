import 'package:cloud_firestore/cloud_firestore.dart';

class GetUserDataController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot<Object?>>> getUserData(String uId) async {
    final QuerySnapshot userData =
    await _firestore.collection('users').where('uId', isEqualTo: uId).get();
    return userData.docs;
  }
}
