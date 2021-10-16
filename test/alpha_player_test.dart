import 'package:flutter_test/flutter_test.dart';
import 'package:alpha_player/alpha_player.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();


  test('getPlatformVersion', () async {
    expect(await AlphaPlayerController.platformVersion, '42');
  });

  test('isPlaying', () async {
    final alphaPlayerController = AlphaPlayerController.network('https://www.youtube.com/watch?v=dQw4w9WgXcQ&ab_channel=RickAstley');

    expect(alphaPlayerController.isPlaying, false);
    alphaPlayerController.play();
    expect(alphaPlayerController.isPlaying, true);
  });
}
