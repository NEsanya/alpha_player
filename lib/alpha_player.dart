import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

enum _AlphaPlayerControllerType {
  assets,
  network
}

/// This class implement controller for [AlphaPlayerView].
class AlphaPlayerController {
  static const MethodChannel _channel = MethodChannel('alpha_player');

  final String _path;
  final _AlphaPlayerControllerType _alphaPlayerControllerType;

  bool _playing = false;

  /// Returns [bool] of controller playing state.
  bool get isPlaying => _playing;

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Fabric for [AlphaPlayerController] where media gets from project [assets].
  ///
  /// Throws an [IOException] when [assets] is not exists.
  AlphaPlayerController.assets(String assets) :
    _path = assets,
    _alphaPlayerControllerType = _AlphaPlayerControllerType.assets;

  /// Fabric for [AlphaPlayerController] where media get from network by [url].
  ///
  /// Throws an [IOException] when [url] request is not 2xx.
  AlphaPlayerController.network(String url) :
    _path = url,
    _alphaPlayerControllerType = _AlphaPlayerControllerType.network;

  /// Set [AlphaPlayerController] to play state.
  void play() => _playing = true;

  /// Initialize controller data to visualization on view.
  /// You may call [play] when [initialize] ends for start video.
  /// Use [State.setState] in [State] if you end your controller settings or you start playing video.
  ///
  /// Throws an [IOException] when media source is not defined.
  Future<void> initialize() async {
    throw UnimplementedError(); // TODO: Create implementation
  }
}

class AlphaPlayerView extends StatelessWidget {
  @protected final AlphaPlayerController controller;

  /// This class implement native platform video player from [controller].
  ///
  /// In android returns [AndroidView] to create virtual display.
  /// In ios returns [UiKitView] to create hybrid composition.
  ///
  /// Throws an [PlatformException] on build stage, when platform is not avaible.
  const AlphaPlayerView({ Key? key, required this.controller }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String viewType = 'alpha-player-view';

    if(Platform.isAndroid) {
      return const AndroidView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParamsCodec: StandardMessageCodec(),
      );
    } else if(Platform.isIOS) {
      return const UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParamsCodec: StandardMessageCodec(),
      );
    } else {
      throw PlatformException(code: "Your platform is not supports.", message: "Platform ${Platform.operatingSystem} is not supports in alpha_player.");
    }
  }
}