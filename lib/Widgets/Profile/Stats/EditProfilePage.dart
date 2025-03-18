import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _nameController.text = user?.displayName ?? '';
    _emailController.text = user?.email ?? '';
    _photoUrl = user?.photoURL;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    // Mở thư viện ảnh
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      try {
        // Tải ảnh lên Firebase Storage
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_pictures')
            .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
        await ref.putFile(File(image.path)); // Tải ảnh lên Firebase Storage
        final imageUrl = await ref.getDownloadURL();

        setState(() {
          _photoUrl = imageUrl; // Cập nhật ảnh
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải ảnh: $e')),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Cập nhật tên và ảnh
        await user?.updateDisplayName(_nameController.text);
        if (_photoUrl != null) {
          await user?.updatePhotoURL(_photoUrl);
        }

        // Làm mới thông tin người dùng
        await FirebaseAuth.instance.currentUser?.reload();
        final updatedUser = FirebaseAuth.instance.currentUser;

        // Trả kết quả về UserProfilePage
        Navigator.pop(context, {
          'name': updatedUser?.displayName,
          'photoUrl': updatedUser?.photoURL,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hồ sơ đã được cập nhật thành công.')),
        );
      } catch (e) {
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
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(LineAwesomeIcons.angle_left)),
        title: const Text('Chỉnh sửa hồ sơ'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _photoUrl != null
                      ? NetworkImage(_photoUrl!)
                      : const AssetImage('assets/images/avatar_default.jpeg')
                  as ImageProvider,
                  child: const Icon(
                    Icons.camera_alt,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Tên',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tên không được để trống';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                enabled: false,  // Tắt khả năng chỉnh sửa
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2C1B05),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Lưu thay đổi',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
