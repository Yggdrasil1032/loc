import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'clubs_page.dart';
import 'daily_menu.dart';
import 'main_page.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WeatherPage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final String apiKey = 'b1152877f63e201b2f694e3001d0a4ae'; // Replace with your OpenWeatherMap API Key
  final String city = 'Kayseri';
  Map<String, List<dynamic>> groupedForecast = {};
  String selectedDate = '';

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Sayfa geçişleri
    if (index == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ClubsPage()),
            (Route<dynamic> route) => false, // Tüm önceki sayfaları temizler
      );
    } else if (index == 1) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
            (Route<dynamic> route) => false, // Tüm önceki sayfaları temizler
      );
    } else if (index == 2) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MealMenuScreen()),
            (Route<dynamic> route) => false, // Tüm önceki sayfaları temizler
      );
    }
  }



  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&units=metric&appid=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> list = data['list'];
        final Map<String, List<dynamic>> grouped = {};

        for (var item in list) {
          final dateTime = item['dt_txt'];
          final date = dateTime.split(' ')[0];
          final formattedDate = formatDate(date); // Format the date as dd/MM/yyyy
          if (!grouped.containsKey(formattedDate)) {
            grouped[formattedDate] = [];
          }
          grouped[formattedDate]!.add(item);
        }

        setState(() {
          groupedForecast = grouped;
          selectedDate = grouped.keys.first;
        });
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String formatDate(String date) {
    final parts = date.split('-');
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img_background_design.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 50),
            Text(
              'Kayseri 5 Günlük Hava Durumu',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: groupedForecast.keys.map((date) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: selectedDate == date ? Colors.teal : Colors.white54,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        date,
                        style: TextStyle(
                          color: selectedDate == date ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: groupedForecast.isEmpty
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : ListView.builder(
                itemCount: groupedForecast[selectedDate]?.length ?? 0,
                itemBuilder: (context, index) {
                  final item = groupedForecast[selectedDate]![index];
                  final time = item['dt_txt'].split(' ')[1];
                  final temp = item['main']['temp'];
                  final weather = item['weather'][0]['description'];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0), // Adds vertical space between each item
                    child: Card(
                      color: Colors.white70,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.cloud,
                            color: Colors.white,
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$weather | Temp: $temp°C',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '$time',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Clubs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Daily Menu',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white70,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black87,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 15,
        ),
        onTap: _onItemTapped,
        elevation: 8,
        type: BottomNavigationBarType.fixed, // Düz tasarım
      ),
    );
  }
}
