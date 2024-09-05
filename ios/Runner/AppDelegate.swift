import Flutter
import UIKit
import GoogleMaps
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyB7yJR6X1DOKCmmHwH4wI0TXXhMAVxyV0g")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
