//
//  AutoViewController.m
//  KwaiGameADExample
//
//  Created by 刘玮 on 2020/5/13.
//  Copyright © 2020 邓波. All rights reserved.
//

#import "AutoViewController.h"
#import "XFPreferenceHeader.h"
#ifdef FOR_ALLIN

#import <KwaiGameSDK-AD/KwaiGameSDK+AD.h>
#import <KwaiGameSDK-AD/KwaiGameADManager.h>

#define ADSDKSetup(buildConfig)     [KwaiGameSDK setupAD:buildConfig]
#define ADSDKManager                KwaiGameADManager
#define ADSDKUtils                  KGUtil
#define ADTestEnv(config)           ;

#else

#import <GAd/GAd.h>

#define ADSDKSetup(buildConfig)      [GAd setup:kAppId builder:buildConfig delegate:self]
#define ADSDKManager                 GAd
#define ADSDKUtils                   DemoUtils
#define ADTestEnv(config)            config.debugMode = ADSDKUtils.testEnv

#endif

#define kLastCustomAction  @"kLastCustomAction"
#define kLastCustomType    @"kLastCustomType"

@interface AutoViewController ()<KwaiGameADManagerDataDelegate,KwaiGameADManagerDelegate>

@property (nonatomic, strong) UISegmentedControl *adTypeControl;
@property (nonatomic, strong) UISegmentedControl *adPositionControl;
@property (nonatomic, assign) KwaiGameADShowPosition adPosition;
@property (nonatomic, strong) UIButton *adShowButton;

@property (nonatomic, copy) NSString *customADName;

@end

@implementation AutoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"激励",@"视频",@"插屏",@"横幅",@"开屏",@"信息流",@"Draw",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(20.0, 70.0, 350.0, 30.0);
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(didAdTypeChanged:) forControlEvents:UIControlEventValueChanged];
    self.adTypeControl = segmentedControl;
    [self addSubView:self.adTypeControl frame:CGRectMake(20.0, 70.0, 350.0, 30.0)];
    self.adPositionControl = [self addSubSegmentedControl:@[@"底部",@"中间",@"头部"] frame:CGRectMake(0, 0, 350, 30) selector:@selector(changeADPosition:)];
    [self addSubButton:@"自定义" frame:CGRectMake(20, 80, 200, 30) selector:@selector(registerAD)];
    self.adShowButton = [self addSubButton:@"显示广告" frame:CGRectMake(0, 250, 200, 30) selector:@selector(showAd)];
    [self addSpliteLine:@"横幅(信息流)广告" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];
    [self addSubButton:@"显示" frame:CGRectMake(0, 305, 200, 30) selector:@selector(showBannerOrFeed)];
    [self addSubButton:@"隐藏" frame:CGRectMake(0, 305, 200, 30) selector:@selector(hiddenBannerOrFeed)];
    [self addSubButton:@"移除" frame:CGRectMake(0, 360, 200, 30) selector:@selector(removeBannerOrFeed)];
    [self configADFromDefault];
}

