import UIKit
import Flutter
import GoogleMaps
import FirebaseCore

import Firebase

import FirebaseMessaging
struct Constant {
    static let channelName = "com.app.talat"
    static let gogoleMapKey = "AIzaSyDFEDH0OFN1aYV2n2QQ1zIbC8J6t9mngPI"
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseConfiguration().setLoggerLevel(FirebaseLoggerLevel.min)
      FirebaseApp.configure()
GMSServices.provideAPIKey("AIzaSyDFEDH0OFN1aYV2n2QQ1zIbC8J6t9mngPI")
     
      
    GeneratedPluginRegistrant.register(with: self)
      if #available(iOS 10.0, *) {

                       // For iOS 10 display notification (sent via APNS)

                       UNUserNotificationCenter.current().delegate = self

                       let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]

                       UNUserNotificationCenter.current().requestAuthorization(

                               options: authOptions,

                               completionHandler: {_, _ in })

                   }

                   application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
