//
//  KGWatchLiveViewController.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2019/4/19.
//  Copyright © 2019 mookhf. All rights reserved.
//

#import "KGWatchLiveViewController.h"
#import "KGTokenHelper.h"
#import <KwaiGameSDK-WWP/KGWWPView.h>
#import "UIViewController+DemoSupport.h"
#import <KwaiGameSDK-WWP/KwaiGameWWP.h>
#import <KwaiGameSDK-WWP/KwaiGameWWPToken.h>
#import <KwaiGameSDK-WWP/KwaiGameWWPObject.h>
#import <KwaiGameSDK/KwaiGameSDK.h>
#import <KwaiGameSDK-WWP/KGWIJKStreamerPlugin.h>
#import <KwaiGameSDK-WWP/KwaiGameWWPHTTPClient.h>
#import <KwaiGameSDK/KwaiGameSDK.h>

@interface KGWatchLiveViewController ()<KwaiGameWWPDelegate ,UITextFieldDelegate>
@property (nonatomic, strong) NSArray<KwaiGameLiveListItem *> *list;
@property (nonatomic, strong) KGWWPView *wwpView;
@property (nonatomic, strong) NSString *accessToken;

@property (nonatomic, strong) NSDictionary<NSNumber *, KwaiGameWWPGift *> *displayGifts;
@property (nonatomic, strong) NSArray<KwaiGameWWPGift *> *panelGifts;
@property (nonatomic, strong) KwaiGameLiveListItem *selectedItem;
@property (nonatomic, strong) UITextField *anchorTx;
@property (nonatomic, strong) UITextField *liveStreamIdTx;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UISwitch *sendGiftSwitch;

@property (nonatomic, assign) NSUInteger coins;
@end

@implementation KGWatchLiveViewController
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.anchorTx = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    self.anchorTx.center = CGPointMake(self.view.center.x, 100);
    self.anchorTx.backgroundColor = [UIColor grayColor];
    self.anchorTx.placeholder = @"主播Id 必填";
    self.anchorTx.returnKeyType = UIReturnKeyDone;
    self.anchorTx.delegate = self;
    [self addSubView:self.anchorTx frame:CGRectMake(0, 0, 200, 40)];
    
    self.liveStreamIdTx = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    self.liveStreamIdTx.center = CGPointMake(self.view.center.x, 160);
    self.liveStreamIdTx.backgroundColor = [UIColor grayColor];
    self.liveStreamIdTx.placeholder = @"streamId (可指定)";
    self.liveStreamIdTx.returnKeyType = UIReturnKeyDone;
    self.liveStreamIdTx.delegate = self;
    [self addSubView:self.liveStreamIdTx frame:CGRectMake(0, 0, 200, 40)];
    
    UILabel *sendGiftLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.liveStreamIdTx.frame.origin.x, 200, 120, 40)];
    sendGiftLabel.text = @"是否开启送礼";
    sendGiftLabel.textColor = [UIColor blackColor];
    [self addSubView:sendGiftLabel frame:CGRectMake(self.liveStreamIdTx.frame.origin.x, 200, 120, 40)];
    
    self.sendGiftSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(sendGiftLabel.frame.origin.x + sendGiftLabel.frame.size.width + 20, 200, 80, 40)];
    self.sendGiftSwitch.on = NO;
    [self addSubView:self.sendGiftSwitch frame:CGRectMake(sendGiftLabel.frame.origin.x + sendGiftLabel.frame.size.width + 20, 200, 80, 40)];
    
    self.submitButton = [self addSubButton:@"进入房间" frame:CGRectMake(0, 260, 200, 40) selector:@selector(submitRoom)];
    [self addSubView:self.submitButton frame:CGRectMake(0, 260, 200, 40)];
    
    [KwaiGameWWP setup:^(KwaiGameWWPConfig *config) {
        config.app_id = [KwaiGameSDK sharedSDK].appId;
        config.game_id = [KwaiGameSDK sharedSDK].account.uid;
        config.game_token = [KwaiGameSDK sharedSDK].account.serviceToken;
        
        config.enableFileLog = YES;
        config.enableConsoleLog = YES;
        
        config.stagingEnv = [KwaiGameSDK sharedSDK].currentEnv == KwaiGameEnv_Staging;
        config.pluginClass = @[[KGWIJKStreamerPlugin class], [KwaiGameWWPHTTPClient class]];
    }];
}

- (void)submitRoom {
    KwaiGameWWPParam *prams = [KwaiGameWWPParam new];
    prams.liveStreamId = self.liveStreamIdTx.text.length > 0 ? self.liveStreamIdTx.text : @"luna";
    prams.anchorId = self.anchorTx.text;
    prams.playUrl = @"";
    if (self.anchorTx.text.length == 0) {
        [self toast:@"参数错误"];
        return;
    }
    [self.anchorTx resignFirstResponder];
    [self.liveStreamIdTx resignFirstResponder];
    [[KwaiGameWWP defaultWWP] exitRoom];
    if (self.wwpView.superview) {
        [self.wwpView removeFromSuperview];
    }
    
    self.wwpView = [[KGWWPView alloc] initWithRootView:self.view];
    [self.wwpView hideSendGiftPanel:!self.sendGiftSwitch.isOn];
    [self hiddenNavigationBar];
    [[KwaiGameWWP defaultWWP] enterRoom:prams uiProxy:self.wwpView delegate:self];
}

