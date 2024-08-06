import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:talat/src/app_routes/app_routes.dart';
import 'package:talat/src/app_routes/routes.dart';
import 'package:talat/src/models/label_model.dart';
import 'package:talat/src/services/push_notification_service.dart';
import 'package:talat/src/services/talat_services.dart';
import 'package:talat/src/utils/global_constants.dart';
import 'package:talat/src/widgets/changeLanguage/localization.dart';

import 'src/utils/preference/preference_keys.dart';
import 'src/utils/preference/preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final label = LabelModel().obs;
String? token;
String? userGuideCompleted;

RemoteMessage? backgroundMessage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await determinePosition();
  await notificationPermission();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  language = await SharedPref.getString(PreferenceConstants.laguagecode);
  if (language!.isEmpty) {
    language = '1';
  }

  userLatLong();
  await Firebase.initializeApp();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  backgroundMessage = await messaging.getInitialMessage();

  await PushNotificationService().setupInteractedMessage();
  Future.delayed(
    const Duration(seconds: 2),
    () async {
      String? fcmToken = await messaging.getToken();
      debugPrint(await SharedPref.getString(PreferenceConstants.laguagecode));

      if (fcmToken != null) {

        debugPrint('FCM Token: $fcmToken');
        firebaseToken.value = fcmToken;
        await SharedPref.setString(PreferenceConstants.FCM_TOKEN, fcmToken);
      }
    },
  );

  token = await SharedPref.getString(PreferenceConstants.token);
  userGuideCompleted = await SharedPref.getString(PreferenceConstants.userGuideCompleted);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarBrightness: Brightness.light));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  const fatalError = true;
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };

  runApp(GetMaterialApp(
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: child ?? const SizedBox(),
      );
    },
    debugShowCheckedModeBanner: false,
    translations: WorldLanguage(),
    locale: language == "1" ? const Locale('en', 'US') : const Locale('ar', 'AR'),
    fallbackLocale: language == "1" ? const Locale('en', 'US') : const Locale('ar', 'AR'),
    title: 'Talat',
    theme: ThemeData(
      fontFamily: GoogleFonts.lato().fontFamily,
      buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.normal),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              textStyle: MaterialStatePropertyAll(TextStyle(
        fontFamily: GoogleFonts.lato().fontFamily,
      )))),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: false,
      ),
    ),
    initialRoute: AppRouteNameConstant.splashScreen,

    getPages: appRoutes(),
  ));
}

Future<Position?> determinePosition() async {
  LocationPermission permission;
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
  } else if (permission == LocationPermission.deniedForever) {
    permission = await Geolocator.requestPermission();
  } else {
    return await Geolocator.getCurrentPosition();
  }
}

Future<void> notificationPermission() async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    Map<Permission, PermissionStatus> statusess;

    if (androidInfo.version.sdkInt >= 31) {
      statusess = await [Permission.notification].request();
      debugPrint('$statusess');
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: GetMaterialApp(
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child ?? const SizedBox(),
            );
          },
          debugShowCheckedModeBanner: false,
          translations: WorldLanguage(),
          locale: language == "1" ? const Locale('en', 'US') : const Locale('ar', 'AR'),
          fallbackLocale: language == "1" ? const Locale('en', 'US') : const Locale('ar', 'AR'),
          title: 'Talat',
          theme: ThemeData(
            fontFamily: GoogleFonts.lato().fontFamily,
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.normal),
            textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                    textStyle: MaterialStatePropertyAll(TextStyle(
              fontFamily: GoogleFonts.lato().fontFamily,
            )))),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              centerTitle: false,
            ),
          ),
          initialRoute: AppRouteNameConstant.splashScreen,
          getPages: appRoutes(),
        ),
      ),
    );
  }
}

Future<void> labelAPi() async {
  if (SharedPref.getString(PreferenceConstants.laguagecode) != "") {
    language = await SharedPref.getString(PreferenceConstants.laguagecode);
    debugPrint(language);
    if (language == "") {
      language = "1";
    }
  } else {
    language = "1";
  }
  TalatService().getLabels().then((response) async {
    if (response.data['code'] == "1") {
      label.value = LabelModel.fromJson(response.data);

      labelResult.value = label.value.result!;

      WorldLanguage().addLabelKeyToModel();
    } else {
      debugPrint(response.data);
    }
  });
}

userLatLong() async {
  final position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  userLat.value = position.latitude.toString();
  userLong.value = position.longitude.toString();
}
