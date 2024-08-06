import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talat/src/screens/user_guide/user_guide_binging.dart';
import 'package:video_player/video_player.dart';

import '../../main.dart';
import '../app_routes/app_routes.dart';
import '../network/netwrok_manager_controller.dart';
import '../utils/global_constants.dart';
import '../utils/preference/preference_keys.dart';
import '../utils/preference/preferences.dart';
import 'my_booking/my_booking_detail/my_booking_detail_binding.dart';
import 'my_booking/my_booking_detail/my_booking_detail_controller.dart';

final GetXNetworkManager networkManager = Get.find<GetXNetworkManager>();

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashScreen> {
  String? token;
  String? userGuideCompleted;
  VideoPlayerController? _controller;
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    _controller = VideoPlayerController.asset("assets/videos/talat_splash_clip.mp4");
    _controller?.initialize().then((_) {
      _controller?.setLooping(true);
      Timer(const Duration(milliseconds: 100), () {
        setState(() {
          _controller?.play();
          _visible = true;
        });
      });
    });
    checkForUserLogin();
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller?.dispose();
      _controller = null;
    }
  }

  _getVideoBackground() {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),
      child: VideoPlayer(_controller!),
    );
  }

  _getBackgroundColor() {
    return Container(color: Colors.transparent //.withAlpha(120),
        );
  }

  _getContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            _getVideoBackground(),
          ],
        ),
      ),
    );
  }

  void checkForUserLogin() async {
    token = await SharedPref.getString(PreferenceConstants.token);
    userGuideCompleted = await SharedPref.getString(PreferenceConstants.userGuideCompleted);

    if ((userGuideCompleted != null && userGuideCompleted == "1") || (token != null && token != "")) {
      if (backgroundMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (backgroundMessage != null) {
            Future.delayed(const Duration(milliseconds: 1000), () async {
              labelAPi().then((value) {
                if (backgroundMessage?.data['booking_id'] != null &&
                    backgroundMessage?.data['booking_id'] != 'null' &&
                    backgroundMessage?.data['booking_id'] != '') {
                  BookingDetailBinding().dependencies();
                  bookingID.value = backgroundMessage?.data['booking_id'].toString() ?? '';
                  Get.find<BookingDetailController>().bookingDetail();
                  Get.offAllNamed(AppRouteNameConstant.confirmBookingScreen, arguments: bookingID.value);
                } else {
                  Timer(const Duration(seconds: 3), () {
                    Get.offAllNamed(AppRouteNameConstant.tabScreen);
                  });
                }
              });
            });
          }
        });
      } else {
        Timer(const Duration(seconds: 3), () {
          Get.offAllNamed(AppRouteNameConstant.tabScreen);
        });
      }
    } else {
      Timer(const Duration(seconds: 3), () {
        UserGuideBinding().dependencies();
        Get.offAllNamed(
          AppRouteNameConstant.userGuideScreen,
        );
      });
    }
  }
}
