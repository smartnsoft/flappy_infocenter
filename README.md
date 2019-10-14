# Flappy InfoCenter

A Flutter plugin to handle iOS Playing Info Center events such as _play_, _pause_, _title_, etc.

## Installation

```
flappy_infocenter: 1.0.1
```

## Getting Started

The plugin allows to display easily the playing info center on iOS. This is the built-in 
notification used to display audio or video information in the notification center.

It will work _if and only if_ a player is currently launched. The tests have been made using the
[`audioplayers`](https://github.com/luanpotter/audioplayers) plugin.

First, import the package in your code 
```
import 'package:flappy_infocenter/flappy_infocenter.dart';
```

You can then access the _FlappyInfoCenter singleton_ freely in your code.

## API

All the methods will overwrite what is currently displayed in the info center.

### Info

```
static setInfo(String author, String title) async
```

Displays in the info center an author and a title for the given audio or video played.

### Progress

```
static setProgress(int progress) async
```

Displays in the info center the progress in seconds for the given audio or video played. Will work
if and only if a total duration has been set.

### Duration

```
static setDuration(int duration) async
```

Displays in the info center the total duration in seconds of the given audio or video played.

### Image

```
static setImage(String url) async
```

Displays in the info center an image for the given audio or video played. The image must be a valid
URL.

### Player listener

```
static setPlayerListener(PlayerListener listener)
```

Allows to get info center control events. Currently, only PLAY and PAUSE works.

Example :

```
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
```
