//
//  KGViewController.m
//  KwaiGameSDK
//
//  Created by mookhf on 04/10/2018.
//  Copyright (c) 2018 mookhf. All rights reserved.
//

#import "KGViewController.h"
#import <KwaiGameSDK/KwaiGameSDK.h>
#import <KwaiGameSDK-Oversea/KwaiGameSDK+Oversea.h>

@implementation KGViewController

- (NSString *)titleName {
    return [NSString stringWithFormat:@"KwaiGameSDK(V%@)", [KwaiGameSDK sharedSDK].sdkVersion];
}

- (BOOL)supportSetting {
    return YES;
}

- (NSDictionary<NSString *,KGFreatureInfo *> *)features {
    return [NSMutableDictionary dictionaryWithDictionary:@{
    
        @"基础功能"
        :kgFeatureWithName(@"基础功能", (^(KGFreatureInfo *info) {
            info.splitLine = YES;
        })),
        
        @"KGKwaiGameZoneController"
        :kgFeatureWithName(@"游戏区服", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGKwaiGameZoneController";
            info.iconName = @"G";
            info.needLogind = NO;
            info.supportOversea = YES;
        })),
        
        @"KGLoginViewController"
        :kgFeatureWithName(@"登录登出", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGLoginViewController";
            info.iconName = @"\U0000e66b";
            info.needLogind = NO;
            info.supportOversea = YES;
        })),
              
        @"KGPayViewController"
        :kgFeatureWithName(@"支付", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGPayViewController";
            info.storyboardName = @"Pay";
            info.iconName = @"\U0000e6b9";
            info.supportOversea = YES;
        })),
        
        @"KGDownloadViewController"
        :kgFeatureWithName(@"资源下载", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGDownloadViewController";
            info.iconName = @"D";
            info.needLogind = NO;
        })),
        
        @"KGReportViewController"
        :kgFeatureWithName(@"数据上报", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGReportViewController";
            info.iconName = @"\U0000e60e";
            info.needLogind = NO;
            info.supportOversea = YES;
        })),
        
        @"KGScanViewController"
        :kgFeatureWithName(@"扫码", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGScanViewController";
            info.iconName = @"\U0000e6b9";
        })),
        
        @"KGAntiAddictViewController"
        :kgFeatureWithName(@"防沉迷", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGAntiAddictViewController";
            info.iconName = @"\U0000e614";
        })),
        
        @"KGGameCenterViewController"
        :kgFeatureWithName(@"用户中心", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGGameCenterViewController";
            info.iconName = @"\U0000e617";
            info.supportOversea = YES;
        })),
        
        @"广告能力"
        :kgFeatureWithName(@"广告能力", (^(KGFreatureInfo *info) {
            info.splitLine = YES;
        })),
        
        @"AutoViewController"
        :kgFeatureWithName(@"聚合广告", (^(KGFreatureInfo *info) {
            info.controllerName = @"AutoViewController";
            info.iconName = @"\U0000e60d";
            info.supportOversea = NO;
        })),
        
        @"OverseaViewController"
        :kgFeatureWithName(@"海外广告", (^(KGFreatureInfo *info) {
            info.controllerName = @"OverseaViewController";
            info.iconName = @"\U0000e60d";
            info.supportOversea = YES;
            info.supportInner = NO;
        })),
        
        @"KGPromotionADViewController"
        :kgFeatureWithName(@"导流广告", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGPromotionADViewController";
            info.iconName = @"\U0000e60d";
            info.supportOversea = YES;
            info.supportInner = YES;
        })),
        
        @"OverSeaToolsViewController"
        :kgFeatureWithName(@"聚合工具", (^(KGFreatureInfo *info) {
            info.controllerName = @"OverSeaToolsViewController";
            info.iconName = @"[T]";
            info.supportOversea = YES;
            info.supportInner = NO;
        })),
        
        @"快手能力"
        :kgFeatureWithName(@"快手能力", (^(KGFreatureInfo *info) {
            info.splitLine = YES;
        })),
        
        @"KGLiveViewController"
        :kgFeatureWithName(@"一键直播", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGLiveViewController";
            info.storyboardName = @"Live";
            info.iconName = @"\U0000e73a";
        })),
        
        @"KGWatchLiveViewController"
        :kgFeatureWithName(@"观看直播", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGWatchLiveViewController";
            info.iconName = @"\U0000e614";
        })),
        
        @"KGGameRecordViewController"
        :kgFeatureWithName(@"游戏录屏", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGGameRecordViewController";
            info.storyboardName = @"Record";
            info.iconName = @"\U0000e60b";
        })),
        
        @"KGSyncVideoViewController"
        :kgFeatureWithName(@"短视频", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGSyncVideoViewController";
            info.iconName = @"\U0000e67c";
        })),
        
        @"KGFollowingRelationViewController"
        :kgFeatureWithName(@"快手关系链", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGFollowingRelationViewController";
            info.storyboardName = @"FollowingRelation";
            info.iconName = @"\U0000e60c";
        })),
        
        @"扩展能力"
        :kgFeatureWithName(@"扩展能力", (^(KGFreatureInfo *info) {
            info.splitLine = YES;
        })),
        
        @"KGShareViewController"
        :kgFeatureWithName(@"三方分享", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGShareViewController";
            info.iconName = @"\U0000e613";
        })),
        
        @"KGVoipViewController"
        :kgFeatureWithName(@"语音聊天", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGVoipViewController";
            info.iconName = @"\U0000e608";
        })),
        
        @"KGMessageViewController"
        :kgFeatureWithName(@"文字聊天", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGMessageViewController";
            info.iconName = @"\U0000e615";
        })),
        
        @"KGCDKeyViewController"
        :kgFeatureWithName(@"礼包码", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGCDKeyViewController";
            info.storyboardName = @"CDKey";
            info.iconName = @"\U0000e685";
        })),
        
        @"KGGiftActivityViewController"
        :kgFeatureWithName(@"礼包活动", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGGiftActivityViewController";
            info.iconName = @"\U0000e685";
        })),
        
        @"KGSensitiveFilterViewController"
        :kgFeatureWithName(@"敏感词", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGSensitiveFilterViewController";
            info.storyboardName = @"SensitiveFilter";
            info.iconName = @"\U0000e64f";
        })),
        
        @"KGWebViewController"
        :kgFeatureWithName(@"网页", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGWebViewController";
            info.iconName = @"\U0000e63a";
            info.needLogind = NO;
            info.supportInner = YES;
            info.supportOversea = YES;
        })),
        
        // 下线功能
