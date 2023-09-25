import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:airBot/logistics/LoghomePage.dart';
import 'package:airBot/modelClasses/userclass.dart';
import 'package:intl/src/intl/date_format.dart';
import 'package:airBot/utils/colors.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    startanimate();
    super.initState();
  }

  Future startanimate() async {
    await Future.delayed(Duration(milliseconds: 1500)).then((value){
      _checkCurrentUser();
    });
  }

  Future<void> _checkCurrentUser() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      Navigator.pushReplacementNamed(context, 'signupPage');
    } else {
      Navigator.pushReplacementNamed(context, 'welcomePage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(
            "SPLASH SCREEN",
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
