import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:life_on_campus/daily_menu.dart';
import 'clubs_page.dart';
import 'to-do.dart';
import 'login_page.dart'; // Import the login page to navigate back after logout
import 'package:url_launcher/url_launcher.dart'; // For launching URLs

class MainPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize Firebase Auth

  // Navigate to different pages based on the screenName
  void navigateTo(BuildContext context, String screenName) {
    if (screenName == 'Clubs') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ClubsPage()), // Navigate to ClubsPage
      );
    } else if (screenName == 'To-Dos') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ToDoHomePage()), // Navigate to ToDoHomePage
      );
    }else if (screenName == 'Daily Menu') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MealMenuScreen()), // Navigate to ToDoHomePage
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlaceholderScreen(screenName)),
      );
    }
  }

  // Logout function to sign out the user and navigate back to the login page
  void _logout(BuildContext context) async {
    try {
      await _auth.signOut(); // Sign out from Firebase

      // Navigate to login page and remove all previous routes
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false, // Remove all routes
      );
    } catch (e) {
      // Display a message if logout fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log out. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Life on Campus',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white, // Set the icon color to white
              ),
              onPressed: () => _logout(context), // Call the logout function when pressed
            ),
          ],
          backgroundColor: Colors.transparent, // Make the background transparent
          elevation: 0, // Remove the shadow
          flexibleSpace: Container(
            color: Colors.black, // Ensure no background color
          ),
        ),


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
                  // Booked page button (opens external link)
                  GestureDetector(
                    onTap: () => _launchBooked(),
                    child: Image.asset(
                      'assets/booked_page.png', // Booked PNG file
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

// Placeholder screen for other pages (like Daily Menu)
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
