import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:usermanual/firebase_options.dart';
import 'package:usermanual/home.dart';
import 'package:usermanual/login.dart';
import 'package:usermanual/services/auth.dart';

import 'package:usermanual/signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'usermanual',
      routes: {
        '/': (context) => const CheckUserLogin(),
        '/login': (context) => const Login(),
        '/signin': (context) => const Signin(),
        '/home': (context) => const Home()
      },
    );
  }
}

class CheckUserLogin extends StatefulWidget {
  const CheckUserLogin({super.key});
  @override
  State<CheckUserLogin> createState() => _CheckUserLoginState();
}

class _CheckUserLoginState extends State<CheckUserLogin> {
  @override
  void initState() {
    AuthServicehelper.checklogininit().then((value) {
      if (value == true) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
