#import "AlphaPlayerPlugin.h"
#if __has_include(<alpha_player/alpha_player-Swift.h>)
#import <alpha_player/alpha_player-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "alpha_player-Swift.h"
#endif

@implementation AlphaPlayerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAlphaPlayerPlugin registerWithRegistrar:registrar];
}
@end
