import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'Med/MedHomePage.dart';
import 'authentication/introScreen.dart';
import 'authentication/loginPage.dart';
import 'authentication/signupPage.dart';
import 'bootup/splashScreen.dart';
import 'bootup/welcomePage.dart';
import 'logistics/LoghomePage.dart';
import 'logistics/pickup_dropup/hourlyDropPage.dart';
import 'logistics/pickup_dropup/quickDropPage.dart';
import 'logistics/pickup_dropup/scheduleDropPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  Stripe.publishableKey="pk_test_51NtsgfSA9G7sUgc67C3OKbGAuUXyweVVGSP5j6lu2FU6iCZfd7yyGyXB8UfRkrrqVvzPKBUbHGNXj6YX9I04qYkc00U7H5r59p";

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //darkTheme: ThemeData(brightness: Brightness.dark),
      // themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: 'splashScreen',
      routes: {
        'splashScreen':(context) =>splashScreen(),
        'loghomePage':(context) =>loghomePage(),
        'welcomePage':(context) =>welcomePage(),
        'medhomePage':(context) =>MedHomePage(),
        'signupPage':(context) =>signupPage(),
        'introscreen':(context) =>introScreen(),
        'loginPage':(context) =>loginPage(),
        'quickdroppage':(context) =>quickDropPage(),
        'hourlydroppage':(context) =>hourlyDropPage(),
        'scheduledroppage':(context) =>scheduleDropPage(),
      },
    );
  }
}
