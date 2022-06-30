//
//  KGSetupViewController.m
//  KwaiGameSDK_Example
//
//  Created by 刘玮 on 2021/7/13.
//  Copyright © 2021 mookhf. All rights reserved.
//

#import "KGSetupViewController.h"
#import "KGAppDelegate.h"
#import "KGGlobalDelegate+Public.h"
#import "UIWindow+FloatingView.h"
#import <KwaiGameSDK/KwaiGameSDK.h>
#import <KwaiGameSDK-Oversea/KwaiGameSDK+Oversea.h>
#import <KwaiGameSDK-OpenPlatform/KwaiGameSDK+OpenPlatform.h>
#import <KwaiGameSDK-AD/KwaiGameADManager.h>
#import <KwaiGameSDK/KwaiGameSDK+Page.h>
#import "KGUtil.h"
#import "KwaiBase.h"

#define kKwaiGameSDKDemoAppId [KGUtil feakScheme]
#define kMainController       @"KGViewController"
#define kSettingController    @"KGAppInfoViewController"

@interface KGGlobalDelegate () <KwaiGameSDKGameLifeDelegate,KwaiGameOverSeaInitDelegate>

@property (nonatomic, strong) UINavigationController *rootController;
@property (nonatomic, weak) id<KwaiGameSDKGameLifeDelegate> delegate;

+ (instancetype)delegate;

@end

@implementation KGGlobalDelegate

+ (instancetype)delegate {
    return [KGGlobalDelegate sharedInstance];
}

SINGLETON_IMPLEMENTS(KGGlobalDelegate, {
});

#pragma mark - KwaiGameSDKGameLifeDelegate
- (BOOL)isGaming {
    if ([[UIApplication sharedApplication].delegate isKindOfClass:KGAppDelegate.class]) {
        return self.gaming;
    }
    return NO;
}

- (void)forceLogout {
    [self.rootController popToRootViewControllerAnimated:YES];
    [[KwaiGameSDK sharedSDK] logoutWithCompletion:^(NSError *error) {}];
}

- (void)fetchGameServiceToken:(void (^)(NSError *, NSString *))fetchComplete {
    // 涉及到的功能IM, Voip
    // 此部分需要游戏server实现通过游戏uid获取token的接口
    // https://doc.game.kuaishou.com/page?navId=49&subnavId=50&id=110
    [KGTokenHelper requestAccessToken: ^(NSError *error, NSString *accessToken) {
        if (error) {
            fetchComplete(error, nil);
            return;
        }
        [KGTokenHelper requestIMToken: accessToken
                                  uid: [KGUtil util].uid
                           completion: ^(NSError *error, NSString *token) {
                               if (error) {
                                   fetchComplete(error, nil);
                                   return;
                               }
                               fetchComplete(nil, token);
                           }];
    }];
}

- (void)initSuccess {
    [[KwaiGameSDK sharedSDK] log:@"initSuccess"];
    if (KWAI_IS_DELEGATE_RSP_SEL(self.delegate, initSuccess)) {
        [self.delegate initSuccess];
    }
}

- (void)permissionAgreeClick {
    [[KwaiGameSDK sharedSDK] log:@"permissionAgreeClick"];
    if (KWAI_IS_DELEGATE_RSP_SEL(self.delegate, permissionAgreeClick)) {
        [self.delegate permissionAgreeClick];
    }
}


@end

@interface KGSetupViewController () <KwaiGameSDKGameLifeDelegate>

@property (nonatomic, strong) UISwitch *agreeSwitch;

@end

@implementation KGSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customInit];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self chooseDevelopMode];
    });

}

