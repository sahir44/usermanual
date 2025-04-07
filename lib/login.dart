import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:usermanual/services/auth.dart';
import 'package:usermanual/services/toast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData = {};

  Future fetchUserData() async {
    try {
      // Get current user
      User? user = _auth.currentUser;

      String? uid = user?.uid;

      if (user != null) {
        // Fetch user data from Firestore
        DocumentSnapshot documentSnapshot =
            await _firestore.collection("User").doc(uid).get();
        userData = documentSnapshot.data() as Map<String, dynamic>;

        return userData;
      } else if (user == null) {
        Navigator.pushNamed(context, '/login');
      }
    } catch (e) {
      Message.show(msg: "Error fetching user data: $e");
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool isobscured = true;
  late String email;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('user manual')),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Login",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: emailcontroller,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Email '),
                  hintText: 'Enter your  Email   '),
              validator: (value) {
                final phoneRegex = RegExp(r"^\d{10}$");
                if (value == null || value.isEmpty) {
                  return 'please enter your email';
                } else if ((!value.endsWith('@gmail.com') &&
                    !phoneRegex.hasMatch(value))) {
                  return "Email must end with @gmail.com";
                } else {
                  return null;
                }
              },
              onSaved: (newvalue) {
                email = newvalue!;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: passwordcontroller,
              obscureText: isobscured,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  label: const Text('password'),
                  hintText: "Enter your password ",
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isobscured = !isobscured;
                        });
                      },
                      icon: Icon(isobscured
                          ? Icons.visibility
                          : Icons.visibility_off))),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: OutlinedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Message.show(msg: 'validating');
                    }

                    await AuthServicehelper.loginWithEmail(
                            emailcontroller.text, passwordcontroller.text)
                        .then((value) {
                      if (value == "Login sucess") {
                        Message.show(msg: value);

                        fetchUserData().then((value) {
                          if (value != null) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/home', (route) => false);
                          }
                        });
                      } else {
                        Message.show(msg: value);
                      }
                    });
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("if you  want  acoount  :"),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signin');
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
