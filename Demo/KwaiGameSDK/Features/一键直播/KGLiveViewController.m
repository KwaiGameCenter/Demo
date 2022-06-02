//
//  KGLiveViewController.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/12/12.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "KGLiveViewController.h"
#import <KwaiGameSDK-Live/KwaiGameLiveToken.h>
#import <KwaiGameSDK-Live/KwaiGameLive.h>
#import <KwaiGameSDK-Live/LiveMartPlugin.h>
#import <KwaiGameSDK-Live/KGLAryaPlugin.h>
#import <KwaiGameSDK-Live/KGLiveView.h>
#import <KwaiGameSDK/KwaiGameSDK.h>
#import "UIView+Toast.h"
#import "NSError+KwaiBase.h"
#import "SDWebImageManager.h"
#import "KwaiBase.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"

@interface KGLiveViewController () <KwaiGameLiveDelegate, KwaiGameLiveStateDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIView *dispalyView;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, weak) IBOutlet UIButton *switchEnvButton;
@property (nonatomic, weak) IBOutlet UITextView *messageTextView;
@property (nonatomic, weak) IBOutlet UISwitch *buildInButton;
@property (nonatomic, weak) IBOutlet UISwitch *orientationButton;
@property (nonatomic, weak) IBOutlet UISwitch *showGameButton;
@property (nonatomic, weak) IBOutlet UIImageView *liveAvatarImageView;
@property (nonatomic, weak) IBOutlet UILabel *liveIDView;
@property (nonatomic, strong) KwaiGameAccount *account;

@end

@implementation KGLiveViewController

- (void)viewDidLoad {
    [CSToastManager setDefaultPosition: CSToastPositionCenter];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    [NSTimer scheduledTimerWithTimeInterval: 1.0f target: self selector: @selector(updateUI:) userInfo: nil repeats: YES];
    //日志
    [KwaiGameLive setup: ^(KwaiGameLiveConfig *config) {
        config.gameName = @"TestForIOS";
        config.gameVersion = @"0.0.1";
        config.gameId = 0;
        config.pluginClass = @[LiveMartPlugin.class, KGLAryaPlugin.class];
        config.enableConsoleLog = YES;
        config.enableFileLog = YES;
    }];

    
    [self customUI];
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit: YES];
    
    [self syncSwitchEnvButtonState];
    
    self.orientationButton.on = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
    self.orientationButton.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)updateUI: (NSTimer *)timer {
    [self updateText: @""];
}

- (void)updateText: (NSString *)message {
    static int count = 0;
    static NSString *sMessage = @"";
    if (![KwaiGameLive defaultLive].liveState) {
        sMessage = @"";
        if ([self.messageTextView.text isEqualToString: @""]) {
            self.messageTextView.text = [NSString stringWithFormat: @"Off Radio: |%d|", count++];
        } else {
            self.messageTextView.text = @"";
        }
    } else {
        if (![message isEqualToString: @""] && message != nil) {
            sMessage = message;
        }
        self.messageTextView.text = [NSString stringWithFormat: @"On Radio: |%d| Mic: %d\nname: %@|%@|\nwatcher: %lld like: %lld\n%@", count++, [KwaiGameLive defaultLive].enableMic, [KwaiGameLive defaultLiveState].name, [KwaiGameLive defaultLiveState].gender, [KwaiGameLive defaultLiveState].watchingCount, [KwaiGameLive defaultLiveState].likeCount, sMessage];
    }
}

- (void)customUI {
}

