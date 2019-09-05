import 'package:flutter/material.dart';
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flappy_infocenter/flappy_infocenter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setUrl("https://s3.amazonaws.com/kargopolov/kukushka.mp3");;
    FlappyInfoCenter.setInfo("Author", "Title");
    FlappyInfoCenter.setImage('https://images-na.ssl-images-amazon.com/images/I/51iw4f1SSbL._SY550_.jpg');
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flappy Info Center Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () async {
                  play();
                },
                child: Text("Play"),
              ),
              RaisedButton(
                onPressed: () async {
                  pause();
                },
                child: Text("Pause"),
              )
            ],
          ),
        ),
      ),
    );
  }

  play() async {
    _audioPlayer.resume();
    await _updateProgress();
  }

  pause() async {
    _audioPlayer.pause();
    await _updateProgress();
  }

  Future _updateProgress() async {
    var duration = await _audioPlayer.getDuration();
    FlappyInfoCenter.setDuration(duration ~/ 1000);
    var position = await _audioPlayer.getCurrentPosition();
    FlappyInfoCenter.setProgress(position ~/ 1000);
  }
}
