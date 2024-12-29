import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:life_on_campus/to-do.dart';

import 'clubs_page.dart'; // ClubsPage sınıfının bulunduğu dosya
import 'main_page.dart'; // MainPage sınıfının bulunduğu dosya
import 'to-do.dart'; // ToDoHomePage sınıfının bulunduğu dosya

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MealMenuScreen(),
    );
  }
}

class MealMenuScreen extends StatefulWidget {
  @override
  _MealMenuScreenState createState() => _MealMenuScreenState();
}

class _MealMenuScreenState extends State<MealMenuScreen> {
  List<Map<String, dynamic>>? menuData;
  int _selectedIndex = 1; // Başlangıçta bu sayfa seçili olacak.

  @override
  void initState() {
    super.initState();
    loadExcelFile();
  }

  Future<void> loadExcelFile() async {
    final bytes = await rootBundle.load('assets/aralikmenu2024.xlsx');
    final excel = Excel.decodeBytes(bytes.buffer.asUint8List());

    List<Map<String, dynamic>> tempData = [];

    for (var table in excel.tables.keys) {
      final sheet = excel.tables[table]!;
      for (var rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
        final row = sheet.rows[rowIndex];

        // Parse and format the date
        String? formattedDate;
        if (row[0]?.value != null) {
          DateTime? date = DateTime.tryParse(row[0]?.value.toString() ?? '');
          if (date != null) {
            formattedDate = DateFormat('dd/MM/yyyy').format(date);
          }
        }

        tempData.add({
          "date": formattedDate ?? row[0]?.value,
          "day": row[1]?.value,
          "soup": row[2]?.value,
          "soup_calories": row[3]?.value,
          "main_course": row[4]?.value,
          "main_course_calories": row[5]?.value,
          "vegetarian": row[6]?.value,
          "vegetarian_calories": row[7]?.value,
          "side_dish": row[8]?.value,
          "side_dish_calories": row[9]?.value,
          "complementary": row[10]?.value,
          "complementary_calories": row[11]?.value,
          "total_calories": row[12]?.value,
        });
      }
    }

    setState(() {
      menuData = tempData;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Sayfa geçişleri
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ClubsPage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MealMenuScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ToDoHomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meal Menu"),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img_background_design.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: menuData == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: menuData!.length,
          itemBuilder: (context, index) {
            final menu = menuData![index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 6,
              color: Colors.white70,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${menu['date']} - ${menu['day']}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[800],
                      ),
                    ),
                    Divider(color: Colors.black, thickness: 1),
                    _buildMenuItem(
                      title: "Soup",
                      value: menu['soup'],
                      calories: menu['soup_calories'],
                    ),
                    _buildMenuItem(
                      title: "Main Dish",
                      value: menu['main_course'],
                      calories: menu['main_course_calories'],
                    ),
                    _buildMenuItem(
                      title: "Vegetarian",
                      value: menu['vegetarian'],
                      calories: menu['vegetarian_calories'],
                    ),
                    _buildMenuItem(
                      title: "Side Dish",
                      value: menu['side_dish'],
                      calories: menu['side_dish_calories'],
                    ),
                    _buildMenuItem(
                      title: "Complementary",
                      value: menu['complementary'],
                      calories: menu['complementary_calories'],
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Total Calories: ${menu['total_calories']} kcal",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Clubs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'To-Do',
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({required String title, dynamic value, dynamic calories}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$title:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.teal[600],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              "$value (${calories ?? 0} kcal)",
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }
}
