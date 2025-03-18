import 'package:app/Pages/Auth/GetStarted.dart';
import 'package:app/Pages/Page/MainHome.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Pages/Auth/Login.dart';
import 'Pages/Auth/SignUp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Triopybara",
      theme: ThemeData(
        fontFamily: "Roboto-Black",
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => GetStarted(),
        '/home': (context) => MainPage(),
        '/login': (context) => Login(),
        '/signup': (context) => SignUp(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
