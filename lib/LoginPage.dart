import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:trip_app/HomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Uint8List? _selectedImageBytes;

  // دالة لاختيار الصورة
  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final imageBytes = await pickedImage.readAsBytes();
      setState(() {
        _selectedImageBytes = imageBytes; // تخزين الصورة في المتغير
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.blue.shade50, // تغيير خلفية الصفحة إلى اللون الأزرق الفاتح
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // استبدال الأيقونة بالصورة المختارة من المستخدم (إذا كانت موجودة)
                if (_selectedImageBytes != null)
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: MemoryImage(_selectedImageBytes!),
                  )
                else
                  CircleAvatar(
                    radius: 60,
                    backgroundColor:
                        Colors.blue, // تغيير اللون الأساسي إلى الأزرق
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white, // تغيير الأيقونة إلى اللون الأسود
                    ),
                  ),

                SizedBox(height: 20),

                // إضافة زر لاختيار الصورة تحت الأيقونة أو الصورة المختارة
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: Colors.blue, // اللون الأزرق
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: Text('اختيار صورة',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),

                SizedBox(height: 30),

                // حقل إدخال اسم المستخدم
                _buildTextField(
                  controller: userController,
                  label: 'اسم المستخدم',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال اسم المستخدم';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                // حقل إدخال كلمة المرور
                _buildTextField(
                  controller: passwordController,
                  label: 'كلمة المرور',
                  icon: Icons.lock,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال كلمة المرور';
                    } else if (value.length < 6) {
                      return 'كلمة المرور يجب أن تكون أطول من 6 أحرف';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                // حقل إدخال البريد الإلكتروني
                _buildTextField(
                  controller: emailController,
                  label: 'البريد الإلكتروني',
                  icon: Icons.mail,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال البريد الإلكتروني';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return 'الرجاء إدخال بريد إلكتروني صالح';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 30),

                // زر تسجيل الدخول
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // إذا كانت الإدخالات صحيحة
                      String username = userController.text.trim();
                      String email = emailController.text.trim();

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            username: username,
                            email: email,
                            profileImageBytes: _selectedImageBytes,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: Colors.blue, // اللون الأزرق
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: Text('تسجيل الدخول',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget مخصص لإنشاء حقول الإدخال
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.black), // تغيير النص إلى اللون الأبيض
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
            TextStyle(color: Colors.black), // تغيير لون النص التسمية إلى الأسود
        prefixIcon:
            Icon(icon, color: Colors.black), // تغيير الأيقونة إلى اللون الأسود
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide:
              BorderSide(color: Colors.blue.shade300), // تحديد اللون الأزرق
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade300), // اللون الأزرق
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.blue), // اللون الأزرق عند التركيز
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      validator: validator,
    );
  }
}
