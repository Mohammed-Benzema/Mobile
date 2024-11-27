import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  final List<Map<String, String>> favoriteTrips;
  final Function(Map<String, String>) onRemove;

  FavoritesPage({required this.favoriteTrips, required this.onRemove});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الرحلات المفضلة'),
        backgroundColor: Colors.blue,
      ),
      body: widget.favoriteTrips.isEmpty
          ? Center(
              child: Text(
                'لا توجد رحلات مفضلة حالياً',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: widget.favoriteTrips.length,
              itemBuilder: (context, index) {
                final trip = widget.favoriteTrips[index];
                return Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  elevation: 5, // إضافة تأثير الظل
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0), // حواف دائرية
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12.0), // إضافة تباعد داخلي
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        trip['img']!,
                        width: 80.0,
                        height: 80.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      trip['title']!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      trip['subtitle']!,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          widget
                              .onRemove(trip); // حذف الرحلة من القائمة الأصلية
                        });
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
