import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firebase Firestore

class NotificationPage extends StatefulWidget {
  final String role;

  NotificationPage({required this.role});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final TextEditingController _notificationController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to post a notification
  Future<void> _postNotification() async {
    if (_notificationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid notification.')),
      );
      return;
    }

    try {
      await _firestore.collection('notifications').add({
        'content': _notificationController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification posted successfully!')),
      );

      _notificationController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post notification. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Column(
        children: [
          if (widget.role == 'admin') ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _notificationController,
                    decoration: InputDecoration(
                      labelText: 'Post a Notification',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _postNotification,
                    child: Text('Post Notification'),
                  ),
                ],
              ),
            ),
          ],
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('notifications')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No notifications available.'));
                }

                final notifications = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index].data() as Map<String, dynamic>;

                    return ListTile(
                      title: Text(notification['content'] ?? 'No Content'),
                      subtitle: Text(notification['timestamp']?.toDate().toString() ?? 'No Timestamp'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}