- (void)hiddenNavigationBar {
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
}


#pragma mark - KwaiGameWWPDelegate

- (void)onEnterRoomStart:(NSString *)anchorId {
    NSLog(@"--- enter start");
}

// 这些回调都不一定在主线程，游戏处理时请务必注意
- (void)onEnterRoomFinish:(NSString *)anchorId error:(NSError *)error {
    NSLog(@"--- enter finish %@", error);
    if (error == nil) {
        if ([[KwaiGameWWP defaultWWP] networkStatus] != 5) {
            [self.wwpView showToast:@"温馨提示：当前为非WiFi环境，请注意流量使用"];
        }
        self.coins = 100000;
        [self.wwpView updateLeftCoinCount:self.coins];
    } else {
        [self toast:error.localizedDescription];
    }
}

- (void)onExitRoomFinish:(NSString *)anchorId error:(NSError *)error {
    NSLog(@"--- exit finish %@", error);
    if (error == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.wwpView removeFromSuperview];
            self.wwpView = nil;
            self.navigationController.navigationBar.hidden = NO;
            self.navigationController.navigationBar.userInteractionEnabled = YES;
        });
    }
}

- (void)onTokenNeedUpdate:(void (^)(KwaiGameWWPUserInfo *))completionHandler {
    void (^callback)(KwaiWWPTokenInfo *) = ^(KwaiWWPTokenInfo *wwpTokenInfo){
        KwaiGameWWPUserInfo *userinfo = [KwaiGameWWPUserInfo new];
        userinfo.token = wwpTokenInfo.token;
        userinfo.userId = wwpTokenInfo.userId;
        userinfo.userName = wwpTokenInfo.userName;
        userinfo.userAvatar = wwpTokenInfo.userAvatar;
        completionHandler(userinfo);
    };
    [KwaiGameWWPToken requestKuaishouWWPAbility:^(NSError *error, KwaiWWPTokenInfo *wwpTokenInfo) {
        if (error) {
            [KwaiGameWWPToken rebindKuaishouWWPAbility:^(NSError *error, KwaiWWPTokenInfo *wwpTokenInfo) {
                if (error) {
                    [self toast:error.localizedDescription];
                } else {
                    callback(wwpTokenInfo);
                }
            }];
        } else {
            callback(wwpTokenInfo);
        }
    }];
}

- (void)onHandleError:(NSError *)error {
    if (error.code == KwaiGameWWPErrorCodeNetworkError) {
        [self.wwpView showToast:@"网络异常，请稍后再试"];
    } else if (error.code == KwaiGameWWPErrorCodePullStreamFail) {
        [self.wwpView showToast:@"直播貌似出了点问题，请稍后再试"];
    } else if (error.code == KwaiGameWWPErrorCodeAnchorBusy) {
        [self.wwpView showToast:@"主播可能正在通话中，稍后回来"];
    } else if (error.code == KwaiGameWWPErrorCodeCoinNotEnough) {
        [self.wwpView showToast:@"余额不足，请及时充值"];
//        [self.wwpView updateLeftCoinCount:100000];
    }
}

- (void)onSendGift:(KwaiGameWWPGiftMessage *)gift {
    // 这里是模拟接口，送礼应该由游戏实现
    NSUInteger gid = gift.gid;
    NSString *uid = [KwaiGameSDK sharedSDK].account.uid;
    NSString *anchorid = self.anchorTx.text;
    NSString *liveStreamId = self.liveStreamIdTx.text;
    if (self.accessToken) {
        [KGTokenHelper sendGiftWithId:gid senderId:uid anchorId:anchorid liveStreamId:liveStreamId accessToken:self.accessToken batchSize:1 comboKey:@""];
        self.coins -= gift.unitPrice;
        [self.wwpView updateLeftCoinCount:self.coins];
    } else {
        [KGTokenHelper requestWWPAccessToken:^(NSError *error, NSString *accessToken) {
            if (accessToken) {
                self.accessToken = accessToken;
                [KGTokenHelper sendGiftWithId:gid senderId:uid anchorId:anchorid liveStreamId:liveStreamId accessToken:accessToken batchSize:1 comboKey:@""];
                self.coins -= gift.unitPrice;
                [self.wwpView updateLeftCoinCount:self.coins];
            }
        }];
    }
}

- (void)onClickShareButton{
    [self toast:@"游戏实现分享功能"];
}

- (void)onReportKey:(NSString *)key params:(NSDictionary *)params {
    [[KwaiGameSDK sharedSDK] reportAction:key param:params];
}

#pragma mark -
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    NSLog(@"--- dealloc %@", NSStringFromClass(self.class));
}

@end
