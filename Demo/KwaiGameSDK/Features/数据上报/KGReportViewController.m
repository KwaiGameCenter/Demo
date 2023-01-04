//
//  KGReportViewController.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/11/23.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "KGReportViewController.h"
#import "KGPerformanceReportViewController.h"
#import "UIViewController+DemoSupport.h"
#import <KwaiGameSDK/KwaiGameSDK.h>
#import <KwaiGameSDK/KwaiGameSDK+CrashReport.h>
#import "AFNetworking.h"
#import "KwaiBase.h"
#import "KGUtil.h"

@interface KGReportViewController ()

@property (nonatomic, strong) UISwitch *multiSwitch;
@property (nonatomic, strong) UISwitch *bigFile;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UITextView *inputCustomReportText;

@end

@implementation KGReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"性能埋点" style:UIBarButtonItemStylePlain target:self action:@selector(showPerformanceReportVC)];
    
    [self addSpliteLine:@"基础功能" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];
        
    self.timeLabel = [self addSubLabel:[self currentTime] frame:CGRectMake(0, 80, 200, 30)];
    
    [self addSubButton:@"打点" frame:CGRectMake(0, 80, 200, 30) selector:@selector(report)];
    
    [self addSubButton:@"打点(带参数)" frame:CGRectMake(0, 80, 200, 30) selector:@selector(reportExt)];
    
    [self addSubButton:@"获取AppsFlyerId" frame:CGRectMake(0, 80, 200, 30) selector:@selector(getAppsFlyerId)];
    
    [self addSubButton:@"AppsFlyer归因数据" frame:CGRectMake(0, 80, 200, 30) selector:@selector(getAppsFlyerData)];
    
    [self addSubButton:@"打点(读取输入)" frame:CGRectMake(0, 80, 200, 30) selector:@selector(reportCustomParam)];
    
    self.inputCustomReportText = [[UITextView alloc] init];
    self.inputCustomReportText.backgroundColor = [UIColor lightGrayColor];
    self.inputCustomReportText.text = @"{\"action\":\"aa\",\"params\":{\"a\":\"1\",\"b\":\"2\"}}";
    self.inputCustomReportText.returnKeyType = UIReturnKeyDone;
//    self.inputCustomReportText.delegate = self;
    [self addSubView:self.inputCustomReportText frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 80)];
    
    [self addSpliteLine:@"监测上报" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];
    
    [self addSubButton:@"自定义监测事件" frame:CGRectMake(0, 80, 200, 30) selector:@selector(reportADPath:)];
    
    [self addSpliteLine:@"异常上报" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];
    
    [self addSubButton:@"自定义异常" frame:CGRectMake(0, 80, 200, 30) selector:@selector(reprotCustomException:)];
    
    [[KwaiGameSDK sharedSDK] setGameExtension:@{
        @"CurrentSence":NSStringFromClass(self.class)
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timeLabel = nil;
}

- (void)updateTime:(NSTimer *)timer {
    self.timeLabel.text = [self currentTime];
}

- (void)report {
    NSString *actionName = @"TryTry1";
    [[KwaiGameSDK sharedSDK] reportAction:actionName];
    [self toast:[NSString stringWithFormat:@"%@", actionName]];
}

- (void)reportExt {
    NSString *actionName = @"TryTry2";
    NSDictionary *param = @{@"time":[self currentTime]};
    [[KwaiGameSDK sharedSDK] reportAction:actionName param:param];
    [self toast:[NSString stringWithFormat:@"%@\n%@", actionName, param]];
}

- (void)reportCustomParam {
    if (KWAI_IS_STR_NIL(self.inputCustomReportText.text)) {
        [self toast:@"自定义参数为空"];
        return;
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[self.inputCustomReportText.text dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    if (dict == nil) {
        [self toast:@"自定义参数解析失败"];
        return;
    }
    NSString *actionName = [dict objectForKey:@"action"];
    if (KWAI_IS_STR_NIL(actionName)) {
        [self toast:@"自定义事件名称为空"];
        return;
    }
    NSDictionary *params = [dict objectForKey:@"params"];
    //解析
    [[KwaiGameSDK sharedSDK] reportAction:actionName param:params];
}

- (void)reportADPath:(id)sender {
    static NSNumber *conversionValue;
    if (conversionValue == nil) {
        conversionValue = @(1);
    } else {
        conversionValue = @(conversionValue.intValue + 1);
        if (conversionValue.intValue > 64) {
            conversionValue = @(64);
        }
    }
    [[KwaiGameSDK sharedSDK] reportCustomEvent:@"SKAdNetworkTest" params:@{
        @"conversionValue":conversionValue
    }];
    if ([sender isKindOfClass:UIButton.class]) {
        [(UIButton *)sender setTitle:[NSString stringWithFormat:@"自定义监测事件:%@",conversionValue] forState:UIControlStateNormal];
    }
}

- (void)reprotCustomException:(id)sender {
    [[KwaiGameSDK sharedSDK]reportCustomException:@"DemoCustomException" reason:@"test bugly custom exception" userInfo:@{
        @"aaa":@"test"
    }];
    [self toast:@"已点击自定义异常上报"];
}

- (void)getAppsFlyerId {
    [UIPasteboard generalPasteboard].string =  [[KwaiGameSDK sharedSDK] getAppsFlyerId];
    [self toast:[NSString stringWithFormat:@"拷贝AppsFlyerId:%@", [[KwaiGameSDK sharedSDK] getAppsFlyerId]]];
}

- (void)getAppsFlyerData {
    [self toast:[NSString stringWithFormat:@"AppsFlyerData = %@", [[KwaiGameSDK sharedSDK] getAppsFlyerData]]];
}

- (void)showPerformanceReportVC{
    [self.navigationController pushViewController:[KGPerformanceReportViewController new] animated:YES];
}

#pragma mark - Time

- (NSString *)currentTime {
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    return [formatter stringFromDate:now];
}

@end
