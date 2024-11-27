import 'package:flutter/material.dart';
import 'package:trip_app/PaymentPage.dart';

class BookingPage extends StatefulWidget {
  final String tripTitle;
  final String tripSubtitle;
  final String tripImage;

  BookingPage({
    required this.tripTitle,
    required this.tripSubtitle,
    required this.tripImage,
  });

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _peopleController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void dispose() {
    // تحرير الموارد عند التخلص من الصفحة
    _nameController.dispose();
    _peopleController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // يبدأ من اليوم الحالي
      firstDate: DateTime.now(), // لا يمكن اختيار تاريخ قبل اليوم الحالي
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('حجز الرحلة'),
        backgroundColor: Colors.blue,
      ),
      resizeToAvoidBottomInset:
          true, // يضمن تعديل الشاشة عند ظهور لوحة المفاتيح
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عرض صورة الرحلة
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  widget.tripImage,
                  width: double.infinity,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 15),
              // عرض عنوان الرحلة
              Text(
                widget.tripTitle,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 5),
              // عرض وصف الرحلة
              Text(
                widget.tripSubtitle,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 25),

              // حقل الاسم الكامل
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'الاسم الكامل',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الاسم الكامل';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),

              // حقل عدد الأشخاص
              TextFormField(
                controller: _peopleController,
                decoration: InputDecoration(
                  labelText: 'عدد الأشخاص',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال عدد الأشخاص';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'الرجاء إدخال رقم صحيح';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),

              // حقل التاريخ
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'التاريخ (YYYY-MM-DD)',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء اختيار التاريخ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // زر متابعة للدفع
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'متابعة للدفع',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
