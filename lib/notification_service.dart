import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  // Arka planda gelen bildirimleri işleyen handler
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Arka planda mesaj geldi: ${message.messageId}');
  }

  // Bildirimler için kurulum
  static Future<void> initialize(BuildContext context) async {
    // Token alma (gerekirse sunucuya bu token'ı kaydedebilirsiniz)
    FirebaseMessaging.instance.getToken().then((token) {
      print("FCM Token: $token"); // Kullanıcıya ait token
    });

    // Uygulama açıkken gelen bildirimleri dinleme
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mesaj geldi: ${message.notification?.title}, ${message.notification?.body}');
      // Gelen mesajı göster
      _showNotificationDialog(context, message);
    });

    // Uygulama arka plandayken gelen ve bildirime tıklanarak açılan mesajlar
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Mesaja tıklandı: ${message.notification?.title}');
    });

    // Arka planda gelen mesajlar için handler'ı tanımlıyoruz
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  // Bildirimi bir dialog içinde gösterme
  static void _showNotificationDialog(BuildContext context, RemoteMessage message) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(message.notification?.title ?? "Bildirim"),
          content: Text(message.notification?.body ?? "Bir bildirim aldınız."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Tamam"),
            )
          ],
        );
      },
    );
  }
}
