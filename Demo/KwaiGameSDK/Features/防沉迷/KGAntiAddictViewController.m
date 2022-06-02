//
//  KGAntiAddictViewController.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/12/3.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "KGAntiAddictViewController.h"
#import "UIViewController+DemoSupport.h"
#import "KGAppDelegate.h"
#import "KGGlobalDelegate+Public.h"
#import <KwaiGameSDK/KwaiGameAntiAddict.h>

@interface KGAntiAddictViewController ()

@end

@implementation KGAntiAddictViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if ([[UIApplication sharedApplication].delegate isKindOfClass:KGAppDelegate.class]) {
        [KGGlobalDelegate delegate].gaming = YES;
    }
    [self addSpliteLine:@"该页面，标记Demo为游戏中状态，将不会弹出防沉迷等阻断提示。" frame:CGRectMake(0.0f, 0.0f, DemoUIScreenWidth - 20.0f, 100.0f)];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([[UIApplication sharedApplication].delegate isKindOfClass:KGAppDelegate.class]) {
        [KGGlobalDelegate delegate].gaming = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [KwaiGameAntiAddict syncAntiAddictStatus];
        });
    }
}

@end
