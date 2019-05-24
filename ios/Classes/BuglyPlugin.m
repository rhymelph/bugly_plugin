#import "BuglyPlugin.h"

@implementation BuglyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"bugly_plugin"
                                     binaryMessenger:[registrar messenger]];
    BuglyPlugin* instance = [[BuglyPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"initCrashReport" isEqualToString:call.method]) {
        NSString* appId=call.arguments[@"appId"];
        BOOL isDebug=call.arguments[@"isDebug"];
        BuglyConfig * config = [[BuglyConfig alloc] init];
        // 设置自定义日志上报的级别，默认不上报自定义日志
        config.reportLogLevel = BuglyLogLevelWarn;
        [Bugly startWithAppId:appId developmentDevice:isDebug config:config];
        result(nil);

    }else if ([@"postCatchedException" isEqualToString:call.method]) {
        NSString *crash_detail = call.arguments[@"stack"];
        NSString *crash_message = call.arguments[@"message"];
        if (crash_detail == nil || crash_detail == NULL) {
            crash_message = @"";
        }
        if ([crash_detail isKindOfClass:[NSNull class]]) {
            crash_message = @"";
        }
        NSException* ex = [[NSException alloc]initWithName:crash_message
                                                    reason:crash_detail
                                                  userInfo:nil];
        [Bugly reportException:ex];
        result(nil);

    }  else {
        result(FlutterMethodNotImplemented);
    }
}

@end

