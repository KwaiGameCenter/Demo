//
//  OverseaViewController.m
//  KwaiGameADExample
//
//  Created by 刘玮 on 2021/7/28.
//  Copyright © 2021 邓波. All rights reserved.
//

#import "OverseaViewController.h"
#ifdef FOR_ALLIN

#import <KwaiGameSDK-AD/KwaiGameSDK+AD.h>
#import <KwaiGameSDK-AD/KwaiGameADManager.h>

#define ADSDKSetup(buildConfig, loader)     [KwaiGameSDK setupAD:buildConfig adLoader:loader]
#define ADSDKManager                KwaiGameADManager
#define ADSDKUtils                  KGUtil
#define ADTestEnv(config)           ;
#define ADOverseaMode(config)       ;

#else

#import <GAd/GAd.h>

#define ADSDKSetup(buildConfig, loader)      [GAd setup:kAppId builder:buildConfig adLoader:loader delegate:nil]
#define ADSDKManager                 GAd
#define ADSDKUtils                   DemoUtils
#define ADTestEnv(config)            config.debugMode = ADSDKUtils.testEnv
#define ADOverseaMode(config)        config.overseaMode = YES

#endif

@interface OverseaViewController ()<KwaiGameADManagerDelegate>

@property (nonatomic, strong) UISegmentedControl *adTypeControl;
@property (nonatomic, strong) UISegmentedControl *adNameControl;

@property (nonatomic, strong) UISegmentedControl *adPositionControl;
@property (nonatomic, assign) KwaiGameADShowPosition adPosition;

@end

@implementation OverseaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([KGUtil checkQAEnv]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"检查"
                                                                                style:UIBarButtonItemStylePlain
                                                                               target:self
                                                                               action:@selector(showDebugView)];
    }
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"横幅",@"插屏",@"视频",@"激励",@"Draw",@"开屏",@"信息流",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(20.0, 70.0, 350.0, 30.0);
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(didAdTypeChanged:) forControlEvents:UIControlEventValueChanged];
    self.adTypeControl = segmentedControl;
    [self addSubView:self.adTypeControl frame:CGRectMake(20.0, 70.0, 350.0, 30.0)];
    
    NSArray *segmentedArray1 = [[NSArray alloc]initWithObjects:@"AdMob(Oversea)",nil];
    UISegmentedControl *segmentedControl1 = [[UISegmentedControl alloc] initWithItems:segmentedArray1];
    segmentedControl1.frame = CGRectMake(20.0, 140.0, 350.0, 50.0);
    segmentedControl1.selectedSegmentIndex = 0;
    [self didAdTypeChanged:segmentedControl1];
    self.adNameControl = segmentedControl1;
    [self.adNameControl addTarget:self action:@selector(didAdNameChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.adPositionControl = [self addSubSegmentedControl:@[@"底部",@"中间",@"头部"] frame:CGRectMake(0, 0, 350, 30) selector:@selector(changeADPosition:)];
    
    [self addSubView:self.adNameControl frame:CGRectMake(20.0, 70.0, 350.0, 30.0)];
    [self addSubButton:@"显示广告" frame:CGRectMake(0, 250, 200, 30) selector:@selector(showAd)];
    [self addSpliteLine:@"横幅(信息流)广告" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];
    [self addSubButton:@"显示" frame:CGRectMake(0, 305, 200, 30) selector:@selector(showBannerOrFeed)];
    [self addSubButton:@"隐藏" frame:CGRectMake(0, 305, 200, 30) selector:@selector(hiddenBannerOrFeed)];
    [self addSubButton:@"移除" frame:CGRectMake(0, 360, 200, 30) selector:@selector(removeBannerOrFeed)];
    [self configAD];
}

- (void)configAD {
    DemoRunInMainThreadStart
    ADSDKSetup(
        (^(KwaiGameADManagerConfig *config) {
            ADOverseaMode(config);
            ADTestEnv(config);
            [config registerADPosition:@"0" withType:KwaiGameADType_Banner];
            [config registerADPosition:@"1" withType:KwaiGameADType_Insert];
            [config registerADPosition:@"2" withType:KwaiGameADType_Video];
            [config registerADPosition:@"3" withType:KwaiGameADType_Reward];
            [config registerADPosition:@"4" withType:KwaiGameADType_Draw];
            [config registerADPosition:@"5" withType:KwaiGameADType_Splash];
            [config registerADPosition:@"6" withType:KwaiGameADType_Feed];
            if ([ADSDKUtils checkLandscape]) {
                [config registerBannerSize:CGSizeMake(300.0f, 150.0f)];
            } else {
                [config registerBannerSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 0.5f)];
            }
        }),
        (^(KwaiGameDefaultADStrategies *defaultADStrategies) {
            if (self.adNameControl.selectedSegmentIndex == 0) {
                // Admob(OK, banner need white name list)
                [defaultADStrategies registerAdChannel:kKwaiGameADProxyOverSeaSDK appId:@"ca-app-pub-5005023907208839~7690738200;bu-5204444" configurations:@{
                        @(KwaiGameADType_Banner):@"ca-app-pub-5005023907208839/3110147758",
                        @(KwaiGameADType_Insert):@"ca-app-pub-5005023907208839/9456064258",
                        @(KwaiGameADType_Reward):@"ca-app-pub-5005023907208839/7951410891",
                }];
            }
        })
    );
    DemoRunInMainThreadEnd
}

