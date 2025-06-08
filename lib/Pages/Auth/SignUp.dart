// ignore: file_names
import 'package:app/Definitons/global.dart';
import 'package:app/Pages/Auth/InitialSetup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/Providers/UserProvider.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State, Center;
// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart'; // Thêm package để mã hóa mật khẩu
import 'dart:convert'; // Để sử dụng utf8.encode

import '../../Database/mongoDB.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _errorMessage;
  String? _passwordStrength;
  Color _passwordStrengthColor = Colors.grey;

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Hàm băm mật khẩu sử dụng SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Kiểm tra độ mạnh của mật khẩu
  void _checkPasswordStrength(String password) {
    setState(() {
      if (password.isEmpty) {
        _passwordStrength = null;
        _passwordStrengthColor = Colors.grey;
      } else if (password.length < 6) {
        _passwordStrength = 'Weak';
        _passwordStrengthColor = Colors.red;
      } else if (password.length < 10) {
        bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
        bool hasDigits = password.contains(RegExp(r'[0-9]'));
        bool hasSpecialCharacters =
            password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

        if (hasUppercase && hasDigits && hasSpecialCharacters) {
          _passwordStrength = 'Strong';
          _passwordStrengthColor = Colors.green;
        } else if ((hasUppercase && hasDigits) ||
            (hasUppercase && hasSpecialCharacters) ||
            (hasDigits && hasSpecialCharacters)) {
          _passwordStrength = 'Medium';
          _passwordStrengthColor = Colors.orange;
        } else {
          _passwordStrength = 'Weak';
          _passwordStrengthColor = Colors.red;
        }
      } else {
        bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
        bool hasDigits = password.contains(RegExp(r'[0-9]'));
        bool hasSpecialCharacters =
            password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

        if (hasUppercase && hasDigits && hasSpecialCharacters) {
          _passwordStrength = 'Strong';
          _passwordStrengthColor = Colors.green;
        } else if ((hasUppercase && hasDigits) ||
            (hasUppercase && hasSpecialCharacters) ||
            (hasDigits && hasSpecialCharacters)) {
          _passwordStrength = 'Medium';
          _passwordStrengthColor = Colors.orange;
        } else {
          _passwordStrength = 'Weak';
          _passwordStrengthColor = Colors.red;
        }
      }
    });
  }

  void _signUp() async {
    // Xóa thông báo lỗi cũ nếu có
    setState(() {
      _errorMessage = null;
    });

    // Kiểm tra các trường dữ liệu
    if (_userNameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields.';
      });
      return;
    }

    // Kiểm tra các trường dữ liệu
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields.';
      });
      return;
    }

    // Kiểm tra mật khẩu và xác nhận mật khẩu
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match.';
      });
      return;
    }

    // Kiểm tra định dạng email
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(emailPattern).hasMatch(_emailController.text)) {
      setState(() {
        _errorMessage = 'Invalid email format.';
      });
      return;
    }

    // Kiểm tra độ mạnh của mật khẩu
    if (_passwordController.text.length < 6) {
      setState(() {
        _errorMessage = 'Password must be at least 6 characters.';
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final usersCollection = await MongoDBDatabase.getCollection('Users');

      // Kiểm tra xem email đã tồn tại chưa
      final existingUser = await usersCollection.findOne(
          where.eq('email', _emailController.text.trim().toLowerCase()));
      if (existingUser != null) {
        setState(() {
          _errorMessage = 'Email already registered.';
          _isLoading = false;
        });
        return;
      }

      // Kiểm tra xem email đã tồn tại chưa
      final existingUserName = await usersCollection.findOne(
          where.eq('userName', _userNameController.text.trim().toLowerCase()));
      if (existingUserName != null) {
        setState(() {
          _errorMessage = 'UserName already registered.';
          _isLoading = false;
        });
        return;
      }

      // Mã hóa mật khẩu trước khi lưu vào DB
      final hashedPassword = _hashPassword(_passwordController.text.trim());

      // Tạo document mới cho người dùng
      final newUser = {
        // ignore: deprecated_member_use
        "userId": ObjectId().toHexString(),
        "email": _emailController.text.trim().toLowerCase(),
        "userName": _userNameController.text.trim(),
        "password": hashedPassword,
        "subscription": {
          "plan": "free",
          "tokensUsed": 0,
        },
        "createdAt": DateTime.now().toUtc().toIso8601String(),
        "updatedAt": DateTime.now().toUtc().toIso8601String(),
      };

      globalUserId = newUser['userId'] as String?;
      print(globalUserId);

      await usersCollection.insertOne(newUser);
      final nameFromDb = await MongoDBDatabase.getUserName(globalUserId!);
      final scoreFromDb =
          await MongoDBDatabase.getUserScoreString(globalUserId!);
      await MongoDBDatabase.upsertUserProgress(globalUserId!,
          name: nameFromDb, score: scoreFromDb);
      Provider.of<UserProvider>(context, listen: false).setUser(
        nameFromDb,
      );

      // Hiển thị thông báo thành công
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );

      // Sau khi đăng ký thành công, chuyển đến trang chính
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const InitialSetupPage(),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage =
            'Registration failed. Please try again. Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: const Text('Sign Up',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          // Hủy focus khi nhấn vào chỗ trống
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child:
                    Image.asset('assets/images/capy_signup.png', height: 180),
              ),
              const SizedBox(height: 20),
              const Text(
                'Create Your Account',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Please fill in the details below to sign up',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: _userNameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'UserName',
                  hintText: 'Enter your UserName',
                  prefixIcon: Icon(LineAwesomeIcons.envelope),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFFD3B591), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Icon(LineAwesomeIcons.envelope),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFFD3B591), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                onChanged: _checkPasswordStrength,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Create a password',
                  prefixIcon: Icon(LineAwesomeIcons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFFD3B591), width: 2),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? LineAwesomeIcons.eye
                          : LineAwesomeIcons.eye_slash,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              if (_passwordStrength != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10),
                  child: Row(
                    children: [
                      Text(
                        'Password Strength: ',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        _passwordStrength!,
                        style: TextStyle(
                          fontSize: 12,
                          color: _passwordStrengthColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Confirm your password',
                  prefixIcon: Icon(LineAwesomeIcons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFFD3B591), width: 2),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? LineAwesomeIcons.eye
                          : LineAwesomeIcons.eye_slash,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (_errorMessage != null)
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD3B591),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'SIGN UP',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      'LOG IN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD3B591),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
