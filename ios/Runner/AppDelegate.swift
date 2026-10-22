import AVFoundation
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  /// Rest-alarm sound preview (channel `saiyagym/alarm_sound`). The sound
  /// file itself is copied to Library/Sounds from Dart; only the preview
  /// needs native code.
  private var previewPlayer: AVAudioPlayer?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let channel = FlutterMethodChannel(
      name: "saiyagym/alarm_sound",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    channel.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      case "preview":
        if let args = call.arguments as? [String: Any], let path = args["path"] as? String {
          self?.preview(path: path)
        }
        result(nil)
      case "stopPreview":
        self?.previewPlayer?.stop()
        self?.previewPlayer = nil
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private func preview(path: String) {
    previewPlayer?.stop()
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)
      let player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
      previewPlayer = player
      player.play()
    } catch {
      previewPlayer = nil
    }
  }
}
