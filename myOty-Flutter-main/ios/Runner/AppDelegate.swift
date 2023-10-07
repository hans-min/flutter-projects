import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // TODO: Add your Google Maps API key
    //GMSServices.provideAPIKey("AIzaSyDer0DTGERzn3MBVvECvRvJNZT6Hx5b654")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
