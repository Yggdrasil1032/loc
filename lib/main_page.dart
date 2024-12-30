// File: main_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore for user roles and notifications
import 'package:life_on_campus/weather_page.dart';
import 'daily_menu.dart'; // Replace with the correct path to the daily_menu.dart file
import 'clubs_page.dart'; // Replace with the correct path to the clubs_page.dart file
import 'to-do.dart'; // Replace with the correct path to the to-do.dart file
import 'login_page.dart'; // Replace with the correct path to the login_page.dart file
import 'notification_page.dart'; // Import the new NotificationPage file
import 'package:url_launcher/url_launcher.dart'; // For launching URLs

class MainPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize Firebase Auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Initialize Firestore

  // Navigate to different pages based on the screenName
  void navigateTo(BuildContext context, String screenName, String role) {
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
    } else if (screenName == 'Daily Menu') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MealMenuScreen()), // Navigate to Daily Menu
      );
    } else if (screenName == 'Notification Page') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotificationPage(role: role)), // Navigate to NotificationPage
      );
    } else if(screenName == 'Wheather Page'){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => WeatherPage()));
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

  Future<String> _getUserRole() async {
    final user = _auth.currentUser;
    if (user == null) {
      return 'member'; // Default role for unauthenticated users
    }
    try {
      if (user.email == "test2@gmail.com") {
        return 'admin'; // Automatically assign admin role to test2@gmail.com
      }
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.data()?['role'] ?? 'member';
    } catch (e) {
      return 'member';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final role = snapshot.data ?? 'member';

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Life on Campus',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.cloud,
                color: Colors.white,
                ),
                onPressed: () => navigateTo(context, 'Wheather Page', role),
              ),
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: Colors.white, // Set the icon color to white
                ),
                onPressed: () => navigateTo(context, 'Notification Page', role), // Navigate to Notification Page
              ),
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white, // Set the icon color to white
                ),
                onPressed: () => _logout(context), // Call the logout function when pressed
              ),
            ],
            backgroundColor: Colors.black87, // Make the background transparent
            elevation: 0, // Remove the shadow

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
                        onTap: () => navigateTo(context, 'Clubs', role),
                        child: Image.asset(
                          'assets/clubs.png', // Clubs PNG file
                          width: 150,
                        ),
                      ),
                      SizedBox(width: 10),
                      // Daily Menu button
                      GestureDetector(
                        onTap: () => navigateTo(context, 'Daily Menu', role),
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
                        onTap: () => navigateTo(context, 'To-Dos', role),
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
      },
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