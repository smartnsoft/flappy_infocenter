import 'dart:async';

import 'package:flutter/services.dart';

class FlappyInfoCenter {
  static const MethodChannel _channel =
  const MethodChannel('flappyInfoCenter');

  /*
  Displays in the info center an author and a title for the given audio or video played.
  */
  static setInfo(String author, String title) async {
    await _channel.invokeMethod('setInfo', [author, title]);
  }

  /*
  Displays in the info center the progress in seconds for the given audio or video played. Will work
  if and only if a total duration has been set.
  */
  static setProgress(int progress) async {
    await _channel.invokeMethod('setProgress', progress);
  }

  /*
  Displays in the info center the total duration in seconds of the given audio or video played.
  */
  static setDuration(int duration) async {
    await _channel.invokeMethod('setDuration', duration);
  }

  /*
  Displays in the info center an image for the given audio or video played. The image must be a valid
  URL.
  */
  static setImage(String url) async {
    await _channel.invokeMethod('setImage', url);
  }


  /*
  Allows to get info center control events. Currently, only PLAY and PAUSE works.

  Example :

  FlappyInfoCenter.setPlayerListener((PlayerState state) {
    switch (state) {
      case PlayerState.PLAY:
        play();
        break;
      case PlayerState.PAUSE:
        pause();
        break;
      case PlayerState.NEXT:
        break;
      case PlayerState.PREVIOUS:
        break;
    }
  });
  */
  static setPlayerListener(PlayerListener listener) {
    _channel.setMethodCallHandler((call) async {
      var didSucceed = true;
      switch (call.method) {
        case 'play':
          listener(PlayerState.PLAY);
          break;
        case 'pause':
          listener(PlayerState.PAUSE);
          break;
        default:
          didSucceed = false;
          break;
      }
      return didSucceed;
    });
  }
}

typedef void PlayerListener(PlayerState state);

enum PlayerState {
  PLAY,
  PAUSE,
  NEXT,
  PREVIOUS
}