- (void)customInit {
    [self addSubView:[[UIView alloc] init] frame:CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AppIcon"]];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubView:iconView frame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
    [self addSubView:[[UIView alloc] init] frame:CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)];
    [self addSubButton:@"开始接入" frame:CGRectMake(0.0f, 0.0f, 250.0f, 50.0f) selector:@selector(enterGame)];
    [self addSubButton:@"配置" frame:CGRectMake(0.0f, 0.0f, 100.0f, 30.0f) selector:@selector(enterSetting)];
    if (!KGUtil.hasAgreeEnterGame) {
        [self addSpliteLine:@"请详细阅读以下内容" frame:CGRectMake(0.0f, 0.0f, CGRectGetWidth([UIScreen mainScreen].bounds) - 50, 50.0f)];
        [self addSubButton:@"查看用户协议" frame:CGRectMake(0.0f, 0.0f, 200.0f, 25.0f) selector:@selector(openUseAgreement)];
        [self addSubButton:@"查看隐私政策" frame:CGRectMake(0.0f, 0.0f, 200.0f, 25.0f) selector:@selector(openUsePrivacy)];
        [self addSubButton:@"查看儿童保护指引" frame:CGRectMake(0.0f, 0.0f, 200.0f, 25.0f) selector:@selector(openChildPrivacy)];
        [self addSubButton:@"查看第三方服务清单" frame:CGRectMake(0.0f, 0.0f, 200.0f, 25.0f) selector:@selector(openOtherPolicy)];
        [self addSubButton:@"查看隐私弹窗" frame:CGRectMake(0.0f, 0.0f, 200.0f, 25.0f) selector:@selector(openPrivacyAlert)];
        self.agreeSwitch = [self addSubSwitch:@"我已详细阅读并同意以上内容" frame:CGRectMake(0.0f, 0.0f, 250.0f, 100.0f) selector:@selector(onAgreePricacy)];
    }
}

- (void)chooseDevelopMode {
    if (![KGUtil hasOverseaType]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择接入方式" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"接入国内SDK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [KGUtil setOverseaType:0];
            [self setupApp];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"接入海外SDK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [KGUtil setOverseaType:1];
            [self setupApp];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self setupApp];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self setupApp];
    }
}

- (void)openUseAgreement {
    [[KwaiGameSDK sharedSDK] showPrivacyProtocol:kKwaiGameProtocolPolicy];
}

- (void)openUsePrivacy {
    [[KwaiGameSDK sharedSDK] showPrivacyProtocol:kKwaiGameProtocolPrivacy];
}

- (void)openPrivacyAlert {
    [[KwaiGameSDK sharedSDK] showPrivacyProtocol:kKwaiGameProtocolAllin];
}

- (void)openChildPrivacy {
    [[KwaiGameSDK sharedSDK] showPrivacyProtocol:kKwaiGameProtocolPrivacyChild];
}

- (void)openOtherPolicy {
    [[KwaiGameSDK sharedSDK] showPrivacyProtocol:kKwaiGameProtocolOther];
}

- (void)enterGame {
    if (KGUtil.hasAgreeEnterGame) {
        if ([KwaiGameSDK sharedSDK].isOversea) {
            [[KwaiGameSDK sharedSDK] setOverseaPrivacyState:YES];
        }
        __block UIWindow *window = [UIApplication sharedApplication].delegate.window;
        if (window.rootViewController == self) {
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[NSClassFromString(kMainController) alloc] init]];
            if (@available(iOS 15.0, *)) {
                navController.navigationBar.scrollEdgeAppearance = navController.navigationBar.standardAppearance;
            }
            [KGGlobalDelegate delegate].rootController = navController;
            window.rootViewController = [KGGlobalDelegate delegate].rootController;
            [window makeKeyAndVisible];
            [window setupFloatingBox];
        }

    } else {
        [self toast:@"点击同意协议后，进入游戏!!!"];
    }
}

- (void)enterSetting {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[NSClassFromString(kSettingController) alloc] init]];
    if (@available(iOS 15.0, *)) {
        navController.navigationBar.scrollEdgeAppearance = navController.navigationBar.standardAppearance;
    }
    navController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)onAgreePricacy {
    KGUtil.hasAgreeEnterGame = self.agreeSwitch.isOn;
}

