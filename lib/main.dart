import 'package:app/Database/mongoDB.dart';
import 'package:app/Pages/Auth/GetStarted.dart';
import 'package:app/Pages/Page/MainHome.dart';
import 'package:app/Pages/DocumentScanner/document_scanner_page.dart';

import 'package:app/Widgets/ChatBox/AllChatsScreen.dart';
import 'package:app/Widgets/ChatBox/CreateRoomScreen.dart';
import 'package:app/Widgets/ChatBox/HelpCenter.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Pages/Auth/Login.dart';
import 'Pages/Auth/SignUp.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MongoDBDatabase.connect();

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
        '/all-chats': (context) => AllChatsScreen(),
        '/new-chat': (context) => CreateRoomScreen(),
        '/help': (context) => HelpScreen(),
        '/document-scanner': (context) => DocumentScannerPage(), // Thêm route mới
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
