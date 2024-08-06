import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/constant_strings.dart';
import 'package:talat/src/utils/utility.dart';

import '../../app_routes/app_routes.dart';
import '../../models/slider_model.dart';
import '../../network/netwrok_manager_controller.dart';
import '../../theme/image_constants.dart';
import '../../utils/preference/preference_keys.dart';
import '../../utils/preference/preferences.dart';

class UserGuide extends StatefulWidget {
  const UserGuide({Key? key}) : super(key: key);

  @override
  State<UserGuide> createState() => _UserGuideState();
}

class _UserGuideState extends State<UserGuide> {
  List<SliderModel> mySLides = <SliderModel>[];
  int slideIndex = 0;
  int slideTextIndex = 0;
  PageController? controller;
  PageController? textController;
  final networkController = Get.put(GetXNetworkManager());

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      height: 5,
      width: 40,
      decoration: BoxDecoration(
        color: isCurrentPage ? ColorConstant.appThemeColor : ColorConstant.lightGrayColor,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mySLides = getSlides();
    controller = PageController();
    textController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      body: SizedBox(
        // height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: Get.height * 0.6,
              child: PageView(
                controller: controller,
                onPageChanged: (index) {
                  setState(() {
                    slideIndex = index;
                    textController!.jumpToPage(index);
                  });
                },
                children: <Widget>[
                  SlideTile(
                    imagePath: mySLides[0].getImageAssetPath(),
                  ),
                  SlideTile(
                    imagePath: mySLides[1].getImageAssetPath(),
                  ),
                  SlideTile(
                    imagePath: mySLides[2].getImageAssetPath(),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 42),
              child: SizedBox(
                // height: Get.height * 0.02,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 3; i++)
                      i == slideIndex ? _buildPageIndicator(true) : _buildPageIndicator(false),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 100,
              child: PageView(
                controller: textController,
                onPageChanged: (index) {
                  setState(() {
                    slideIndex = index;
                    controller!.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.linear);
                  });
                },
                children: <Widget>[
                  SlideTextTile(
                    title: mySLides[0].getTitle(),
                    desc: mySLides[0].getDesc(),
                  ),
                  SlideTextTile(
                    title: mySLides[1].getTitle(),
                    desc: mySLides[1].getDesc(),
                  ),
                  SlideTextTile(
                    title: mySLides[2].getTitle(),
                    desc: mySLides[2].getDesc(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: slideIndex != 2
          ? Container(
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(width: 90),
                  TextButton(
                    onPressed: () async {
                      await SharedPref.setString(PreferenceConstants.userGuideCompleted, "1");
                      Get.offAllNamed(AppRouteNameConstant.tabScreen);
                    },
                    child: Text(ConstantStrings.skipButton,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: ColorConstant.darkGrayColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller?.animateToPage(slideIndex + 1,
                          duration: const Duration(milliseconds: 500), curve: Curves.linear);
                      textController?.animateToPage(slideIndex + 1,
                          duration: const Duration(milliseconds: 500), curve: Curves.linear);
                    },
                    child: Directionality(
                      textDirection: Get.locale == const Locale('ar', '') ? TextDirection.rtl : TextDirection.ltr,
                      child: Stack(
                        children: [
                          Image.asset(
                            ImageConstant.userGuideSliderContainer,
                            // height: 90.h,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 50.0,
                              left: 26.0,
                            ),
                            child: Text(
                              ConstantStrings.nextButton,
                              style:
                                  TextStyle(color: ColorConstant.whiteColor, fontSize: 18, fontWeight: FontWeight.w200),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          : Container(
              color: ColorConstant.whiteColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 44,
                    // padding: const EdgeInsets.symmetric(horizontal: 100),
                    width: Get.width * 0.5,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: ColorConstant.appThemeColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
                      onPressed: () async {
                        // Get.back();
                        await SharedPref.setString(PreferenceConstants.userGuideCompleted, "1");
                        Get.offNamed(AppRouteNameConstant.tabScreen);
                      },
                      child: Text(
                        toLabelValue(ConstantStrings.getStarted),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w200),
                      ),
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
    );
  }
}

class SlideTile extends StatelessWidget {
  String? imagePath;

  SlideTile({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Image.asset(
          imagePath!,
          fit: BoxFit.cover,
          height: Get.height * 0.6,
          width: Get.width,
        ),
      ],
    );
  }
}

class SlideTextTile extends StatelessWidget {
  String? title;
  String? desc;

  SlideTextTile({super.key, this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          title!,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Text(desc!,
              textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        )
      ],
    );
  }
}