- (void)registerAD {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"自定义" message:nil preferredStyle:
    UIAlertControllerStyleAlert];
        [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入聚合广告位名称";
        }];
        UIAlertAction *actionDone = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            UITextField *titleTextField = alertVc.textFields.firstObject;
            [XFPreferenceUtil setGlobalKey:kLastCustomAction value:titleTextField.text syncWrite:YES];
            KwaiGameADType adType = KwaiGameADType_Unknown;
            if (self.adTypeControl.selectedSegmentIndex == 0) {
                adType = KwaiGameADType_Reward;
            } else if (self.adTypeControl.selectedSegmentIndex == 1) {
                adType = KwaiGameADType_Video;
            } else if (self.adTypeControl.selectedSegmentIndex == 2) {
                adType = KwaiGameADType_Insert;
            } else if (self.adTypeControl.selectedSegmentIndex == 3) {
                adType = KwaiGameADType_Banner;
            } else if (self.adTypeControl.selectedSegmentIndex == 4) {
                adType = KwaiGameADType_Splash;
            } else if (self.adTypeControl.selectedSegmentIndex == 5) {
                adType = KwaiGameADType_Feed;
            } else if (self.adTypeControl.selectedSegmentIndex == 6) {
                adType = KwaiGameADType_Draw;
            }
            [XFPreferenceUtil setGlobalIntegerKey:kLastCustomType value:adType syncWrite:YES];
            [self configADFromDefault];
        }];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVc addAction:actionDone];
        [alertVc addAction:actionCancel];
        [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)configADFromDefault {
    DemoRunInMainThreadStart
    NSString *adName = [XFPreferenceUtil getGlobalKey:kLastCustomAction];
    KwaiGameADType adType = (KwaiGameADType)[XFPreferenceUtil getGlobalIntegerKey:kLastCustomType];
    if (adName.length > 0) {
        ADSDKSetup(^(KwaiGameADManagerConfig *config) {
            // 设置本地默认视频
            config.localADPath = [[NSBundle mainBundle] pathForResource:@"default1" ofType:@"bundle"];
            ADTestEnv(config);
            [config registerADPosition:adName withType:adType];//注册融合广告位
            if ([ADSDKUtils checkLandscape]) {
                [config registerBannerSize:CGSizeMake(300.0f, 150.0f)];
            } else {
                [config registerBannerSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 0.5f)];
            }
        });
        self.customADName = adName;
        NSString *buttonName = adName;
        if (adType == KwaiGameADType_Reward) {
            buttonName = [NSString stringWithFormat:@"%@[激励]", adName];
            self.adTypeControl.selectedSegmentIndex = 0;
        } else if (adType == KwaiGameADType_Video) {
            buttonName = [NSString stringWithFormat:@"%@[视频]", adName];
            self.adTypeControl.selectedSegmentIndex = 1;
        } else if (adType == KwaiGameADType_Insert) {
            buttonName = [NSString stringWithFormat:@"%@[插屏]", adName];
            self.adTypeControl.selectedSegmentIndex = 2;
        } else if (adType == KwaiGameADType_Banner) {
            buttonName = [NSString stringWithFormat:@"%@[横幅]", adName];
            self.adTypeControl.selectedSegmentIndex = 3;
        } else if (adType == KwaiGameADType_Splash) {
            buttonName = [NSString stringWithFormat:@"%@[开屏]", adName];
            self.adTypeControl.selectedSegmentIndex = 4;
        } else if (adType == KwaiGameADType_Feed) {
            buttonName = [NSString stringWithFormat:@"%@[信息流]", adName];
            self.adTypeControl.selectedSegmentIndex = 5;
        }else if (adType == KwaiGameADType_Draw) {
            buttonName = [NSString stringWithFormat:@"%@[Draw]", adName];
            self.adTypeControl.selectedSegmentIndex = 6;
        } else {
            buttonName = [NSString stringWithFormat:@"%@[未知]", adName];
        }
        [self.adShowButton setTitle:buttonName forState:UIControlStateNormal];
        [ADSDKManager adButtonShow:adName sceneName:@"Test"];
    }
    DemoRunInMainThreadEnd
}

- (void)didAdTypeChanged:(id)sender {
    [ADSDKManager adButtonShow:[NSString stringWithFormat:@"%ld", (long)self.adTypeControl.selectedSegmentIndex] sceneName:@"Test"];
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

- (void)showAd {
    [KwaiGameADManager showAD:self.customADName sceneName:@"Test" delegate:self];
}

- (void)showBannerOrFeed {
    if (self.adTypeControl.selectedSegmentIndex == 3) {
        [ADSDKManager hiddenBanner:self.customADName isHidden:NO];
    }
    if (self.adTypeControl.selectedSegmentIndex == 5) {
        [ADSDKManager hiddenFeed:self.customADName isHidden:NO];
    }
}

- (void)hiddenBannerOrFeed {
    if (self.adTypeControl.selectedSegmentIndex == 3) {
        [ADSDKManager hiddenBanner:self.customADName isHidden:YES];
    }
    if (self.adTypeControl.selectedSegmentIndex == 5) {
        [ADSDKManager hiddenFeed:self.customADName isHidden:YES];
    }}

- (void)removeBannerOrFeed {
    if (self.adTypeControl.selectedSegmentIndex == 3) {
        [ADSDKManager dismissBanner:self.customADName];
    }
    if (self.adTypeControl.selectedSegmentIndex == 5) {
        [ADSDKManager dismissFeed:self.customADName];
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
    [ADSDKManager adRewardComplete:self.customADName
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

@end
