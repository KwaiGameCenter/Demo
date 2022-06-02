//
//  KGSubGameViewController.m
//  KwaiGameSDK_Example
//
//  Created by 刘玮 on 2021/3/11.
//  Copyright © 2021 mookhf. All rights reserved.
//

#import "KGSubGameViewController.h"
#import "KGFollowingRelationViewController.h"

#import <KwaiGameSDK/KwaiGameSDK.h>
#import <KwaiGameSDK/KwaiGameSDK+Page.h>
#import <KwaiGameSDK/NSError+KwaiGame+Public.h>
#import <KwaiGameSDK-Subgame/KwaiGameSubGame.h>
#import <KwaiGameSDK-Subgame/KwaiSubGamePay+Public.h>

#import "UIView+Toast.h"
#define SG_TOAST(message)      [self.view makeToast: message];
#define SG_SHOW_TOAST(message) [self.view makeToastActivity:CSToastPositionCenter];
#define SG_HIDDEN_TOAST()      [self.view hideToastActivity];

#define KwaiGameSubGameId @"ks701154170818116969"

@interface KGSubGameViewController () <KwaiGameSubGameDelegate,KwaiGameCustomPageDelegate>

@end

@implementation KGSubGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    SG_SHOW_TOAST(@"加载中");
    [[KwaiGameSDK sharedSDK] checkHasBindAuthTypes:@[@(KwaiGameAuthTypeKwaiApp)] completion:^(BOOL hasBind, NSError *error) {
        GLOBAL_RUN_IN_MAIN_THREAD_START
        SG_HIDDEN_TOAST();
        if (error) {
            SG_TOAST(([NSString stringWithFormat: @"查询状态失败: %@(%ld)", (error.displayMsg ? error.displayMsg : @""), (long)error.code]));
        }
        if (!hasBind) {
            [self addSubLabel:@"子游戏目前只支持主游戏使用快手方式登录!!!" frame:CGRectMake(0, 80, 200, 90)];
            return;
        }
        [self addSubButton:@"登录" frame:CGRectMake(0, 80, 200, 30) selector:@selector(login)];
        [self addSubButton:@"登出" frame:CGRectMake(0, 80, 200, 30) selector:@selector(logout)];
        [self addSubButton:@"获取用户信息" frame:CGRectMake(0, 80, 200, 30) selector:@selector(requestUserInfo)];
        [self addSubButton:@"获取好友关系" frame:CGRectMake(0, 80, 200, 30) selector:@selector(requestRelationInfo)];
        [self addSubButton:@"实名认证" frame:CGRectMake(0, 80, 200, 30) selector:@selector(tryCert)];
        [self addSubButton:@"支付" frame:CGRectMake(0, 80, 200, 30) selector:@selector(pay)];
        [self addSubButton:@"打点示例" frame:CGRectMake(0, 80, 200, 30) selector:@selector(reportAction)];
        [self addSubButton:@"用户反馈" frame:CGRectMake(0, 80, 200, 30) selector:@selector(openFeedback)];
        [self addSubButton:@"直播和看直播" frame:CGRectMake(0, 80, 200, 30) selector:@selector(testLive)];
        [self addSubButton:@"CDKEY" frame:CGRectMake(0, 80, 200, 30) selector:@selector(testCDKEY)];
        
        
        [self setup];
        GLOBAL_RUN_IN_MAIN_THREAD_END
    }];
}

- (void)dealloc {
    [self setdown];
}

#pragma mark - Actions

- (void)setup {
    KwaiSubGameConfig *config = [[KwaiSubGameConfig alloc] init];
    config.subAppId = KwaiGameSubGameId;
    config.mainAppId = [KwaiGameSDK sharedSDK].config.appID;
    [[KwaiGameSubGame defaultGame] startWithConfig:config
                                          delegate:self];
    // 进入子游戏设置report的extension，之后所有打点都会带上这个字段
    [[KwaiGameSDK sharedSDK] setGameExtension:@{
        @"subGameAppId":[KwaiGameSubGame defaultGame].config.subAppId,
        @"subGameGameId":[KwaiGameSubGame defaultGame].account.uid ?: @"not login"
    }];
    // 进入子游戏设置CustomPage的Delegate，用于支持反馈等H5页面携带子游戏信息
    [[KwaiGameSDK sharedSDK] setCustomPageDelegate:self];
}

