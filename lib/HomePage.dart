import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:trip_app/TripsPage.dart';
import 'package:trip_app/EditProfilePage.dart';
import 'package:trip_app/favoritePage.dart';
import 'package:trip_app/LoginPage.dart'; // استيراد صفحة تسجيل الدخول

class HomePage extends StatefulWidget {
  final String username;
  final String email;
  final Uint8List? profileImageBytes; // استقبال الصورة الشخصية

  const HomePage({
    super.key,
    required this.username,
    required this.email,
    this.profileImageBytes, // استلام الصورة هنا
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> favoriteTrips = [];
  late String username;
  late String email;
  Uint8List? profileImageBytes; // متغير لتخزين الصورة

  @override
  void initState() {
    super.initState();
    username = widget.username;
    email = widget.email;
    profileImageBytes = widget.profileImageBytes; // تعيين الصورة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الصفحة الرئيسية',
            style: TextStyle(fontFamily: 'Roboto', fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.blue, // لون خلفية شريط العنوان
        elevation: 10,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.blue.shade800),
              accountName: Text(username,
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              accountEmail:
                  Text(email, style: TextStyle(color: Colors.white70)),
              currentAccountPicture: CircleAvatar(
                backgroundImage: profileImageBytes != null
                    ? MemoryImage(profileImageBytes!) // عرض الصورة المحدثة
                    : AssetImage("images/1729888241212.jpg")
                        as ImageProvider, // صورة افتراضية إذا لم تكن موجودة
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.black),
              title: Text('تعديل البروفايل', style: TextStyle(fontSize: 16)),
              onTap: () async {
                // التنقل إلى صفحة تعديل البروفايل وانتظار النتائج
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(
                      currentUsername: username,
                      currentEmail: email,
                      currentProfileImage: profileImageBytes, // تمرير الصورة
                    ),
                  ),
                );

                // تحديث البيانات إذا كانت موجودة
                if (result != null) {
                  setState(() {
                    username = result['username'];
                    email = result['email'];
                    profileImageBytes = result['profileImage']; // تحديث الصورة
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_car, color: Colors.black),
              title: Text('الرحلات', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TripsPage(
                      username: username,
                      email: email,
                      profileImageBytes: profileImageBytes, // تمرير الصورة
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite, color: Colors.black),
              title: Text('المفضلة', style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritesPage(
                      favoriteTrips: favoriteTrips,
                      onRemove: (trip) {
                        setState(() {
                          favoriteTrips.remove(trip);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            Spacer(), // ملء المساحة الفارغة لدفع العناصر للأسفل
            Divider(), // خط فاصل
            ListTile(
              leading: Icon(Icons.logout, color: Colors.black),
              title: Text('تسجيل الخروج', style: TextStyle(fontSize: 16)),
              onTap: () {
                // الانتقال إلى صفحة تسجيل الدخول مع تنظيف المكدس
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false, // تنظيف جميع الصفحات السابقة
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'مرحبًا بكم في تطبيق وسيط للرحلات البرية!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TripsPage(
                      username: username,
                      email: email,
                      profileImageBytes: profileImageBytes, // تمرير الصورة
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700, // اللون الأزرق
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
              child: Text(
                'استكشاف الرحلات',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
