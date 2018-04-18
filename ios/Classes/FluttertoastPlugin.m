#import "FluttertoastPlugin.h"
#import "UIView+Toast.h"
// #import <fluttertoast/fluttertoast-Swift.h>

@interface QRCodeReaderPlugin()
@property (nonatomic, strong) UIView *toastview;
@property (nonatomic, retain) UIViewController *viewController;
@property (nonatomic, retain) UIViewController *toastViewController;
@end

@implementation FluttertoastPlugin {
    FlutterResult _result;
    UIViewController *_viewController;
}


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:CHANNEL_NAME
                                     binaryMessenger:[registrar messenger]];
//    UIViewController *viewController = (UIViewController *)registrar.messenger;
    UIViewController *viewController =
    [UIApplication sharedApplication].delegate.window.rootViewController;
    FluttertoastPlugin* instance = [[FluttertoastPlugin alloc] initWithViewController:viewController];
    [registrar addMethodCallDelegate:instance channel:channel];

}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"showToast" isEqualToString:call.method]) {
        [self showToastView:call];
        _result = result;
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
        //_viewController.view.backgroundColor = [UIColor  colorWithWhite:0.0 alpha:0.0];
        _viewController.view.backgroundColor = [UIColor  clearColor];
        _viewController.view.opaque = NO;
        [[ NSNotificationCenter defaultCenter]addObserver: self selector:@selector(rotate:)
                                                     name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)showToastView:(FlutterMethodCall*)call {
    _toastViewController = [[UIViewController alloc] init];
    [_viewController presentViewController:_toastViewController animated:NO completion:nil];

     _toastview= [[UIView alloc] init];
    _toastViewController.view = _toastview;

    [self.view makeToast:@"This is a piece of toast."];
}

@end
