//
//  KGGameCenterViewController.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/11/23.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "KGGameCenterViewController.h"
#import "UIViewController+DemoSupport.h"
#import <KwaiGameSDK/KwaiGameSDK.h>
#import <KwaiGameSDK/KwaiGameSDK+Page.h>
#import <KwaiGameSDK-Oversea/KwaiGameSDK+Oversea.h>
#import <KwaiGameSDK-Community/KwaiGameSDK+Community.h>
#import <KwaiGameSDK-Community-Kwai/KGKwaiCommunity.h>
#import "DataUtil.h"
#import "KGUtil.h"
#import "KwaiBase.h"

DescClass(CommunityUser);

@interface KGGameCenterViewController ()<KwaiGameCommunityStateDelegate, KwaiGameCommunityDeepLinkDelegate>

@end

@implementation KGGameCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self showGameCenter];
}

- (void)showGameCenter {
    [self addSpliteLine:@"通用功能" frame:CGRectMake(20.0f, 40, DemoUIScreenWidth - 40.0f, 20)];
    [self addSubButton:@"个人中心" frame:CGRectMake(0, 80, 200, 30) selector:@selector(showCenter)];
    [self addSubButton:@"账户管理" frame:CGRectMake(0, 80, 200, 30) selector:@selector(showAccountManager)];
    // 以下功能限制海外使用
    if (![KwaiGameSDK sharedSDK].isOversea) {
        [self addSubButton:@"用户反馈" frame:CGRectMake(0, 130, 200, 30) selector:@selector(showFeedback)];
        [self addSpliteLine:@"社区功能" frame:CGRectMake(20.0f, 260, DemoUIScreenWidth - 40.0f, 20)];
        [self addSubButton:@"是否支持" frame:CGRectMake(0, 310, 200, 30) selector:@selector(checkCommunity)];
        [self addSubButton:@"游戏社区" frame:CGRectMake(0, 360, 200, 30) selector:@selector(showCommunity)];
        [self addSubButton:@"DeepLink..." frame:CGRectMake(0, 410, 200, 30) selector:@selector(openCommunityDeepLink)];
        [self addSubButton:@"发布图片" frame:CGRectMake(0, 460, 200, 30) selector:@selector(sendCommunityImageTopic)];
        [self addSubButton:@"发布视频" frame:CGRectMake(0, 510, 200, 30) selector:@selector(sendCommunityVideoTopic)];
        [self addSubButton:@"更新玩家等级" frame:CGRectMake(0, 560, 200, 30) selector:@selector(updateGamerLevel)];
        [self addSubButton:@"高级功能..." frame:CGRectMake(0, 610, 200, 30) selector:@selector(highLevelAPI)];
        [self addSpliteLine:@"RN社区" frame:CGRectMake(20.0f, 260, DemoUIScreenWidth - 40.0f, 20)];
        [self addSubButton:@"打开RN社区首页" frame:CGRectMake(0, 360, 200, 30) selector:@selector(showRNCommunity)];
        [self addSubButton:@"打开RN社区攻略页面" frame:CGRectMake(0, 360, 200, 30) selector:@selector(showRNStrategy)];
        [self addSubButton:@"打开RN社区英雄详情页面" frame:CGRectMake(0, 360, 200, 30) selector:@selector(showRNGameData)];
        [self addSpliteLine:@"客服中心" frame:CGRectMake(20.0f, 670, DemoUIScreenWidth - 40.0f, 20)];
        [self addSubButton:@"客服中心" frame:CGRectMake(0, 710, 200, 30) selector:@selector(showCustomCenter)];
        [self addSubButton:@"联系客服" frame:CGRectMake(0, 760, 200, 30) selector:@selector(showCustomLink)];
    }
}

- (void)showCenter {
    [[KwaiGameSDK sharedSDK] showGameCenter];
}

- (void)showAccountManager {
    [[KwaiGameSDK sharedSDK] showAccountManager];
}

- (void)showFeedback {
    if (![[KwaiGameSDK sharedSDK] isSupportCustomFeedbackPage]) {
        [self toast:@"请在后台配置对应地址"];
        return;
    }
    [[KwaiGameSDK sharedSDK] showCustomFeedbackPage];    // 新用户反馈页面
}


- (void)showCustomCenter {
    [[KwaiGameSDK sharedSDK] showCustomServicePage];
}

- (void)showCustomLink {
    [[KwaiGameSDK sharedSDK] showCustomServiceChatPage];
}

- (void)checkCommunity {
    if ([KwaiGameSDK sharedSDK].communityIsEnable) {
        [self toast:@"支持社区功能"];
    } else {
        [self toast:@"不支持社区功能"];
    }
}

