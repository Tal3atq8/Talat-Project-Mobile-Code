import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:talat/src/theme/color_constants.dart';

import '../../main.dart';
import '../app_routes/app_routes.dart';
import '../screens/my_booking/my_booking_detail/my_booking_detail_binding.dart';
import '../screens/my_booking/my_booking_detail/my_booking_detail_controller.dart';
import '../utils/global_constants.dart';

void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  print(
      '========================= NotificationResponse.payload ${notificationResponse.payload} ======================== ');
  if (bookingID.value != null && bookingID.value != '' && bookingID.value != 'null') {
    BookingDetailBinding().dependencies();
    Get.find<BookingDetailController>().bookingDetail();
    Get.toNamed(AppRouteNameConstant.confirmBookingScreen, arguments: bookingID.value);
  }
}

class PushNotificationService {
  bool isFlutterLocalNotificationsInitialized = false;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late AndroidNotificationChannel channel;

  Future<void> setupInteractedMessage() async {
    await Firebase.initializeApp();
    // permissionSetting();
    enableIOSNotifications();
    messageHandler();
  }

  Future<void> enableIOSNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  Future<void> permissionSetting() async {
    // FirebaseMessaging messaging = FirebaseMessaging.instance;
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> messageHandler() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@drawable/ic_notification');
    DarwinInitializationSettings iOSSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) {
        debugPrint("[onDidReceiveLocalNotification]======>  $id, $title, $body");
      },
    );
    var settings = InitializationSettings(android: androidSettings, iOS: iOSSettings);
    flutterLocalNotificationsPlugin.initialize(settings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      backgroundMessage = message;
      print("================= Notification message ${message?.data} =================");

      final RemoteNotification? notification = message!.notification;
      final AndroidNotification? android = message.notification?.android;

      bookingID.value = message.data['booking_id'].toString();

// If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              color: ColorConstant.appThemeColor,
              icon: '@drawable/ic_notification',
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      // Get.toNamed(NOTIFICATIONS_ROUTE);
      print("================= Notification onMessageOpenedApp  ${message.data} =================");
      if (message.data['booking_id'] != null &&
          message.data['booking_id'] != 'null' &&
          message.data['booking_id'] != '') {
        BookingDetailBinding().dependencies();
        bookingID.value = message.data['booking_id'].toString();
        Get.find<BookingDetailController>().bookingDetail();

        Get.toNamed(AppRouteNameConstant.confirmBookingScreen, arguments: message.data['booking_id'].toString());
      }
    });
  }
}

void handleMessageOnBackground() {
  debugPrint("handleMessageOnBackground");
  FirebaseMessaging.instance.getInitialMessage().then(
    (message) {
      debugPrint("message::::: $message");
      if (message != null) {
        if (message.data['booking_id'] != null &&
            message.data['booking_id'] != '' &&
            message.data['booking_id'] != 'null') {
          BookingDetailBinding().dependencies();
          bookingID.value = message.data['booking_id'].toString();
          Get.find<BookingDetailController>().bookingDetail();

          Get.toNamed(AppRouteNameConstant.confirmBookingScreen, arguments: message.data['booking_id'].toString());
        }
      }
    },
  );
}
