import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usermanual/services/toast.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? userData;

  void fetchUserData() async {
    try {
      // Get current user
      User? user = _auth.currentUser;
      if (user != null) {
        // Fetch user data from Firestore
        DocumentSnapshot documentSnapshot =
            await _firestore.collection("User").doc(user.email).get();

        setState(() {
          userData = documentSnapshot.data() as Map<String, dynamic>?;
        });
      }
    } catch (e) {
      Message.show(msg: "Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${userData!['username']}")),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    userData!['image'],
                    width: 200,
                    height: 300,
                  ),
                  Text("Name: ${userData!['username']}",
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 10),
                  Text("Email: ${userData!['email']}",
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 10),
                  // Add other fields as needed
                ],
              ),
            ),
    );
  }
}
