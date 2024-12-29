import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Meal Menu")),
        body: menuData == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
            itemCount: menuData!.length,
            itemBuilder: (context, index) {
              final menu = menuData![index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    "${menu['date']} - ${menu['day']}",
                    style: TextStyle(fontSize: 24),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Soup: ${menu['soup']} \n (${menu['soup_calories']} kcal)",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      Text(
                        "Main Dish: ${menu['main_course']} \n (${menu['main_course_calories']} kcal)",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      Text(
                        "Vegetarian: ${menu['vegetarian']} \n (${menu['vegetarian_calories']} kcal)",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      Text(
                        "Side Dish: ${menu['side_dish']} \n (${menu['side_dish_calories']} kcal)",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      Text(
                        "Complementary: ${menu['complementary']} \n (${menu['complementary_calories']} kcal)",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      Text(
                        "Total Calories: ${menu['total_calories']} ",
                        style: TextStyle(fontSize: 25.0),
                      ),
                    ],
                  ),
                ),
              );
            },
            ),
        );
    }
}
