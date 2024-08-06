import 'package:flutter/material.dart';
import 'package:talat/src/screens/%20favorite/favorite_list_screen.dart';
import 'package:talat/src/screens/dashboard/dashboard_screen.dart';
import 'package:talat/src/screens/notification/notification_list/notification_screen.dart';
import 'package:talat/src/screens/profile/profile_screen.dart';

class TabNavigatorRoutes {
  static const String root = '/';
}

class TabNavigator extends StatelessWidget {
  var listScreen = [
    DashBoard(),
    FavoriteList(),
    NotificationScreen(),
    ProfileScreen(),
  ];

  final GlobalKey<NavigatorState> navigatorKey;
  final int index;
  TabNavigator({super.key, required this.navigatorKey, required this.index});

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      TabNavigatorRoutes.root: (context) => listScreen[index],
    };
  }

  @override
  Widget build(BuildContext context) {
    var routeBuilders = _routeBuilders(context);

    return Navigator(
        key: navigatorKey,
        initialRoute: TabNavigatorRoutes.root,
        onGenerateRoute: (routeSettings) {
          var name = routeSettings.name;
          debugPrint(" Route $name");
          return MaterialPageRoute(
              builder: (context) =>
                  routeBuilders[routeSettings.name!]!(context));
        });
  }
}
