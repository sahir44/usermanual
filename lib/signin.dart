import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:usermanual/services/auth.dart';
import 'package:usermanual/services/database.dart';
import 'package:usermanual/services/toast.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  void validation() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$email')),
      );
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(' $num')),
      );
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool isobscured = true;
  String? email;
  String? num;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController phonenumbercontroller = TextEditingController();
  TextEditingController imagecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'user manual',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 40),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  "Signin",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: usernamecontroller,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      label: Text('username'),
                      hintText: 'Enter you name '),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: phonenumbercontroller,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    label: Text("phone number"),
                    hintText: "Enter phone number",
                  ),
                  validator: (value) {
                    final phoneRegex = RegExp(r"^\d{10}$");
                    if (value == null || value.isEmpty) {
                      return 'Enter your phoone number';
                    } else if (!phoneRegex.hasMatch(value)) {
                      return 'Enter 10 digit phone number ';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    num = value!;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailcontroller,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      label: Text('Email '),
                      hintText: 'Enter your  Email  '),
                  validator: (value) {
                    final phoneRegex = RegExp(r"^\d{10}$");
                    if (value == null || value.isEmpty) {
                      return 'please enter your email';
                    } else if ((!value.endsWith('@gmail.com') &&
                        !phoneRegex.hasMatch(value))) {
                      return "Email must end with @gmail.com  ";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (newvalue) {
                    email = newvalue!;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: imagecontroller,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      label: Text('Image path '),
                      hintText: "Enter  Image path  from  URI  "),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: passwordcontroller,
                  obscureText: isobscured,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
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
                  height: 20,
                ),
                SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        validation();

                        await AuthServicehelper
                                .createAccountWithemailandPassword(
                                    emailcontroller.text,
                                    passwordcontroller.text)
                            .then((value) {
                          if (value == "AccountCreated") {
                            Message.show(msg: "Account created");
                          } else {
                            Message.show(msg: "Error :$value");
                          }
                        });

                        FirebaseAuth.instance
                            .authStateChanges()
                            .listen((User? user) {
                          if (user == null) {
                            Message.show(msg: 'User is signed out!');
                            // Handle user being signed out (e.g., navigate to login screen)
                          } else {
                            User? user = FirebaseAuth.instance.currentUser;
                            Map<String, dynamic> userdata = {
                              'uid': user?.uid,
                              'username': usernamecontroller.text,
                              'image': imagecontroller.text,
                              'email': emailcontroller.text,
                              'phone': phonenumbercontroller.text,
                              'password': passwordcontroller.text
                            };
                            DatabaseHelper()
                                .createUserdata(userdata, user!.uid)
                                .then((value) {
                              Message.show(msg: 'sucessfully.....!');

                              Navigator.pushReplacementNamed(context, '/login');
                            });
                            // Handle user being signed in (e.g., navigate to home screen)
                          }
                        });
                      },
                      child: const Text(
                        'Signin',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
