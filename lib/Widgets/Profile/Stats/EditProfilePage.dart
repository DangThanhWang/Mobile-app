import 'package:app/Database/mongoDB.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart' hide State, Center;
import 'package:provider/provider.dart';
import 'package:app/Providers/UserProvider.dart';

import 'package:app/Definitons/global.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _photoUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Load thông tin người dùng từ MongoDB
  Future<void> _loadUserProfile() async {
    if (globalUserId == null) return;

    try {
      final usersCollection = await MongoDBDatabase.getCollection('Users');
      final user =
          await usersCollection.findOne(where.eq('userId', globalUserId));

      if (user != null) {
        setState(() {
          _nameController.text = user['userName'] ?? '';
          _emailController.text = user['email'] ?? '';
          _photoUrl = user['photoURL'];
        });
      }
    } catch (e) {
      print('Error loading user profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải thông tin người dùng: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    // Mở thư viện ảnh
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      try {
        // Hiển thị loading
        setState(() {
          _isLoading = true;
        });

        // Trong thực tế, bạn sẽ cần upload ảnh lên cloud storage (Firebase Storage, AWS S3, etc.)
        // Ở đây tôi sẽ lưu đường dẫn local tạm thời
        // Bạn cần implement phần upload ảnh lên server của mình

        setState(() {
          _photoUrl = image.path; // Tạm thời dùng local path
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã chọn ảnh thành công')),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi chọn ảnh: $e')),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      if (globalUserId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy thông tin người dùng')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final usersCollection = await MongoDBDatabase.getCollection('Users');

        // Kiểm tra xem userName mới đã tồn tại chưa (nếu khác với userName hiện tại)
        final currentUser =
            await usersCollection.findOne(where.eq('userId', globalUserId));

        if (currentUser != null &&
            currentUser['userName'] != _nameController.text.trim()) {
          final existingUser = await usersCollection.findOne(
              where.eq('userName', _nameController.text.trim().toLowerCase()));

          if (existingUser != null) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tên người dùng đã tồn tại')),
            );
            return;
          }
        }

        // Cập nhật thông tin người dùng
        final updateData = {
          'userName': _nameController.text.trim(),
          'updatedAt': DateTime.now().toUtc().toIso8601String(),
        };

        // Chỉ cập nhật photoURL nếu có ảnh mới
        if (_photoUrl != null && _photoUrl!.isNotEmpty) {
          updateData['photoURL'] = _photoUrl!;
        }

        await usersCollection.updateOne(
            where.eq('userId', globalUserId),
            modify
                .set('userName', updateData['userName'])
                .set('updatedAt', updateData['updatedAt'])
                .set('photoURL', updateData['photoURL'] ?? ''));

        // Cập nhật các biến global
        globalUserName = _nameController.text.trim();
        if (currentUser != null) {
          gmailUser = currentUser['email'];
        }

        final scoreFromDb =
          await MongoDBDatabase.getUserScoreString(globalUserId!);
        await MongoDBDatabase.upsertUserProgress(
          globalUserId!,
          name: _nameController.text.trim(),
          score: scoreFromDb,
        );
        Provider.of<UserProvider>(context, listen: false)
            .setUserName(_nameController.text.trim());

        setState(() {
          _isLoading = false;
        });

        // Trả kết quả về UserProfilePage
        Navigator.pop(context, {
          'name': _nameController.text.trim(),
          'photoUrl': _photoUrl,
          'email': _emailController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Hồ sơ đã được cập nhật thành công. ${_nameController.text} ')),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
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
        title: const Text('Chỉnh sửa hồ sơ'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                AssetImage('assets/images/avatar_default.jpeg'),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xFFD3B591),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Tên người dùng',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Color(0xFFD3B591), width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tên không được để trống';
                        }
                        if (value.length < 3) {
                          return 'Tên phải có ít nhất 3 ký tự';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                      ),
                      enabled: false, // Tắt khả năng chỉnh sửa email
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD3B591),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Lưu thay đổi',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
