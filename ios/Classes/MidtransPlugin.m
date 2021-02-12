#import "MidtransPlugin.h"
#if __has_include(<midtrans/midtrans-Swift.h>)
#import <midtrans/midtrans-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "midtrans-Swift.h"
#endif

@implementation MidtransPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMidtransPlugin registerWithRegistrar:registrar];
}
@end
