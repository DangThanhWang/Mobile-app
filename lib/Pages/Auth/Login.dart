// ignore: file_names
import 'dart:convert';

import 'package:app/Database/mongoDB.dart';
import 'package:app/Definitons/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/Providers/UserProvider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State, Center;
// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isRememberMeChecked = false;
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  // Đăng nhập bằng Google
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // Người dùng hủy đăng nhập

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        String? name = user.displayName;
        String? photoUrl = user.photoURL;
        String uid = user.uid;
        globalUserId = uid;
        final nameFromDb = await MongoDBDatabase.getUserName(globalUserId!);
        final scoreFromDb =
            await MongoDBDatabase.getUserScoreString(globalUserId!);
        await MongoDBDatabase.upsertUserProgress(globalUserId!,
            name: nameFromDb, score: scoreFromDb);
        Provider.of<UserProvider>(context, listen: false).setUser(
          nameFromDb,
        );

        // Điều hướng đến trang Home và truyền thông tin người dùng
        Navigator.pushReplacementNamed(
          // ignore: use_build_context_synchronously
          context,
          '/home',
          arguments: {
            'name': name,
            'photoUrl': photoUrl,
            'uid': user.uid,
          },
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi đăng nhập Google: $e';
      });
    }
  }

  // Đăng nhập bằng email và mật khẩu
  void _signInWithEmailPassword() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields.';
      });
      return;
    }

    try {
      final usersCollection = await MongoDBDatabase.getCollection('Users');
      final hashedPassword = _hashPassword(_passwordController.text.trim());

      final existingUser = await usersCollection.findOne(
          where.eq('email', _emailController.text.trim().toLowerCase()));
      print(existingUser);
      if (existingUser == null) {
        setState(() {
          _errorMessage = 'Email or password is incorrect.';
        });
        return;
      }
      if (existingUser['password'] != hashedPassword) {
        setState(() {
          _errorMessage = 'Email or password is incorrect.';
        });
        return;
      }
      // Đăng nhập thành công
      String? name = existingUser['userName'];
      String? email = existingUser['email'];
      String? photoUrl = existingUser['photoUrl'];
      String? uid = existingUser['userId'];
      globalUserId = uid;
      gmailUser = email;
      globalUserName = name;
      print(
          'globalUserId: $globalUserId, gmailUser: $gmailUser, globalUserName: $globalUserName');

      final nameFromDb = await MongoDBDatabase.getUserName(globalUserId!);
      final scoreFromDb =
          await MongoDBDatabase.getUserScoreString(globalUserId!);
      await MongoDBDatabase.upsertUserProgress(globalUserId!,
          name: nameFromDb, score: scoreFromDb);
      Provider.of<UserProvider>(context, listen: false).setUser(
        nameFromDb,
      );

      // Điều hướng đến trang Home và truyền thông tin người dùng
      Navigator.pushReplacementNamed(
        // ignore: use_build_context_synchronously
        context,
        '/home',
        arguments: {
          'name': name,
          'photoUrl': photoUrl,
        },
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Email or password is incorrect.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: const Text('Log In'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Image.asset('assets/images/capy_login.png', height: 180),
            SizedBox(height: 30),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(LineAwesomeIcons.envelope),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              obscureText: _obscureText,
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(LineAwesomeIcons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText
                        ? LineAwesomeIcons.eye_slash
                        : LineAwesomeIcons.eye,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _isRememberMeChecked,
                  checkColor: Color(0xFFd3b591),
                  onChanged: (bool? value) {
                    setState(() {
                      _isRememberMeChecked = value ?? false;
                    });
                  },
                ),
                Text('Remember me'),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _signInWithEmailPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD3B591),
              ),
              child: Text(
                'LOG IN',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            TextButton(
              onPressed: () {
                // Xử lý quên mật khẩu
              },
              child: Text('Forgot the password?'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? "),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            Text('or continue with'),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Image.asset(
                    'assets/images/google_logo.png',
                    width: 50,
                    height: 50,
                  ),
                  onPressed: _signInWithGoogle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