- (void)dealloc {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//开始直播
- (IBAction)didStartLive: (id)sender {
    KWAI_LOG_INFO(@"didStartLive: %d", ((UIButton *) sender).selected);
    if ([KwaiGameSDK sharedSDK].account == nil) {
        return;
    }
    [KwaiGameLive setup: ^(KwaiGameLiveConfig *config) {
        config.stagingEnv = [KwaiGameSDK sharedSDK].currentEnv == KwaiGameEnv_Staging;
    }];
    UIButton *button = (UIButton *)sender;
    if (!button.selected) {
        if (!self.buildInButton.isOn) {
            [[KwaiGameLive defaultLive] startLive: ^(KwaiGameLiveParams *params) {
                params.quality = KwaiGameLiveQuality_High;
                params.landscape = self.orientationButton.isOn;
                params.recordScreenFps = 24;
            } delegate: self];
            [KwaiGameLive defaultLive].enableMic = YES;
        } else {
            KGLiveView *liveView = [[KGLiveView alloc] initWithRootView: self.view rootController: self isLandscape: self.orientationButton.isOn];
            liveView.showGiftPanel = self.showGameButton.isOn;
            [[KwaiGameLive defaultLive] startLiveWithUI: liveView delegate: self];
        }
    } else {
        if (self.buildInButton.isOn) {
            [[KwaiGameLive defaultLive] showLivePanel];
        } else {
            [[KwaiGameLive defaultLive] stopLive];
        }
    }
}

//运行环境
- (IBAction)didSwitchEnv: (id)sender {
    [[KwaiGameSDK sharedSDK] logoutWithCompletion: ^(NSError *error) {
        if ([KwaiGameSDK sharedSDK].currentEnv == KwaiGameEnv_Release) {
            [[KwaiGameSDK sharedSDK] switchGameEnv: KwaiGameEnv_Staging completion: nil];
        } else {
            [[KwaiGameSDK sharedSDK] switchGameEnv: KwaiGameEnv_Release completion: nil];
        }
        [self syncSwitchEnvButtonState];
    }];
}

- (void)syncSwitchEnvButtonState {
    RUN_IN_MAIN_THREAD_START
    if ([KwaiGameSDK sharedSDK].currentEnv == KwaiGameEnv_Release) {
        [self.switchEnvButton setTitle: @"线上环境" forState: UIControlStateNormal];
        [self.switchEnvButton setTitleColor: [UIColor greenColor] forState: UIControlStateNormal];
    } else {
        [self.switchEnvButton setTitle: @"测试环境" forState: UIControlStateNormal];
        [self.switchEnvButton setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
    }
    RUN_IN_MAIN_THREAD_END
}

//是否横屏游戏
- (IBAction)didChangeOrientation: (id)sender {
    UISwitch *switchBtn = (UISwitch *)sender;
    if (switchBtn.isOn) {
        NSNumber *value = [NSNumber numberWithInt: UIDeviceOrientationLandscapeLeft];
        [[UIDevice currentDevice]setValue: value forKey: @"orientation"];
    } else {
        NSNumber *value = [NSNumber numberWithInt: UIDeviceOrientationPortrait];
        [[UIDevice currentDevice]setValue: value forKey: @"orientation"];
    }
}

#pragma mark - KwaiGameLiveDelegate
- (void)didKwaiGameLive: (id<KwaiGameLiveProtocol>)gameLive updateToken: (void(^)(NSError *error, KwaiGameLiveUserInfo *token))updateToken {
    [KwaiGameLiveToken requestKuaishouLiveAbility: ^(NSError *error, KwaiLiveTokenInfo *liveToken) {
        KwaiGameLiveUserInfo *token = nil;
        if (!error) {
            token = [[KwaiGameLiveUserInfo alloc] init];
            token.liveSecurity = liveToken.security;
            token.liveUserId = liveToken.userId;
            token.liveToken = liveToken.token;
            token.userName = liveToken.userName;
            token.userAvatar = liveToken.userAvatar;
            token.userGender = liveToken.userGender;
            token.liveCertificate = liveToken.liveCertificate;
            token.certificateUrl = liveToken.certificateUrl;
            token.certificateSid = liveToken.certificateSid;
            token.certificateToken = liveToken.certificateToken;
            token.certificateKpn = liveToken.certificateKpn;
            
            RUN_IN_MAIN_THREAD_START
            if (token.liveUserId.length > 0) {
                self.liveIDView.text = token.liveUserId;
            }
            RUN_IN_MAIN_THREAD_END
        }
        updateToken(error, token);
    }];
}

- (void)didSwitchAccount: (id<KwaiGameLiveProtocol>)gameLive updateToken: (void(^)(NSError *error, KwaiGameLiveUserInfo *token))updateToken {
    [KwaiGameLiveToken rebindKuaishouLiveAbility: ^(NSError *error, KwaiLiveTokenInfo *liveUserInfo) {
        KwaiGameLiveUserInfo *token = nil;
        if (!error) {
            token = [[KwaiGameLiveUserInfo alloc] init];
            token.liveSecurity = liveUserInfo.security;
            token.liveUserId = liveUserInfo.userId;
            token.liveToken = liveUserInfo.token;
            token.userName = liveUserInfo.userName;
            token.userAvatar = liveUserInfo.userAvatar;
            token.userGender = liveUserInfo.userGender;
            token.liveCertificate = liveUserInfo.liveCertificate;
            token.certificateUrl = liveUserInfo.certificateUrl;
            token.certificateSid = liveUserInfo.certificateSid;
            token.certificateToken = liveUserInfo.certificateToken;
            token.certificateKpn = liveUserInfo.certificateKpn;
            
            RUN_IN_MAIN_THREAD_START
            if (token.liveUserId.length > 0) {
                self.liveIDView.text = token.liveUserId;
            }
            RUN_IN_MAIN_THREAD_END
        }
        updateToken(error, token);
    }];
}

- (UIView *)needRecordView {
    return self.dispalyView;
}

- (void)didKwaiGameLiveStarted: (id<KwaiGameLiveProtocol>)gameLive {
    [KwaiGameLive defaultLive].liveState.messageDelegate = self;
    if (gameLive.liveState.avatar != nil) {
        [self.liveAvatarImageView sd_setImageWithURL: [NSURL URLWithString: gameLive.liveState.avatar]];
    }
    // 这里设置屏幕常亮
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    if (!self.startButton.selected) {
        self.startButton.selected = YES;
        [self.startButton setTitle: @"结束直播" forState: UIControlStateNormal];
    }
    self.orientationButton.enabled = NO;
    self.switchEnvButton.enabled = NO;
    self.buildInButton.enabled = NO;
    self.showGameButton.enabled = NO;
}

- (void)didKwaiGameLiveStopped: (id<KwaiGameLiveProtocol>)gameLive {
    self.liveAvatarImageView.image = nil;
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    self.orientationButton.enabled = YES;
    self.switchEnvButton.enabled = YES;
    self.buildInButton.enabled = YES;
    self.showGameButton.enabled = YES;
    if (self.startButton.selected) {
        self.startButton.selected = NO;
        [self.startButton setTitle: @"开始直播" forState: UIControlStateNormal];
    }
}

- (void)didKwaiGameLive: (id<KwaiGameLiveProtocol>)gameLive onError: (NSError *)error {
    KWAI_LOG_INFO(@"didKwaiGameLive Failed: %@", error);
    if (self.buildInButton.isOn) {
        return;
    }
    [[KwaiGameLive defaultLive] stopLive];
    self.startButton.selected = NO;
    [self.startButton setTitle: @"开始直播" forState: UIControlStateNormal];
    if (error.code == kKwaiGameLiveErrorCode_NotOpenKwaiLiveFeature) {
        [self.view makeToast: @"您还没有直播权限, 请在<快手App>中选择->实验室->开启直播功能"];
    } else {
        if (error.code == kKwaiGameLiveErrorCode_KwaiLivePermissionGetFailed) {
            [self.view makeToast: @"直播失败，请先使用快手授权"];
        } else {
#if DEBUG == 1
            [self.view makeToast: [NSString stringWithFormat: @"直播失败: %@", error.errorMsg]];
#else
            [self.view makeToast: @"直播失败"];
#endif
        }
    }
}

- (void)didKwaiGameLive: (id<KwaiGameLiveProtocol>)gameLive onNeedAuthority: (NSError *)error {
    KWAI_LOG_INFO(@"didKwaiGameLive Failed By Authority: %@", error);
    if (self.buildInButton.isOn) {
        return;
    }
    if (error.code == kKwaiGameLiveErrorCode_LiveMartNeedMicrophoneAuthority) {
        [self.view makeToast: @"您需要开启录音权限"];
    }
}

- (void)didKwaiGameLive: (id<KwaiGameLiveProtocol>)gameLive reportKey: (NSString *)reportKey reportBody: (NSDictionary *)reportBody {
    [[KwaiGameSDK sharedSDK] reportAction:reportKey param:reportBody];
}

#pragma mark - KwaiGameLiveStateDelegate

- (void)didStateChanged:(id<KwaiGameLiveStateProtocol>)state {
}


- (void)didNeedRefreshMessages: (NSArray<KGLiveSampleMessage *> *)allMessages {
    if (self.buildInButton.isOn) {
        //内置界面
        return;
    }
    NSArray<KGLiveSampleMessage *> *messages = allMessages;
    NSString *textViewDetail = @"";
    for (KGLiveSampleMessage *liveMessage in messages) {
        NSString *tmpStr = [NSString stringWithFormat: @"%@: %@", liveMessage.userName, liveMessage.content];
        textViewDetail = [textViewDetail stringByAppendingString: tmpStr];
        textViewDetail = [textViewDetail stringByAppendingString: @"\n"];
    }
    [self updateText: textViewDetail];
}

- (void)didReceiveGift: (KGLiveGiftMessage *)newReceiveGift {
    if (self.buildInButton.isOn) {
        return;
    }
    if (newReceiveGift.giftUrl != nil) {
        [[SDWebImageManager sharedManager] loadImageWithURL: [NSURL URLWithString: newReceiveGift.giftUrl] options: SDWebImageHighPriority progress: nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (image != nil) {
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.backgroundColor = UIColor.clearColor;
                NSString *title = [NSString stringWithFormat: @"%@ 送 %@", newReceiveGift.userName, newReceiveGift.giftName];
                if (newReceiveGift.giftCount > 1) {
                    title = [NSString stringWithFormat: @"%@ 送 %@[%lu]", newReceiveGift.userName, newReceiveGift.giftName, (unsigned long)newReceiveGift.giftCount];
                }
                [self.view makeToast: nil
                            duration: 2.0
                            position: CSToastPositionCenter
                               title: title
                               image: image
                               style: style
                          completion: nil];
            } else {
                if (newReceiveGift.giftCount > 1) {
                    [self.view makeToast: [NSString stringWithFormat: @"%@ 送 %@[%lu]", newReceiveGift.userName, newReceiveGift.giftName, (unsigned long)newReceiveGift.giftCount]];
                } else {
                    [self.view makeToast: [NSString stringWithFormat: @"%@ 送 %@", newReceiveGift.userName, newReceiveGift.giftName]];
                }
            }
        }];
    } else {
        if (newReceiveGift.giftCount > 1) {
            [self.view makeToast: [NSString stringWithFormat: @"%@ 送 %@[%lu]", newReceiveGift.userName, newReceiveGift.giftName, (unsigned long)newReceiveGift.giftCount]];
        } else {
            [self.view makeToast: [NSString stringWithFormat: @"%@ 送 %@", newReceiveGift.userName, newReceiveGift.giftName]];
        }
    }
}

#pragma mark -

- (void)motionBegan: (UIEventSubtype)motion withEvent: (UIEvent *)event {
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([KGUtil checkLandscape]) {
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
