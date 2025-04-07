import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:usermanual/services/auth.dart';

import 'package:usermanual/services/database.dart';
import 'package:usermanual/services/toast.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? userData;

  Future fetchUserData() async {
    try {
      // Get current user
      User? user = _auth.currentUser;
      String? uid = user?.uid;

      if (user != null) {
        DocumentSnapshot documentSnapshot =
            await _firestore.collection("User").doc(uid).get();

        return userData = documentSnapshot.data() as Map<String, dynamic>?;
      } else if (user == null) {
        Navigator.pushNamed(context, '/login');
      }
    } catch (e) {
      Message.show(msg: "Error fetching user data: $e");
    }
  }

  Stream? streamuser;
  dynamic getInfoinit() async {
    streamuser = await DatabaseHelper().getallinfo();

    setState(() {});
  }

  @override
  void initState() {
    fetchUserData();
    getInfoinit();
    curentuserinfo();
    super.initState();
  }

  Widget curentuserinfo() {
    return FutureBuilder(
      builder: (context, snapshot) {
        return Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(20),
          color: Colors.blueAccent,
          child: Container(
            margin: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      child: const Icon(Icons.insert_drive_file_outlined),
                      onTap: () {},
                    )
                  ],
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(userData?['image'] ??
                      'https://picsum.photos/id/200/200/300'),
                ),
                Text(
                  '${userData?['username']}',
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Text('${userData?['email']}'),
                Text("${userData?['phone']}")
              ],
            ),
          ),
        );
      },
      future: fetchUserData(),
    );
  }

  Widget allinfouser() {
    return StreamBuilder(
        stream: streamuser,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data.docs[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Material(
                          elevation: 1,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      child: const Icon(Icons.delete_forever),
                                      onTap: () {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          Container(
                                              margin: const EdgeInsets.all(50),
                                              child:
                                                  const CircularProgressIndicator(
                                                color: Colors.blue,
                                              ));
                                        } else {
                                          showDeleteConfirmDialog(
                                              documentSnapshot['uid'], context);
                                        }
                                      },
                                    ),
                                    InkWell(
                                      child: const Icon(Icons.edit),
                                      onTap: () {
                                        usernamecontroller.text =
                                            documentSnapshot['username'];
                                        emailcontroller.text =
                                            documentSnapshot['email'];
                                        phonenumbercontroller.text =
                                            documentSnapshot['phone'];
                                        imagecontroller.text =
                                            documentSnapshot['image'];
                                        edituser(documentSnapshot['uid']);
                                      },
                                    )
                                  ],
                                ),
                                Image.network(
                                  documentSnapshot['image'],
                                  width: 200,
                                  height: 300,
                                ),
                                Text('${documentSnapshot['email']}'),
                                Text('name: ${documentSnapshot['username']}'),
                                Text("phone :${documentSnapshot['phone']}")
                              ],
                            ),
                          )),
                    );
                  })
              : Container(
                  margin: const EdgeInsets.all(20),
                  child: const Center(child: CircularProgressIndicator()),
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${userData?['username']}'),
          actions: [
            InkWell(
              child: const Icon(
                Icons.logout,
                size: 30,
              ),
              onTap: () async {
                AuthServicehelper.logout().then((value) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                });
              },
            ),
          ],
        ),
        body: Container(
            margin: EdgeInsets.zero,
            child: Column(children: [
              Container(
                margin: const EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width,
                child: curentuserinfo(),
              ),
              Expanded(child: allinfouser())
            ])));
  }

  void showDeleteConfirmDialog(String id, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirm Delete"),
            content: const Text("you wnat to delete ?"),
            actions: [
              TextButton(
                  onPressed: () async {
                    await DatabaseHelper().deleteuser(id).then((value) {
                      Navigator.pop(context);
                    });
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  Future edituser(
    String id,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Edit'),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.close))
                      ],
                    ),
                    const Divider(
                      height: 10,
                      color: Colors.blue,
                      thickness: 5,
                    ),
                    const Text(
                      'username',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10.0),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: TextField(
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        controller: usernamecontroller,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text('email'),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10.0),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: TextField(
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        controller: emailcontroller,
                      ),
                    ),
                    const Text('image'),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10.0),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: TextField(
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        controller: imagecontroller,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text('phone'),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10.0),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: TextField(
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        controller: phonenumbercontroller,
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                            onPressed: () async {
                              Map<String, dynamic> updateDetails = {
                                'username': usernamecontroller.text,
                                'email': emailcontroller.text,
                                'phone': phonenumbercontroller.text,
                                'image': imagecontroller.text,
                                'uid': id
                              };
                              await DatabaseHelper()
                                  .updateuser(id, updateDetails)
                                  .then((value) {
                                Message.show(msg: 'update successfully!');
                                Navigator.pop(context);
                              });
                            },
                            child: const Text('update')),
                        OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('cancel'))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
