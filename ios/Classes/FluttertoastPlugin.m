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

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"showToast" isEqualToString:call.method]) {
        NSString *msg = call.arguments[@"msg"];
        NSString *gravity = call.arguments[@"gravity"];
        NSString *durationTime = call.arguments[@"time"];
        
        int time = 1;
        @try{
            time = [durationTime intValue];
        } @catch(NSException *e){
            time = 3;
        }
        
        if(time > 10 ) time = 10;
        else if(time < 1) time = 1;
        
        if([gravity isEqualToString:@"top"]) {
            [[UIApplication sharedApplication].delegate.window.rootViewController.view makeToast:msg
                                                                                        duration: time
                                                                                        position:CSToastPositionTop];
        } else if([gravity isEqualToString:@"center"]) {
            [[UIApplication sharedApplication].delegate.window.rootViewController.view makeToast:msg
                                                                                        duration: time
                                                                                        position:CSToastPositionCenter];
        } else {
            [[UIApplication sharedApplication].delegate.window.rootViewController.view makeToast:msg
                                                                                        duration: time
                                                                                        position:CSToastPositionBottom];
        }
        
        result(@"done");
    } else {
        result(FlutterMethodNotImplemented);
    }
}


- (void)showToastView:(FlutterMethodCall*)call:(NSString*)msg {
    [[UIApplication sharedApplication].delegate.window.rootViewController.view makeToast:msg];
}

- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
  // Convert hex string to an integer
  unsigned int hexint = [self intFromHexString:hexStr];

  // Create color object, specifying alpha as well
  UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
    blue:((CGFloat) (hexint & 0xFF))/255
    alpha:alpha];

  return color;
}

@end