- (void)setdown {
    // 退出子游戏清空report的extension
    [[KwaiGameSDK sharedSDK] setGameExtension:@{}];
    // 退出子游戏清空CustomPage的Delegate
    [[KwaiGameSDK sharedSDK] setCustomPageDelegate:nil];
    [[KwaiGameSubGame defaultGame] setdown];
}

- (void)login {
    [[KwaiGameSubGame defaultGame] login:[KwaiGameSDK sharedSDK].account
                              completion:^(NSError * _Nonnull error) {
        
        if (error) {
            SG_TOAST(([NSString stringWithFormat:@"登录失败:%@",error]));
            return;
        }
        SG_TOAST(@"登录成功");
    }];
}

- (void)logout {
    [[KwaiGameSubGame defaultGame] logout];
    SG_TOAST(@"登出成功");
}

- (void)requestUserInfo {
    [[KwaiGameSubGame defaultGame] requestUserInfoWithCompletion:^(NSError * _Nonnull error, KwaiGameUser * _Nonnull user) {
        if (error) {
            SG_TOAST(([NSString stringWithFormat:@"获取失败:%@",error]));
            return;
        }
        SG_TOAST(([NSString stringWithFormat:@"用户信息:%@",user]));
    }];
}

- (void)requestRelationInfo {
    if ([KwaiGameSubGame defaultGame].account == nil) {
        SG_TOAST(@"请先登录子游戏");
        return;
    }
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"FollowingRelation" bundle:nil];
    KGFollowingRelationViewController *controller = (KGFollowingRelationViewController *)[sb instantiateViewControllerWithIdentifier:@"FollowingRelation"];
    [controller setAppId:[KwaiGameSubGame defaultGame].config.subAppId
                 account:[KwaiGameSubGame defaultGame].account];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)tryCert {
    [[KwaiGameSubGame defaultGame] certificateWithCompletion:^(BOOL certificated, NSError * _Nonnull error) {
        if (error) {
            SG_TOAST(([NSString stringWithFormat:@"实名失败:%@",error]));
            return;
        }
        SG_TOAST(([NSString stringWithFormat:@"实名成功:%d",certificated]));
    }];
}

- (void)pay {
    KwaiGamePayment *payment = [[KwaiGamePayment alloc] init];
    payment.productId = @"TestGameItem2";
    payment.payType = KwaiGamePayType_IAP;
    payment.monery = 600;
    payment.currencyType = @"CNY";
    SG_SHOW_TOAST(@"购买物品");
    [[KwaiGamePay pay] subGamePay: payment
                completion: ^(NSError *error) {
                    GLOBAL_RUN_IN_MAIN_THREAD_START
                    if (error) {
                        SG_HIDDEN_TOAST();
                        if (error.code == KwaiGamePayError_NeedCert) {
                            SG_TOAST(@"支付失败: 未完成实名认证");
                        } else if (error.code == KwaiGamePayError_UserCancel) {
                            SG_TOAST(@"支付失败: 用户取消");
                        } else {
                            SG_TOAST(([NSString stringWithFormat: @"支付失败: %@(%ld)", (error.displayMsg ? error.displayMsg : @""), (long)error.code]));
                        }
                        return;
                    }
                    SG_HIDDEN_TOAST();
                    SG_TOAST(@"支付成功");
        GLOBAL_RUN_IN_MAIN_THREAD_END
    }];
}

- (void)reportAction {
    [[KwaiGameSDK sharedSDK] reportAction:@"TestSubGame" param:@{
        @"subGameAppId":[KwaiGameSubGame defaultGame].config.subAppId,
        @"subGameGameId":[KwaiGameSubGame defaultGame].account.uid ?: @"not login"
    }];
}

- (void)openFeedback {
    if (![[KwaiGameSDK sharedSDK] isSupportCustomFeedbackPage]) {
        SG_TOAST(@"请在后台配置对应地址");
        return;
    }
    [[KwaiGameSDK sharedSDK] showCustomFeedbackPage];    // 新用户反馈页面
}

- (void)testLive {
    SG_TOAST(@"请使用主游戏接口和能力");
}

- (void)testCDKEY {
    SG_TOAST(@"请使用主游戏接口和能力");
}

#pragma mark - KwaiGameSubGameDelegate

- (void)subGameForceLogout {
    [self logout];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - KwaiGameCustomPageDelegate

- (NSDictionary<NSString *,NSString *> *)customCookies {
    return @{
        @"gamename":@"luuweis",
        @"gameversion":@"0.0.1"
    };
}

@end
