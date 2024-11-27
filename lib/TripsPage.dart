import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:trip_app/BookingPage.dart';
import 'package:trip_app/EditProfilePage.dart';
import 'package:trip_app/favoritePage.dart';
import 'package:trip_app/LoginPage.dart'; // استيراد صفحة تسجيل الدخول

class TripsPage extends StatefulWidget {
  final String username;
  final String email;
  final Uint8List? profileImageBytes;

  TripsPage({
    required this.username,
    required this.email,
    this.profileImageBytes,
  });

  @override
  _TripsPageState createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  final List<Map<String, String>> favoriteTrips = [];
  late String username;
  late String email;
  Uint8List? profileImageBytes;

  @override
  void initState() {
    super.initState();
    username = widget.username; // تخزين الاسم في متغير محلي
    email = widget.email; // تخزين البريد الإلكتروني في متغير محلي
    profileImageBytes = widget.profileImageBytes; // تعيين الصورة الشخصية
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الرحلات المتاحة'),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.blue.shade800),
              accountName: Text(username,
                  style: TextStyle(fontSize: 18)), // عرض الاسم المحدث
              accountEmail: Text(email), // عرض البريد الإلكتروني المحدث
              currentAccountPicture: CircleAvatar(
                backgroundImage: profileImageBytes != null
                    ? MemoryImage(profileImageBytes!) // عرض الصورة المحدثة
                    : AssetImage('images/1729888241212.jpg')
                        as ImageProvider, // صورة افتراضية إذا لم تكن موجودة
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('تعديل البروفايل'),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(
                      currentUsername: username, // إرسال الاسم الحالي
                      currentEmail: email, // إرسال البريد الحالي
                      currentProfileImage: profileImageBytes, // إرسال الصورة
                    ),
                  ),
                );

                if (result != null) {
                  setState(() {
                    username = result['username']; // تحديث الاسم بعد التعديل
                    email =
                        result['email']; // تحديث البريد الإلكتروني بعد التعديل
                    profileImageBytes =
                        result['profileImage']; // تحديث الصورة بعد التعديل
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_car),
              title: Text('الرحلات'),
              onTap: () {
                Navigator.pop(context); // غلق القائمة
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('المفضلة'),
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
              leading: Icon(Icons.logout),
              title: Text('تسجيل الخروج'),
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
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildTripCard(
            context,
            'رحلة إلى الصحراء الكبرى',
            'مدة الرحلة: 3 أيام',
            'images/saharadesert.webp',
          ),
          _buildTripCard(
            context,
            'رحلة إلى الجبال البيضاء',
            'مدة الرحلة: 5 أيام',
            'images/BduQDTDCYAIUvHN.jpg',
          ),
          _buildTripCard(
            context,
            'رحلة إلى وادي القمر',
            'مدة الرحلة: يوم واحد',
            'images/Eto-mAoWgAQwtck.jpg',
          ),
          _buildTripCard(
            context,
            'رحلة إلى الشواطئ الذهبية',
            'مدة الرحلة: 4 أيام',
            'images/most-beautiful-beaches-italy.webp',
          ),
          _buildTripCard(
            context,
            'رحلة إلى الغابات المطيرة',
            'مدة الرحلة: 7 أيام',
            'images/-المطيرة-في-ماليزيا-jpg.webp',
          ),
          _buildTripCard(
            context,
            'رحلة إلى مدينة الأنوار',
            'مدة الرحلة: 3 أيام',
            'images/برج-ايفل-باريس.jpg.webp',
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard(
      BuildContext context, String title, String subtitle, String img) {
    final isFavorite = favoriteTrips.any((trip) => trip['title'] == title);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(
            img,
            width: 60.0,
            height: 60.0,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: () {
            setState(() {
              if (isFavorite) {
                favoriteTrips.removeWhere((trip) => trip['title'] == title);
              } else {
                favoriteTrips.add({
                  'title': title,
                  'subtitle': subtitle,
                  'img': img,
                });
              }
            });
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingPage(
                tripTitle: title,
                tripSubtitle: subtitle,
                tripImage: img,
              ),
            ),
          );
        },
      ),
    );
  }
}
