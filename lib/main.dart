import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'login_page.dart';
import 'main_page.dart';
import 'notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase'i başlatıyoruz
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Firebase bildirim servisini başlatıyoruz
    NotificationService.initialize(context);
    _getFirebaseMessagingToken(); // Token'ı alıyoruz
  }

  // Firebase Messaging token'ını alıp ekrana yazdıran fonksiyon
  void _getFirebaseMessagingToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Token'ı almak için asenkron fonksiyon kullanıyoruz
    String? token = await messaging.getToken();

    // Token'ı aldığımıza emin oluyoruz
    if (token != null) {
      print("Firebase Messaging Token: $token");
      // Token'ı ekranda gösterebiliriz
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Token: $token")));
    } else {
      print("Token alınamadı.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData) {
          return MainPage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
