import 'dart:io';

import 'package:flutter/material.dart';
import 'package:talat/src/theme/color_constants.dart';
import 'package:talat/src/theme/image_constants.dart';
import 'package:talat/src/utils/enums/enum.dart';

class NotificationView extends StatelessWidget {
  final String title;
  final String subTitle;
  final NotificationOViewCallback? onTap;

  NotificationView({this.title = "", this.subTitle = "", this.onTap});

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return Material(
        color: Colors.white,
        child: SafeArea(
          bottom: false,
          child: GestureDetector(
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                      top: 15,
                      left: 16,
                      right: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: Image.asset(
                                ImageConstant.appLogoImage,
                                width: 20,
                                height: 20,
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              "Talat",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: ColorConstant.blackColor,
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 6,
                          ),
                        ),
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: ColorConstant.blackColor,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 6,
                          ),
                        ),
                        Text(
                          subTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: ColorConstant.blackColor,
                          ),
                          maxLines: 3,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              if (onTap != null) {
                onTap!(true);
              }
            },
          ),
        ),
      );
    } else {
      return Material(
        color: Colors.white,
        child: GestureDetector(
          child: SafeArea(
            bottom: false,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
                boxShadow: kElevationToShadow[2],
              ),
              margin: const EdgeInsets.all(10.0),
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                  boxShadow: kElevationToShadow[2],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        ClipRRect(
                          child: Image.asset(
                            ImageConstant.appLogoImage,
                            width: 20,
                            height: 20,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          "Talat",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: ColorConstant.blackColor,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 6,
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: ColorConstant.blackColor,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 6)),
                    Text(
                      subTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: ColorConstant.blackColor,
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
          onTap: () {
            if (onTap != null) {
              onTap!(true);
            }
          },
        ),
      );
    }
  }
}
