import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // URL açmak için gerekli paket

class ClubsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Kulüplerin isimleri, resimleri ve Instagram linkleri
    final List<Map<String, String>> clubs = [
      {"name": "IEEE", "image": "assets/ieee.png", "instagram": "https://www.instagram.com/ieee_agu/"},
      {"name": "Sci-Tech", "image": "assets/sci_tech.png", "instagram": "https://instagram.com/sci_tech"},
      {"name": "Alumni", "image": "assets/alumni.png", "instagram": "https://instagram.com/alumni"},
      {"name": "Kültür Edebiyat", "image": "assets/kultur.png", "instagram": "https://instagram.com/kultur"},
      {"name": "Personal Net.", "image": "assets/pernet.png", "instagram": "https://instagram.com/pernet"},
      {"name": "Tech. In.", "image": "assets/techino.png", "instagram": "https://instagram.com/techino"},
      {"name": "Yapı", "image": "assets/yapi.png", "instagram": "https://instagram.com/yapi"},
      {"name": "Lösev", "image": "assets/losev.png", "instagram": "https://instagram.com/losev"},
      {"name": "SWE", "image": "assets/swe.png", "instagram": "https://instagram.com/swe"},
      {"name": "Women in Business", "image": "assets/wib.png", "instagram": "https://instagram.com/wib"},
      {"name": "Kızılay", "image": "assets/kizilay.png", "instagram": "https://instagram.com/kizilay"},
      {"name": "Computer Society", "image": "assets/computersoc.png", "instagram": "https://instagram.com/computersoc"},
      {"name": "Business", "image": "assets/business.png", "instagram": "https://instagram.com/business"},
      {"name": "Genç Tema", "image": "assets/tema.png", "instagram": "https://instagram.com/tema"},
      {"name": "Gaming", "image": "assets/gaming.png", "instagram": "https://instagram.com/gaming"},
      {"name": "YAK", "image": "assets/yoneylem.png", "instagram": "https://instagram.com/yoneylem"},
      {"name": "Sports", "image": "assets/sports.png", "instagram": "https://instagram.com/sports"},
      {"name": "Idea Camp", "image": "assets/idea.png", "instagram": "https://instagram.com/idea"},
      {"name": "Inter. Assoc.", "image": "assets/aia.png", "instagram": "https://instagram.com/aia"},
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img_background_design.png'), // Arka plan görseli
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
                      final String? url = clubs[index]['instagram'];
                      if (url != null && await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url)); // Instagram linkini aç
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Instagram linki açılamıyor')),
                        );
                      }
                    },
                    child: CircleAvatar(
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
    );
  }
}
