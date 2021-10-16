import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
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

  Uint8List? _media;
  Map<String, String>? _networkHeaders;
  bool _playing = false;

  /// Returns [bool] of controller playing state.
  bool get isPlaying => _playing;

  /// Returns [Uint8List] of [initialize] media.
  /// Returns null if controller is not initialized.
  Uint8List? get media => _media;

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
  /// Use HTTP GET request with [headers].
  ///
  /// Throws an [IOException] when [url] request is not 2xx.
  AlphaPlayerController.network(String url, Map<String, String>? headers) :
    _path = url,
    _alphaPlayerControllerType = _AlphaPlayerControllerType.network,
    _networkHeaders = headers;

  /// Set [AlphaPlayerController] to play state.
  void play() => _playing = true;

  /// Initialize controller data to visualization on view.
  ///
  /// You may call [play] when [initialize] ends for start video.
  /// Use [State.setState] in [State] if you end your controller settings or you start playing video.
  ///
  /// This method of receiving media waits for complete data acquisition before playing.
  ///
  /// Throws an [IOException] when media source is not defined.
  Future<void> initialize() async {
    switch(_alphaPlayerControllerType) {
      case _AlphaPlayerControllerType.assets:
        _media = (await rootBundle.load(_path)).buffer.asUint8List();
        break;
      case _AlphaPlayerControllerType.network:
        _media = (await http.get(Uri.parse(_path), headers: _networkHeaders)).bodyBytes;
        break;
    }
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
    final Map<String, dynamic> creationParams = <String, dynamic>{
      "media": controller.media,
    };

    if(Platform.isAndroid) {
      return AndroidView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if(Platform.isIOS) {
      return UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      throw PlatformException(code: "Your platform is not supports.", message: "Platform ${Platform.operatingSystem} is not supports in alpha_player.");
    }
  }
}