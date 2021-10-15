import 'package:flutter_test/flutter_test.dart';
import 'package:alpha_player/alpha_player.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();


  test('getPlatformVersion', () async {
    expect(await AlphaPlayerController.platformVersion, '42');
  });
}
