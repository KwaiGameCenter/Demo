//
//  KGAppDelegate.m
//  KwaiGameSDK
//
//  Created by mookhf on 04/10/2018.
//  Copyright (c) 2018 mookhf. All rights reserved.
//

#import "KGAppDelegate.h"
#import "UIView+DemoSupport.h"
#import "KGUtil+QASupport.h"
#import <KwaiGameSDK-SpringFestival/KwaiGameSpringFestival.h>

#define kSetupController       @"KGSetupViewController"

@interface KGAppDelegate()

@property (nonatomic, strong) UIViewController *rootController;

@end

@implementation KGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    __block UIWindow *window = [UIApplication sharedApplication].delegate.window;
    window.rootViewController = [[NSClassFromString(kSetupController) alloc] init];
    window.rootViewController.view.backgroundColor = [UIColor whiteColor];
    [window makeKeyAndVisible];
    dispatch_async(dispatch_get_main_queue(), ^{
        [KwaiGameSpringFestival doSFWarmupTask:[KGUtil feakScheme]];
    });
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if ([KGUtil checkLandscape]) {
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end

