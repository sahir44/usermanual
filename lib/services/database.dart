import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHelper {
  Future createUserdata(Map<String, dynamic> userdata, String id) async {
    return await FirebaseFirestore.instance
        .collection('User')
        .doc(id)
        .set(userdata);
  }

  Future<Stream<QuerySnapshot>> getallinfo() async {
    return FirebaseFirestore.instance.collection('User').snapshots();
  }

  Future updateuser(String id, Map<String, dynamic> updateDetails) async {
    return await FirebaseFirestore.instance
        .collection('User')
        .doc(id)
        .update(updateDetails);
  }

  Future deleteuser(String id) async {
    return await FirebaseFirestore.instance.collection('User').doc(id).delete();
  }
}