- (void)showCommunity {
    if ([KwaiGameSDK sharedSDK].communityIsEnable) {
        [KwaiGameSDK sharedSDK].communityStateDelegate = self;
        [KwaiGameSDK sharedSDK].communityDeepLinkDelegate = self;
        [[KwaiGameSDK sharedSDK] showCommunity];
    } else {
        [self toast:@"社区功能准备中"];
    }
}

/// 打开rn社区
- (void)showRNCommunity {
    if([[KGKwaiCommunity community] communityIsEnable]){
        [[KGKwaiCommunity community] kwaiCommunityRouteWithRouteName:@"HOME" ExtraJSONString:@{} Completion:^(routeResultCode routeResultCode) {
            [self toast:@"正在打开RN社区"];
        }];
    } else {
        [self toast:@"社区功能准备中"];
    }
}

/// 打开rn社区 攻略页面
- (void)showRNStrategy {
    if([[KGKwaiCommunity community] communityIsEnable]){
        [[KGKwaiCommunity community] kwaiCommunityRouteWithRouteName:@"STRATEGY" ExtraJSONString:@{} Completion:^(routeResultCode routeResultCode) {
            [self toast:@"正在打开RN社区"];
        }];
    } else {
        [self toast:@"社区功能准备中"];
    }
}

/// 打开rn社区英雄详情
- (void)showRNGameData {
    if([[KGKwaiCommunity community] communityIsEnable]){
        [[KGKwaiCommunity community] kwaiCommunityRouteWithRouteName:@"GAMEDATA" ExtraJSONString:@{@"articleId" : @"6"} Completion:^(routeResultCode routeResultCode) {
            [self toast:@"正在打开RN社区"];
        }];
    } else {
        [self toast:@"社区功能准备中"];
    }
}

- (void)openCommunityDeepLink {
    if ([KwaiGameSDK sharedSDK].communityIsEnable) {
        [KwaiGameSDK sharedSDK].communityStateDelegate = self;
        [KwaiGameSDK sharedSDK].communityDeepLinkDelegate = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"DeepLink"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:actionCancel];
        
        UIAlertAction *actionCreateTopic = [UIAlertAction actionWithTitle:@"创建话题" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[KwaiGameSDK sharedSDK] jumpToCommunityWithRouter:CommunityRouterCatalog.TOPICS_CREATION];
        }];
        [alertController addAction:actionCreateTopic];
        
        UIAlertAction *actionPersonal = [UIAlertAction actionWithTitle:@"用户个人资料" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CommunityRouterCatalog *catalog = [CommunityRouterCatalog buildWithBasicCatalog:CommunityRouterCatalog.USER_PROFILE];
            catalog.params = @{
                @"game_user_id":[KwaiGameSDK sharedSDK].account.uid
            };
            [[KwaiGameSDK sharedSDK] jumpToCommunityWithRouter:catalog];
        }];
        [alertController addAction:actionPersonal];
        
        UIAlertAction *actionMessage = [UIAlertAction actionWithTitle:@"消息页" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[KwaiGameSDK sharedSDK] jumpToCommunityWithRouter:CommunityRouterCatalog.MESSAGEPAGE];
        }];
        [alertController addAction:actionMessage];
        
        UIAlertAction *actionCustom = [UIAlertAction actionWithTitle:@"自定义" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"自定义" message:nil preferredStyle:
            UIAlertControllerStyleAlert];
                [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"请输TopicId";
                }];
                UIAlertAction *actionDone = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    UITextField *titleTextField = alertVc.textFields.firstObject;
                    [[KwaiGameSDK sharedSDK] jumpToCommunityWithUrl:[NSString stringWithFormat:@"ktplay://topic?topic_id=%@",titleTextField.text]];
                }];
                UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alertVc addAction:actionDone];
                [alertVc addAction:actionCancel];
                [self presentViewController:alertVc animated:YES completion:nil];
        }];
        [alertController addAction:actionCustom];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self toast:@"社区功能准备中"];
    }
}

- (void)sendCommunityImageTopic {
    if ([KwaiGameSDK sharedSDK].communityIsEnable) {
        [KwaiGameSDK sharedSDK].communityStateDelegate = self;
        [KwaiGameSDK sharedSDK].communityDeepLinkDelegate = self;
        CommunityShareData *shareData = [[CommunityShareData alloc] init];
        shareData.title = @"我是一张图片";
        shareData.desc = @"游戏内";
        shareData.dataPath = [DataUtil testImage];
        [[KwaiGameSDK sharedSDK] shareToCommunity:CommunityShareType_Image shareData:shareData];
    } else {
        [self toast:@"社区功能准备中"];
    }
}

