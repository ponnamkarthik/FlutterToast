#import "FluttertoastPlugin.h"
#import "UIView+Toast.h"

static NSString *const CHANNEL_NAME = @"PonnamKarthik/fluttertoast";

@interface FluttertoastPlugin ()
@property(nonatomic, retain) FlutterMethodChannel *channel;
@end

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
    instance.channel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];

}

- (UIColor*) colorWithHex: (NSUInteger)hex {
    CGFloat red, green, blue, alpha;

    red = ((CGFloat)((hex >> 16) & 0xFF)) / ((CGFloat)0xFF);
    green = ((CGFloat)((hex >> 8) & 0xFF)) / ((CGFloat)0xFF);
    blue = ((CGFloat)((hex >> 0) & 0xFF)) / ((CGFloat)0xFF);
    alpha = hex > 0xFFFFFF ? ((CGFloat)((hex >> 24) & 0xFF)) / ((CGFloat)0xFF) : 1;

    return [UIColor colorWithRed: red green:green blue:blue alpha:alpha];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if([@"cancel" isEqualToString:call.method]) {
        [[UIApplication sharedApplication].delegate.window.rootViewController.view hideAllToasts];
        result([NSNumber numberWithBool:true]);
    } else if ([@"showToast" isEqualToString:call.method]) {
        NSString *msg = call.arguments[@"msg"];
        NSString *gravity = call.arguments[@"gravity"];
        NSString *durationTime = call.arguments[@"time"];
        NSNumber *bgcolor = call.arguments[@"bgcolor"];
        NSNumber *textcolor = call.arguments[@"textcolor"];
        NSNumber *size = call.arguments[@"size"];
        NSNumber *fontSize = call.arguments[@"fontSize"];

        CGFloat cgf = [fontSize doubleValue];
        int time = 1;
        @try {
            time = [durationTime intValue];
        } @catch (NSException *e) {
            time = 3;
        }

        if (time > 10) time = 10;
        else if (time < 1) time = 1;


        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.messageFont = [UIFont systemFontOfSize:cgf];
        style.backgroundColor = [self colorWithHex:bgcolor.unsignedIntegerValue];
        style.messageColor = [self colorWithHex:textcolor.unsignedIntegerValue];

        if (@available(iOS 11.0, *)) {
            UIWindow *window = UIApplication.sharedApplication.keyWindow;
            CGFloat topPadding = window.safeAreaInsets.top;
            CGFloat bottomPadding = window.safeAreaInsets.bottom;
        }

        if ([gravity isEqualToString:@"top"]) {
            [[[UIApplication sharedApplication].windows lastObject] makeToast:msg
                                                                                        duration:time
                                                                                        position:CSToastPositionTop
                                                                                           style:style
                                                                                           ];
        } else if ([gravity isEqualToString:@"center"]) {
            [[[UIApplication sharedApplication].windows lastObject] makeToast:msg
                                                                                        duration:time
                                                                                        position:CSToastPositionCenter
                                                                                           style:style
                                                                                          ];
        } else {
            [[[UIApplication sharedApplication].windows lastObject] makeToast:msg
                                                                                        duration:time
                                                                                        position:CSToastPositionBottom
                                                                                           style:style
                                                                                           ];
        }
        result([NSNumber numberWithBool:true]);

    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
