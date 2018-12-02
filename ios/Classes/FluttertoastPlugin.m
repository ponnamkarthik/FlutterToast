#import "FluttertoastPlugin.h"
#import "UIView+Toast.h"
// #import <fluttertoast/fluttertoast-Swift.h>

static NSString *const CHANNEL_NAME = @"PonnamKarthik/fluttertoast";

@implementation FluttertoastPlugin {
    FlutterResult _result;
}


+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
            methodChannelWithName:CHANNEL_NAME
                  binaryMessenger:[registrar messenger]];
    UIViewController *viewController =
            [UIApplication sharedApplication].delegate.window.rootViewController;
    FluttertoastPlugin *instance = [[FluttertoastPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];

}

- (UIColor *)getUIColorObjectFromInt:(unsigned int)value {
    UIColor *color =
            [UIColor colorWithRed:((CGFloat) ((value & 0xFF) << 16)) / 255
                            green:((CGFloat) ((value & 0xFF) << 8)) / 255
                             blue:((CGFloat) ((value & 0xFF) << 0)) / 255
                            alpha:((CGFloat) ((value & 0xFF) << 24)) / 255];

    return color;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"showToast" isEqualToString:call.method]) {
        NSString *msg = call.arguments[@"msg"];
        NSString *gravity = call.arguments[@"gravity"];
        NSString *durationTime = call.arguments[@"time"];
        NSNumber *bgcolor = call.arguments[@"bgcolor"];
        NSNumber *textcolor = call.arguments[@"textcolor"];

        int time = 1;
        @try {
            time = [durationTime intValue];
        } @catch (NSException *e) {
            time = 3;
        }

        if (time > 10) time = 10;
        else if (time < 1) time = 1;


        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];

        style.backgroundColor = [self getUIColorObjectFromInt:bgcolor.unsignedIntValue];
        style.messageColor = [self getUIColorObjectFromInt:textcolor.unsignedIntValue];

        if ([gravity isEqualToString:@"top"]) {
            [[UIApplication sharedApplication].delegate.window.rootViewController.view makeToast:msg
                                                                                        duration:time
                                                                                        position:CSToastPositionTop
                                                                                           style:style];
        } else if ([gravity isEqualToString:@"center"]) {
            [[UIApplication sharedApplication].delegate.window.rootViewController.view makeToast:msg
                                                                                        duration:time
                                                                                        position:CSToastPositionCenter
                                                                                           style:style];
        } else {
            [[UIApplication sharedApplication].delegate.window.rootViewController.view makeToast:msg
                                                                                        duration:time
                                                                                        position:CSToastPositionBottom
                                                                                           style:style];
        }

        result(@"done");
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