- (void)sendCommunityVideoTopic {
    if ([KwaiGameSDK sharedSDK].communityIsEnable) {
        [KwaiGameSDK sharedSDK].communityStateDelegate = self;
        [KwaiGameSDK sharedSDK].communityDeepLinkDelegate = self;
        CommunityShareData *shareData = [[CommunityShareData alloc] init];
        shareData.title = @"我是一个视频";
        shareData.desc = @"游戏内";
        shareData.dataPath = [DataUtil testVideo];
        [[KwaiGameSDK sharedSDK] shareToCommunity:CommunityShareType_Video shareData:shareData];
    } else {
        [self toast:@"社区功能准备中"];
    }
}

- (void)updateGamerLevel {
    [[KwaiGameSDK sharedSDK] updateUserData:@{kLevel:@(rand()%100)}];
    [self toast:@"更新完成"];
}

- (void)highLevelAPI {
    [KwaiGameSDK sharedSDK].communityStateDelegate = self;
    [KwaiGameSDK sharedSDK].communityDeepLinkDelegate = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"高级功能"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action1];
    
    if ([KwaiGameSDK sharedSDK].extendCommunity.disableKwaiGameAccount) {
        UIAlertAction *action1_5 = [UIAlertAction actionWithTitle:@"使用平台ID" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 登出
            [[KwaiGameSDK sharedSDK].extendCommunity logout];
            // 设置使用快手账号登录
            [KwaiGameSDK sharedSDK].extendCommunity.disableKwaiGameAccount = NO;
            [self toast:@"设置成功"];
        }];
        [alertController addAction:action1_5];
    } else {
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"使用游戏ID" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 登出
            [[KwaiGameSDK sharedSDK].extendCommunity logout];
            // 设置不使用快手账号登录
            [KwaiGameSDK sharedSDK].extendCommunity.disableKwaiGameAccount = YES;
            [self toast:@"设置成功"];
        }];
        [alertController addAction:action2];
    }
    
    if ([KwaiGameSDK sharedSDK].extendCommunity.disableKwaiGameAccount) {
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[KwaiGameSDK sharedSDK].extendCommunity login:[KGUtil util].uid
                                                   success:^(CommunityUser * _Nonnull user) {
                [self toast:@"登录成功"];
            }
                                                   failure:^(NSError * _Nonnull error) {
                [self toast:@"登录失败"];
            }];
        }];
        [alertController addAction:action3];
        
        UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"登出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[KwaiGameSDK sharedSDK].extendCommunity logout];
            [self toast:@"登出成功"];
        }];
        [alertController addAction:action4];
    }
    
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"获取账户信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CommunityUser *user = [[KwaiGameSDK sharedSDK].extendCommunity currentAccount];
        [self toast:[user description]];
    }];
    [alertController addAction:action5];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - KwaiGameCommunityStateDelegate

/// 社区功能可用状态变化
/// @param success YES：可用，NO：不可用
- (void)onAvailabilityChanged:(BOOL)success {
    if (success) {
        [self toast:@"社区功能准备完成"];
    } else {
        [self toast:@"不支持社区功能"];
        [self leaveCommunicaty];
    }
}

/// 是否有新的社区消息
/// @param hasNewActivity YES：可用，NO：不可用
- (void)onActivityChanged:(BOOL)hasNewActivity {
    if (hasNewActivity) {
        [self toast:@"有新的社区消息"];
    } else {
        [self toast:@"没有新的社区消息"];
    }
}

/// 社区可见状态变化
/// @param isVisible YES：可见，NO：不可见
- (void)onVisibilityChanged:(BOOL)isVisible {
    if (isVisible) {
        [self toast:@"社区展示"];
    } else {
        [self toast:@"社区关闭"];
        [self leaveCommunicaty];
    }
}

/// 社区音频播放状态变化
/// @param isSoundPlay YES：在播放，NO：不在播放
- (void)onSoundStateChanged:(BOOL)isSoundPlay {
    if (isSoundPlay) {
        [self toast:@"社区声音播放"];
    } else {
        [self toast:@"社区声音停止"];
    }
}

- (void)leaveCommunicaty {
    [KwaiGameSDK sharedSDK].communityStateDelegate = self;
    [KwaiGameSDK sharedSDK].communityDeepLinkDelegate = self;
}

#pragma mark - KwaiGameCommunityDeepLinkDelegate

/// 需要游戏方实现打开对应游戏页面的逻辑
/// @param deeplink 深度链接地址
- (void)onDeepLink:(NSString *)deeplink {
    [self toast:[NSString stringWithFormat:@"打开游戏深度链接: %@", deeplink]];
}

@end