#pragma mark - SDK Setup

- (void)setupApp {
    if ([KGUtil overseaType] > 0) {
        [self setupOverseaSDK];
    } else {
        [self setupSDK];
        [self setupThirdPartyShare];
    }
    // 如果是QA环境，模拟上报一次打点启动失败
    if ([KGUtil checkQAEnv]) {
        [KGUtil reportKanasError];
    }
}

- (void)setupSDK {
    // 注册KwaiGameSDK
    KwaiGameSDKConfig *config = [[KwaiGameSDKConfig alloc] init];
    config.appID = kKwaiGameSDKDemoAppId;
    config.universalLink = @"https://apidoc.game.kuaishou.com/";   // 用于支持三方登录跳转
    config.moreScopes = @[];                                    // 需要扩展支持的Scopes
    config.wxAppID = @"wxb1a72eb205e0d7f9";                     // 微信的应用Id
    config.qqAppID = @"101896886";                              // QQ的应用Id
    config.distributionChannel = @"appstore";                   // 添加发布渠道，如果不添加则使用channel字段
    config.hideLogo = KGUtil.hideLogo;                          // 通过字段控制logo显示隐藏
    
    [KGGlobalDelegate delegate].delegate = self;
    [[KwaiGameSDK sharedSDK] startWithConfig:config delegate:[KGGlobalDelegate delegate]];
    [[KwaiGameSDK sharedSDK] log:@"--- 当前环境： %@", @([KwaiGameSDK sharedSDK].currentEnv)];
    [[KwaiGameSDK sharedSDK] log:@"--- 当前sdk版本： %@", [KwaiGameSDK sharedSDK].sdkVersion];
    [[KwaiGameSDK sharedSDK] log:@"--- 当前sdk branch： %@", [KwaiGameSDK sharedSDK].sdkBranch];
    // 处理防沉迷状态
}

- (void)setupOverseaSDK {
    KwaiGameSDKOverseaConfig *config = [[KwaiGameSDKOverseaConfig alloc] init];
    config.appID = kKwaiGameSDKDemoAppId;
    if ([KGUtil overseaType] == 1) {
        config.overseaType = KGOverseaType_LiteGame;
    } else {
        config.overseaType = KGOverseaType_ComplexGame;
    }
    config.enableOverseaPrivacy = KGUtil.enableSDKPolicyPrivacy;
    config.hideLogo = KGUtil.hideLogo;
    [KGGlobalDelegate delegate].delegate = self;
    config.universalLink = @"https://doc.game.kuaishou.com/"; 
    config.facebookAppID = @"287713076593159";// Facebook的应用Id
    config.googleAppID = @"32793569519-4cnars1nbkbpvoq9cqsu0te7l9eag9mj.apps.googleusercontent.com";// google的应用Id
    
    [[KwaiGameSDK sharedSDK] startOverseaWithConfig:config delegate:[KGGlobalDelegate delegate]];
}

- (void)setupThirdPartyShare {
    // 需要确保和KwaiGameSDKConfig中填写一致
    [[[KwaiGameSDK sharedSDK] sharer] registerWithConfigurations:@{
        kOpenPlatformTypeWechat:@{
                kOpenPlatformAppId:@"wxb1a72eb205e0d7f9",
                kOpenPlatformUniversalLink:@"https://doc.game.kuaishou.com/",
        },
        kOpenPlatformTypeQQ:@{
                kOpenPlatformAppId:@"101896886",
                kOpenPlatformUniversalLink:@"https://doc.game.kuaishou.com/",
        },
        kOpenPlatformTypeWeibo:@{
                kOpenPlatformAppId:@"3509845209"
        }
    }];
}

#pragma mark - KwaiGameSDKGameLifeDelegate

#pragma mark - UIViewController Style

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDarkContent;
}

@end
