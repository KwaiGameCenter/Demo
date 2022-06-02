//
//  OverSeaToolsViewController.m
//  KwaiGameSDK_Example
//
//  Created by xingguo sun on 2021/1/27.
//  Copyright © 2021 mookhf. All rights reserved.
//

#import "OverSeaToolsViewController.h"
#import <KwaiGameSDK/KwaiGameSDK.h>
#import <KwaiGameSDK-AD/KwaiGameADManager.h>
#import <UIView+Toast.h>

@interface OverSeaToolsViewController ()
@end

@implementation OverSeaToolsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self customUI];
}

- (void)customUI {
    [self addSubButton:@"Crash" frame:CGRectMake(20.0, 460, 100, 40) selector:@selector(crash)];
    [self addSubButton:@"数据打点" frame:CGRectMake(20.0, 515, 100, 40) selector:@selector(reportLog)];
    [self addSubButton:@"内购收入打点" frame:CGRectMake(20.0, 560, 100, 40) selector:@selector(purchaseLog)];
    [self addSubButton:@"关卡打点" frame:CGRectMake(20.0, 615, 100, 40) selector:@selector(levelLog)];
    [self addSubButton:@"自定义打点" frame:CGRectMake(20.0, 715, 180, 40) selector:@selector(customLog)];
}

- (void)levelLog {
    [[KwaiGameSDK sharedSDK] reportUserLevel:@"3"];
    [self.view toast:@"关卡打点！"];
}

- (void)purchaseLog {
    [[KwaiGameSDK sharedSDK] reportPay:200
                            amountType:@"USD"
                               payType:nil
                               orderNo:nil];
    [self.view toast:@"内购打点！"];
}

- (void)customLog {
    [[KwaiGameSDK sharedSDK] reportCustomEvent:@"test_appsFlyer_event"
                                        params:@{@"clickCount":@3}];
    [self.view toast:@"AppsFlyer打点！"];
}

- (void)reportLog {
    [[KwaiGameSDK sharedSDK] reportAction:@"test_report_oversea"];
    [self.view toast:@"log content test_report_oversea"];
}

- (void)crash
{
    [@[] objectAtIndex:0];
}

@end
