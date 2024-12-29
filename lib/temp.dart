import 'package:flutter/material.dart';
import 'clubs_page.dart';
import 'to-do.dart';
// Import the new clubs page
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  void navigateTo(BuildContext context, String screenName) {
    if (screenName == 'Clubs') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ClubsPage()), // Navigate to the ClubsPage
      );
    }
    else if (screenName == 'To-Dos') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ToDoHomePage()), // ToDoHomePage widget'ını çağırıyoruz
      );
    }
    else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlaceholderScreen(screenName)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img_background_design.png'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Clubs button
                  GestureDetector(
                    onTap: () => navigateTo(context, 'Clubs'),
                    child: Image.asset(
                      'assets/clubs.png', // Clubs PNG file
                      width: 150,
                    ),
                  ),
                  SizedBox(width: 10),
                  // Daily Menu button
                  GestureDetector(
                    onTap: () => navigateTo(context, 'Daily Menu'),
                    child: Image.asset(
                      'assets/daily_menu.png', // Daily Menu PNG file
                      width: 150,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Maps button
                  GestureDetector(
                    onTap: () => _launchBooked(),
                    child: Image.asset(
                      'assets/booked_page.png', // Maps PNG file
                      width: 165,
                    ),
                  ),
                  SizedBox(width: 10),
                  // To-Dos button
                  GestureDetector(
                    onTap: () => navigateTo(context, 'To-Dos'),
                    child: Image.asset(
                      'assets/todo.png', // To-Dos PNG file
                      width: 160,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder screen for other pages
class PlaceholderScreen extends StatelessWidget {
  final String screenName;

  PlaceholderScreen(this.screenName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(screenName),
      ),
      body: Center(
        child: Text(
          'Welcome to $screenName!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

// URL launcher for the Booked page
final String url = "https://booked.agu.edu.tr/Web/";

void _launchBooked() async {
  Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}
