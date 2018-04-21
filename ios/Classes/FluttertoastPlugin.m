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


        if((durationTime == (id)[NSNull null] || durationTime.length == 0 )) {
            [[UIApplication sharedApplication].delegate.window.rootViewController.view makeToast:msg
                                                                                        duration: 3
                                                                                        position:CSToastPositionBottom];
        } else {
            if([gravity isEqualToString:@"top"]) {
                [[UIApplication sharedApplication].delegate.window.rootViewController.view makeToast:msg
                                                                                            duration: [durationTime intValue]
                                                                                            position:CSToastPositionTop];
            } else if([gravity isEqualToString:@"center"]) {
                [[UIApplication sharedApplication].delegate.window.rootViewController.view makeToast:msg
                                                                                            duration: [durationTime intValue]
                                                                                            position:CSToastPositionCenter];
            } else {
                [[UIApplication sharedApplication].delegate.window.rootViewController.view makeToast:msg
                                                                                            duration: [durationTime intValue]
                                                                                            position:CSToastPositionBottom];
            }
        }

        result(@"done");
    } else {
        result(FlutterMethodNotImplemented);
    }
}


- (void)showToastView:(FlutterMethodCall*)call:(NSString*)msg {
    [[UIApplication sharedApplication].delegate.window.rootViewController.view makeToast:msg];
}

@end