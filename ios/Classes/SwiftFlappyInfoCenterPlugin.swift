import Flutter
import UIKit
import MediaPlayer
import os.log

public class SwiftFlappyInfoCenterPlugin: NSObject, FlutterPlugin {

  var channel: FlutterMethodChannel?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SwiftFlappyInfoCenterPlugin()
    instance.channel = FlutterMethodChannel(name: "flappyInfoCenter", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(instance, channel: instance.channel!)
    instance.initialize()
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let methodName = call.method
    switch methodName {
    case "setInfo":
      if let arguments = call.arguments as? [String], arguments.count == 2 {
        setInfo(author: arguments[0], title: arguments[1])
      }
    case "setProgress":
      if let progress = call.arguments as? Int {
        setProgress(progress: progress)
      }
    case "setDuration":
      if let duration = call.arguments as? Int {
        setDuration(duration: duration)
      }
    case "setImage":
      if let imageUrl = call.arguments as? String {
        setImage(url: imageUrl)
      }
    default:
      result("default")
    }
  }
  
  fileprivate func initialize() {
    //Command Center
    // Get the shared MPRemoteCommandCenter
    let commandCenter = MPRemoteCommandCenter.shared()
    
    // Add handler for Play Command
    commandCenter.playCommand.addTarget { [unowned self] event in
      self.channel?.invokeMethod("play", arguments: nil)
      return .success
    }
    commandCenter.playCommand.isEnabled = true
    
    // Add handler for Pause Command
    commandCenter.pauseCommand.addTarget { [unowned self] event in
      self.channel?.invokeMethod("pause", arguments: nil)
      return .success
    }
    commandCenter.pauseCommand.isEnabled = true
    
  }
}

fileprivate func updatePlayingInfoCenter(infos: [String: Any]) {
  var nowPlayingInfo: [String: Any] = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [String:Any]()
  infos.forEach({ (key: String, value: Any) in
    nowPlayingInfo[key] = value
  })
  MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
}

func setInfo(author: String, title: String) {
  updatePlayingInfoCenter(infos: [MPMediaItemPropertyTitle: title, MPMediaItemPropertyArtist: author])
}

func setProgress(progress: Int) {
  updatePlayingInfoCenter(infos: [MPNowPlayingInfoPropertyElapsedPlaybackTime: progress])
}

func setDuration(duration: Int) {
  updatePlayingInfoCenter(infos: [MPMediaItemPropertyPlaybackDuration: duration])
}

func setImage(url: String) {
  downloadImage(url: URL.init(string: url)!) { (image: UIImage?) in
    guard let image = image else { return }
    updatePlayingInfoCenter(infos: [MPMediaItemPropertyArtwork: MPMediaItemArtwork(image: image)])
  }
}

fileprivate func downloadImage(url: URL, completion: @escaping ((_ image: UIImage?) -> Void)){
  getDataFromUrl(url: url) { data in
    DispatchQueue.main.async {
      completion(UIImage(data: data! as Data))
    }
  }
}

fileprivate func getDataFromUrl(url: URL, completion: @escaping ((_ data: NSData?) -> Void)) {
  URLSession.shared.dataTask(with: url) { (data, response, error) in
    completion(data as NSData?)
  }.resume()
}
