import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

enum _AlphaPlayerControllerType {
  assets
}

class AlphaPlayerController {
  static const MethodChannel _channel = MethodChannel('alpha_player');

  final String _path;
  final _AlphaPlayerControllerType _alphaPlayerControllerType;

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Fabric for AlphaPlayerController where media gets from project [assets].
  ///
  /// Throws an [IOException] when [assets] is not exists.
  AlphaPlayerController.assets(String assets) :
    _path = assets,
    _alphaPlayerControllerType = _AlphaPlayerControllerType.assets;
}

class AlphaPlayerView extends StatelessWidget {
  @protected final AlphaPlayerController controller;

  const AlphaPlayerView({ Key? key, required this.controller }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String viewType = 'alpha-player-view';

    if(Platform.isAndroid) {
      return PlatformViewLink(
        viewType: viewType,
        surfaceFactory: (BuildContext context, PlatformViewController platformViewController) {
          return AndroidViewSurface(
            controller: platformViewController as AndroidViewController,
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          );
        },
        onCreatePlatformView: (PlatformViewCreationParams params) {
          return PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            onFocus: () => params.onFocusChanged(true),
          )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..create();
        },
      );
    } else if(Platform.isIOS) {
      return const UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
      );
    } else {
      throw PlatformException(code: "Your platform is not supports.");
    }
  }
}