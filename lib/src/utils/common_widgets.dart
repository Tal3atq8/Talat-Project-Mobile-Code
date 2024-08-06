import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:talat/src/theme/color_constants.dart';

import '../theme/image_constants.dart';

class CustomAppbarNoSearchBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool? hideBackIcon;
  final List<Widget>? actionItems;
  final Function()? onBackPressed;
  final bool? disableAutoBack;

  const CustomAppbarNoSearchBar(
      {super.key,
      required this.title,
      this.hideBackIcon,
      this.actionItems,
      this.onBackPressed,
      this.disableAutoBack});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(58),
      child: AppBar(
        toolbarHeight: 80,
        elevation: 1,
        leadingWidth: 60,
        automaticallyImplyLeading: true,
        centerTitle: true,
        actions: actionItems,
        leading:
            (hideBackIcon == null || (hideBackIcon != null && !hideBackIcon!))
                ? InkWell(
                    onTap: () {
                      if (disableAutoBack == null ||
                          (disableAutoBack != null && !disableAutoBack!)) {
                        Get.back();
                      }
                      if (onBackPressed != null) {
                        onBackPressed!();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: ColorConstant.appThemeColor,
                        size: 20,
                        weight: 50,
                      ),
                    ))
                : const SizedBox(),
        title: Text(
          title.toString() ?? '',
          style: const TextStyle(
            color: Colors.black,
            // fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// class PlaceholderImages extends StatelessWidget {
//   const PlaceholderImages({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey.shade300,
//       highlightColor: Colors.grey.shade100,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: Colors.grey,
//         ),
//         height: Get.height * .2,
//         // width: Get.width * 0.5,
//       ),
//     );
//   }
// }

class PlaceholderImage extends StatelessWidget {
  const PlaceholderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ImageConstant.imagePlaceholder,
      fit: BoxFit.cover,
    );
  }
}

CustomFooter customFooterSmartRefresh() {
  return CustomFooter(
    builder: (BuildContext context, LoadStatus? mode) {
      Widget body;
      if (mode == LoadStatus.loading) {
        body = const SizedBox();
      } else if (mode == LoadStatus.noMore) {
        body = const Text("", textScaleFactor: 1.0);
      } else {
        body = const Text("", textScaleFactor: 1.0);
      }
      return SizedBox(
        height: 55.0,
        child: Center(child: body),
      );
    },
  );
}
