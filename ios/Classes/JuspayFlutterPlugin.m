#import "JuspayFlutterPlugin.h"
#if __has_include(<juspay_flutter/juspay_flutter-Swift.h>)
#import <juspay_flutter/juspay_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "juspay_flutter-Swift.h"
#endif

@implementation JuspayFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftJuspayFlutterPlugin registerWithRegistrar:registrar];
}
@end