//        @"KGWithdrawViewController"
//        :kgFeatureWithName(@"提现", (^(KGFreatureInfo *info) {
//            info.controllerName = @"KGWithdrawViewController";
//            info.iconName = @"\U0000e607";
//        })),
        
        @"KGABTestViewController"
        :kgFeatureWithName(@"AB测试", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGABTestViewController";
            info.iconName = @"\U0000e7d7";
        })),
        @"KGFIRABTestViewController"
        :kgFeatureWithName(@"FirebaseAB测试", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGFIRABTestViewController";
            info.iconName = @"F";
            info.supportOversea = YES;
        })),
        
        @"KGAppInfoViewController"
        :kgFeatureWithName(@"设置", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGAppInfoViewController";
            info.iconName = @"\U0000e624";
            info.hidden = YES;
            info.needLogind = NO;
            info.supportOversea = YES;
        })),
        
        @"KGSubGameViewController"
        :kgFeatureWithName(@"子游戏", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGSubGameViewController";
            info.iconName = @"Z";
            info.hidden = NO;
            info.needLogind = YES;
        })),
        
        @"KGKwaiJumpViewController"
        :kgFeatureWithName(@"快跳", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGKwaiJumpViewController";
            info.iconName = @"J";
            info.hidden = NO;
            info.needLogind = NO;
            info.supportOversea = YES;
        })),
        
        @"KGCustomUIViewController"
        :kgFeatureWithName(@"自定义UI", (^(KGFreatureInfo *info) {
            info.controllerName = @"KGCustomUIViewController";
            info.iconName = @"C";
            info.hidden = NO;
            info.needLogind = YES;
        })),
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 自动登录
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.navigationController.viewControllers.count == 1) {
            [self pushFeatureController:self.features[@"KGLoginViewController"]];
        }
    });
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([KGUtil checkLandscape]) {
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[KwaiGameSDK sharedSDK] log:@"[page]回到主页"];
}

- (void)gotoSettingFeature {
    [self pushFeatureController:self.features[@"KGAppInfoViewController"]];
}

- (void)onCellWillDisplay:(UITableViewCell *)cell info:(KGFreatureInfo *)info {
    if ([info.controllerName isEqualToString:@"KGLoginViewController"]) {
        if ([KwaiGameSDK sharedSDK].account != nil) {
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:15.0f];
            cell.detailTextLabel.textColor = [UIColor greenColor];
            cell.detailTextLabel.text = @"已登录";
        } else {
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:15.0f];
            cell.detailTextLabel.textColor = [UIColor redColor];
            cell.detailTextLabel.text = @"未登录";
        }
    }
}

- (BOOL)hiddenFeature:(KGFreatureInfo *)info {
    if (!info.hidden) {
        BOOL display = YES;
        if (info.onlyQA) {
            if (![KGUtil checkQAEnv]) {
                display = NO;
            }
        }
        if (display) {
            if ([KwaiGameSDK sharedSDK].isOversea) {
                if (!info.supportOversea) {
                    display = NO;
                }
            }
            if (![KwaiGameSDK sharedSDK].isOversea) {
                if (!info.supportInner) {
                    display = NO;
                }
            }
        }
        if (display) {
            if (info.needLogind) {
                if ([KwaiGameSDK sharedSDK].account == nil) {
                    display = NO;
                }
            }
        }
        return !display;
    }
    return NO;
}

- (BOOL)onFeatureControllerWillPresent:(KGFreatureInfo *)info {
    if (info.needLogind && [KwaiGameSDK sharedSDK].account == nil) {
        [self.view toast:@"请先登录"];
        return NO;
    }
    [[KwaiGameSDK sharedSDK] log:@"[page]进入%@", info.displayName];
    return YES;
}

@end
