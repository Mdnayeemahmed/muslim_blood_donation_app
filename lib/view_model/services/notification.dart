import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const InitializationSettings initializationSettingsAndroid =
        InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/launcher_icon'));
    await _notificationsPlugin.initialize(
      initializationSettingsAndroid,
      onDidReceiveNotificationResponse: (details) {
        if (details.input != null) {}
      },
    );
  }

  static Future<void> display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      if (message.notification != null) {
        NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            message.notification!.android!.sound ?? "Channel Id",
            message.notification!.android!.sound ?? "Main Channel",
            groupKey: "gfg",
            color: Colors.green,
            importance: Importance.max,
            playSound: true,
            priority: Priority.high,
          ),
        );

        await _notificationsPlugin.show(
          id,
          message.notification?.title,
          message.notification?.body,
          notificationDetails,
          payload: message.data['route'],
        );
      } else {
        await _notificationsPlugin.show(
          id,
          'Default Title',
          'Default Body',
          null,
          payload: message.data['route'],
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> sendPushMessage(
      String token, String body, String title) async {
    final Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    const String serverKey =
        'AAAAyN6MCzs:APA91bEHSyFto1KaT0sYa61zlsmc1GqHupFujzQtjulzOrjoJ9pNaMN-ju51EcBXhIDBml5FWtnL36Wv9c-PCimuTRESiItxyJDa_jxWr6NsndyrLm-gIT7pIHiAVrlxe-pw80T6VWpR';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final Map<String, dynamic> data = {
      'priority': 'high',
      'data': {
        'click_action': 'done',
        'status': 'done',
        'body': body,
        'title': title,
      },
      'notification': {
        'title': title,
        'body': body,
      },
      'to': token,
    };

    try {
      final http.Response response =
          await http.post(url, headers: headers, body: jsonEncode(data));

      if (response.statusCode == 200) {
        //showNotification(title, body);
        print('Notification sent successfully!');
      } else {
        // Handle unsuccessful response, if needed
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending push message: $e');
      }
    }
  }

  static Future<void> showNotification(String title, String body) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  static Future<void> sendPushMessagesToAllUsers(
      String title, String body) async {
    final userSnapshot = await FirebaseFirestore.instance
        .collection('user_data_collection')
        .where('admin_type', isEqualTo: true)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      for (var doc in userSnapshot.docs) {
        final token = doc.data()['user_device_tokens'] as String?;
        if (kDebugMode) {
          print(token);
        }
        if (token != null) {
          sendPushMessage(token, body, title);
          print('sendPushMessage');
        }
      }
    } else {
      if (kDebugMode) {
        print('No user data found in the user_data_collection');
      }
    }
  }
}
