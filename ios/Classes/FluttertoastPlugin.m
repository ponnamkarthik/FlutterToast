#import "FluttertoastPlugin.h"
#import <fluttertoast/fluttertoast-Swift.h>

@implementation FluttertoastPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFluttertoastPlugin registerWithRegistrar:registrar];
}
@end