- (void)showAd {
    [ADSDKManager showAD:self.positionName sceneName:@"Test" delegate:self];
}

- (void)showBannerOrFeed {
    if (self.adTypeControl.selectedSegmentIndex == 0) {
        [ADSDKManager hiddenBanner:self.positionName isHidden:NO];
    }
    if (self.adTypeControl.selectedSegmentIndex == 6) {
        [ADSDKManager hiddenFeed:self.positionName isHidden:NO];
    }
}

- (void)hiddenBannerOrFeed {
    if (self.adTypeControl.selectedSegmentIndex == 0) {
        [ADSDKManager hiddenBanner:self.positionName isHidden:YES];
    }
    if (self.adTypeControl.selectedSegmentIndex == 6) {
        [ADSDKManager hiddenFeed:self.positionName isHidden:YES];
    }}

- (void)removeBannerOrFeed {
    if (self.adTypeControl.selectedSegmentIndex == 0) {
        [ADSDKManager dismissBanner:self.positionName];
    }
    if (self.adTypeControl.selectedSegmentIndex == 6) {
        [ADSDKManager dismissFeed:self.positionName];
    }
}

- (void)showDebugView {
    Class cls = NSClassFromString(@"MobAdSDKProxy");
    if (cls != nil) {
        SEL sel = @selector(presentDebugViewController);
        if ([cls respondsToSelector:sel]) {
            [cls performSelector:sel];
        }
    }
}

#pragma mark - KwaiGameADManagerDelegate

- (UIViewController *)rootController {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

- (KwaiGameADShowPosition)bannerPosition {
    return self.adPosition;
}

- (KwaiGameADShowPosition)feedPosition {
    return self.adPosition;
}

- (void)adHasShowed:(NSString *)positionName {
    [[UIApplication sharedApplication].keyWindow toast:@"广告展示"];
}

- (void)adHasReward:(NSString *)positionName {
    [[UIApplication sharedApplication].keyWindow toast:@"广告奖励"];
    [ADSDKManager adRewardComplete:[NSString stringWithFormat:@"%ld", (long)self.adTypeControl.selectedSegmentIndex]
                sceneName:@"Test"
                    error:nil];
}

- (void)adHasClosed:(NSString *)positionName {
    DemoRunInMainThreadAfterBegin(3.0f)
    [[UIApplication sharedApplication].keyWindow toast:@"广告关闭"];
    DemoRunInMainThreadAfterEnd
}

- (void)adHasClick:(NSString *)positionName {
    [[UIApplication sharedApplication].keyWindow toast:@"广告点击"];
}

- (void)adHasFailed:(NSString *)positionName error:(NSError *)error {
    [self toast:@"加载广告失败:%@", error];
}

- (void)paidEventHandler:(NSDictionary*) paidEventData {
    [self toast:@"广告价值数据:%@",paidEventData];
    [[KwaiGameSDK sharedSDK] reportAction:@"ad_impression" param:paidEventData];
}

#pragma mark - sender

- (NSString *)positionName {
    return [NSString stringWithFormat:@"%d",(int)self.adTypeControl.selectedSegmentIndex];
}

- (void)didAdNameChanged:(id)sender {
    [self configAD];
}

- (void)changeADPosition:(id)sender {
    if (self.adPositionControl.selectedSegmentIndex == 0) {
        self.adPosition = KwaiGameADShowPosition_bottom;
    } else if (self.adPositionControl.selectedSegmentIndex == 1) {
        self.adPosition = KwaiGameADShowPosition_center;
    } else {
        self.adPosition = KwaiGameADShowPosition_top;
    }
}

- (void)didAdTypeChanged:(id)sender {
    [ADSDKManager adButtonShow:[NSString stringWithFormat:@"%ld", (long)self.adTypeControl.selectedSegmentIndex] sceneName:@"Test"];
}

@end
