#import "FluttertoastPlugin.h"
#import "UIView+Toast.h"
// #import <fluttertoast/fluttertoast-Swift.h>

static NSString *const CHANNEL_NAME = @"PonnamKarthik/fluttertoast";

@implementation FluttertoastPlugin {
    FlutterResult _result;
}


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:CHANNEL_NAME
                                     binaryMessenger:[registrar messenger]];
    UIViewController *viewController =
    [UIApplication sharedApplication].delegate.window.rootViewController;
    FluttertoastPlugin* instance = [[FluttertoastPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    
}

- (unsigned int)intFromHexString:(NSString *)hexStr {
  unsigned int hexInt = 0;
  NSScanner *scanner = [NSScanner scannerWithString:hexStr];
  [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
  [scanner scanHexInt:&hexInt];
  return hexInt;
}

- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
//   Convert hex string to an integer
  unsigned int hexint = [self intFromHexString:hexStr];

//   Create color object, specifying alpha as well
  UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
    blue:((CGFloat) (hexint & 0xFF))/255
    alpha:alpha];

  return color;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"showToast" isEqualToString:call.method]) {
        NSString *msg = call.arguments[@"msg"];
        NSString *gravity = call.arguments[@"gravity"];
        NSString *durationTime = call.arguments[@"time"];
        NSString *bgcolor = call.arguments[@"bgcolor"];
        NSString *textcolor = call.arguments[@"textcolor"];
        
        int time = 1;
        @try{
            time = [durationTime intValue];
        } @catch(NSException *e){
            time = 3;
        }
        
        if(time > 10 ) time = 10;
        else if(time < 1) time = 1;


        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        if(![bgcolor isEqualToString:@"null"]) {
            style.self.backgroundColor = [self getUIColorObjectFromHexString:bgcolor alpha:1.0];
        }

        if(![textcolor isEqualToString:@"null"]) {
            style.messageColor = [self getUIColorObjectFromHexString:textcolor alpha:1.0];
        }
        
        if([gravity isEqualToString:@"top"]) {
            [[UIApplication sharedApplication].delegate.window.rootViewController.view makeToast:msg
                                                                                        duration: time
                                                                                        position:CSToastPositionTop
                                                                                        style:style];
        } else if([gravity isEqualToString:@"center"]) {
            [[UIApplication sharedApplication].delegate.window.rootViewController.view makeToast:msg
                                                                                        duration: time
                                                                                        position:CSToastPositionCenter
                                                                                        style:style];
        } else {
            [[UIApplication sharedApplication].delegate.window.rootViewController.view makeToast:msg
                                                                                        duration: time
                                                                                        position:CSToastPositionBottom
                                                                                        style:style];
        }
        
        result(@"done");
    } else {
        result(FlutterMethodNotImplemented);
    }
}


// - (void)showToastView:(FlutterMethodCall*)call:(NSString*)msg {
//     [[UIApplication sharedApplication].delegate.window.rootViewController.view makeToast:msg];
// }

// func hexStringToUIColor (hex:String) -> UIColor {
//     var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

//     if (cString.hasPrefix("#")) {
//         cString.remove(at: cString.startIndex)
//     }

//     if ((cString.count) != 6) {
//         return UIColor.gray
//     }

//     var rgbValue:UInt32 = 0
//     Scanner(string: cString).scanHexInt32(&rgbValue)

//     return UIColor(
//         red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//         green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//         blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//         alpha: CGFloat(1.0)
//     )
// }

@end
