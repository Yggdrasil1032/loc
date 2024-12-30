import 'package:flutter/material.dart';
import 'package:life_on_campus/to-do.dart';
import 'package:url_launcher/url_launcher.dart'; // URL açmak için gerekli paket

import 'main_page.dart'; // MainPage() sayfası için gerekli import
import 'daily_menu.dart'; // MealMenuScreen() sayfası için gerekli import
import 'to-do.dart'; // ToDoHomePage() sayfası için gerekli import

class ClubsPage extends StatefulWidget {
  @override
  _ClubsPageState createState() => _ClubsPageState();
}

class _ClubsPageState extends State<ClubsPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigasyon kontrolü
    if (index == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
            (Route<dynamic> route) => false, // Tüm önceki sayfaları temizler
      );
    } else if (index == 1) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MealMenuScreen()),
            (Route<dynamic> route) => false, // Tüm önceki sayfaları temizler
      );
    } else if (index == 2) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ToDoHomePage()),
            (Route<dynamic> route) => false, // Tüm önceki sayfaları temizler
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Kulüplerin isimleri, resimleri ve Instagram linkleri
    final List<Map<String, String>> clubs = [
      {
        "name": "IEEE",
        "image": "assets/ieee.png",
        "instagram": "https://www.instagram.com/ieee_agu/"
      },
      {
        "name": "Sci-Tech",
        "image": "assets/sci_tech.png",
        "instagram": "https://instagram.com/agu_scitech"
      },
      {
        "name": "Alumni",
        "image": "assets/alumni.png",
        "instagram": "https://instagram.com/agualumniclub"
      },
      {
        "name": "Kültür Edebiyat",
        "image": "assets/kultur.png",
        "instagram": "https://instagram.com/aguedebiyat"
      },
      {
        "name": "Personal Net.",
        "image": "assets/pernet.png",
        "instagram": "https://instagram.com/personal.networking"
      },
      {
        "name": "Tech. In.",
        "image": "assets/techino.png",
        "instagram": "https://instagram.com/agutechnicalinnovationclub"
      },
      {
        "name": "Yapı",
        "image": "assets/yapi.png",
        "instagram": "https://instagram.com/aguyapikulubu"
      },
      {
        "name": "Lösev",
        "image": "assets/losev.png",
        "instagram": "https://instagram.com/agulosev"
      },
      {
        "name": "SWE",
        "image": "assets/swe.png",
        "instagram": "https://instagram.com/swe_agu"
      },
      {
        "name": "Women in Business",
        "image": "assets/wib.png",
        "instagram": "https://instagram.com/aguwomeninbusiness"
      },
      {
        "name": "Kızılay",
        "image": "assets/kizilay.png",
        "instagram": "https://instagram.com/genckizilayagu"
      },
      {
        "name": "Computer Society",
        "image": "assets/compsoc.png",
        "instagram": "https://instagram.com/agucomputersociety"
      },
      {
        "name": "Business",
        "image": "assets/business.png",
        "instagram": "https://instagram.com/agubusinessclub"
      },
      {
        "name": "Genç Tema",
        "image": "assets/tema.png",
        "instagram": "https://instagram.com/agugenctema"
      },
      {
        "name": "Gaming",
        "image": "assets/gaming.png",
        "instagram": "https://instagram.com/agugamingclub"
      },
      {
        "name": "YAK",
        "image": "assets/yoneylem.png",
        "instagram": "https://instagram.com/aguyak"
      },
      {
        "name": "Sports",
        "image": "assets/sports.png",
        "instagram": "https://instagram.com/agu_sports"
      },
      {
        "name": "Idea Camp",
        "image": "assets/idea.png",
        "instagram": "https://instagram.com/aguidc"
      },
      {
        "name": "Inter. Assoc.",
        "image": "assets/aia.png",
        "instagram": "https://instagram.com/aia_agu"
      },
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img_background_design.png'),
            // Arka plan görseli
            fit: BoxFit.cover, // Resmi ekrana göre boyutlandır
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Ekranda satır başına 3 öğe
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: clubs.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final String? url = clubs[index]['instagram']; // URL alınır
                      if (url != null) {
                        final Uri uri = Uri.parse(url);
                        try {
                          // Try opening the URL in the in-app WebView
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.inAppWebView, // Try to open inside the app
                            );
                          } else {
                            // If inAppWebView failed, open the URL in the external browser
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication, // Open in external browser
                            );
                          }
                        } catch (e) {
                          // Catch any errors that occur during URL launching
                          debugPrint("Hata oluştu: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Bir hata oluştu: $e')),
                          );
                        }
                      }
                    }
                    , child: CircleAvatar(
                      backgroundImage: AssetImage(clubs[index]['image']!),
                      radius: 40,
                    ),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  clubs[index]['name']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_outlined),
            activeIcon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            activeIcon: Icon(Icons.check_circle),
            label: 'To-Do',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white70,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11,
        ),
        onTap: _onItemTapped,
        elevation: 8,
        type: BottomNavigationBarType.fixed, // Düz tasarım
      ),

    );
  }
}