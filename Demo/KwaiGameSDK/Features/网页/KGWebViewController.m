//
//  KGWebViewController.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2019/9/26.
//  Copyright © 2019 mookhf. All rights reserved.
//

#import "KGWebViewController.h"
#import "UIViewController+DemoSupport.h"
#import <KwaiGameSDK/KwaiGameSDK.h>
#import "KGUtil.h"
#import "KGTokenHelper.h"
#import "UIView+Toast.h"
#import <KwaiGameSDK/KwaiGameWebViewClient.h>

@interface KGWebViewController ()<UITextFieldDelegate, KwaiGameWebViewClientDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) KwaiGameWebViewClient *wbClient;
@property (nonatomic, strong) UISwitch *orientationSwitch;
@property (nonatomic, strong) UISwitch *hidetoolbarSwitch;
@property (nonatomic, strong) UISwitch *fullscreenSwitch;
@property (nonatomic, strong) UISwitch *hideprogressSwitch;
@end

@implementation KGWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.textField = [[UITextField alloc] init];
    self.textField.center = CGPointMake(self.view.center.x, 100);
    self.textField.backgroundColor = [UIColor grayColor];
    self.textField.placeholder = @"不填打开测试网页";
    self.textField.text = @"https://www.baidu.com";
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.delegate = self;
    [self addSubView:self.textField frame:CGRectMake(0, 80, 200, 40)];
    
    [self addSubButton:@"目前方向弹出" frame:CGRectMake(0, 130, 200, 40) selector:@selector(openwebview)];
    
    self.orientationSwitch = [self addSubSwitch:@"设置横屏弹出" frame:CGRectMake(80, 200, 120, 80) selector:nil];
    self.orientationSwitch.on = YES;
    
    [self addSubButton:@"指定方向弹出" frame:CGRectMake(0, 240, 200, 40) selector:@selector(openwebview1)];
    
    self.hidetoolbarSwitch = [self addSubSwitch:@"隐藏工具栏" frame:CGRectMake(80, 290, 120, 80) selector:nil];
    self.hidetoolbarSwitch.on = NO;
    
    self.fullscreenSwitch = [self addSubSwitch:@"全屏模式" frame:CGRectMake(80, 330, 120, 80) selector:nil];
    self.fullscreenSwitch.on = YES;

    self.hideprogressSwitch = [self addSubSwitch:@"隐藏进度条" frame:CGRectMake(80, 370, 120, 80) selector:nil];
    self.hideprogressSwitch.on = NO;
}

- (void)openwebview {
    NSString *url = self.textField.text.length > 0 ? self.textField.text : @"http://node-game-bridge-dev1.test.gifshow.com/demo?type=KwaiGameCloseWebView";
    KwaiGameWebViewConfig *config = [KwaiGameWebViewConfig new];
    config.orientation = KwaiGameWebViewOrientation_Auto;
    config.shareOptions = KwaiGameWebViewShare_Kwai | KwaiGameWebViewShare_QQ | KwaiGameWebViewShare_Weibo | KwaiGameWebViewShare_Wechat | KwaiGameWebViewShare_Friend;
    config.hideToolbar = self.hidetoolbarSwitch.on;
    config.hideProgress = self.hideprogressSwitch.on;
    config.style = self.fullscreenSwitch.isOn ? KwaiGameWebViewStyle_FullScreen : KwaiGameWebViewStyle_Floating;
    config.frameScale = CGRectMake(0.25, 0.25, 0.5, 0.5);
    self.wbClient = [[KwaiGameWebViewClient alloc] initWithConfig:config rootViewController:self delegate:self];
    __weak typeof(self) weakSelf = self;
    [self.wbClient registerJSBridge:@"TestBridge" callback:^(id params) {
        if ([params isKindOfClass:NSString.class]) {
            NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
            id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSString *callback = [dict valueForKey:@"callback"];
            if (callback) {
                [weakSelf.wbClient callJS:callback params:@{@"hello":@"world"} completion:nil];
            }
        }
    }];
    [self.wbClient openUrl:url];
}

- (void)openwebview1 {
    NSString *url = self.textField.text.length > 0 ? self.textField.text : @"http://node-game-bridge-dev1.test.gifshow.com/demo?type=KwaiGameCloseWebView";
    KwaiGameWebViewConfig *config = [KwaiGameWebViewConfig new];
    config.orientation = self.orientationSwitch.isOn ? KwaiGameWebViewOrientation_Landscape : KwaiGameWebViewOrientation_Portrait;
    config.shareOptions = KwaiGameWebViewShare_Kwai | KwaiGameWebViewShare_QQ | KwaiGameWebViewShare_Weibo | KwaiGameWebViewShare_Wechat | KwaiGameWebViewShare_Friend | KwaiGameWebViewShare_QZone;
    config.hideToolbar = self.hidetoolbarSwitch.on;
    config.hideProgress = self.hideprogressSwitch.on;
    config.style = self.fullscreenSwitch.isOn ? KwaiGameWebViewStyle_FullScreen : KwaiGameWebViewStyle_Floating;
    config.frameScale = CGRectMake(0.25, 0.25, 0.5, 0.5);
    self.wbClient = [[KwaiGameWebViewClient alloc] initWithConfig:config rootViewController:self delegate:self];
    [self.wbClient openUrl:url];
}

#pragma mark - KwaiGameWebViewClientDelegate
- (void)webViewClient:(KwaiGameWebViewClient *)client didClickWebViewShareOption:(KwaiGameWebViewShareOptions)shareOption {
    [self _toast:[NSString stringWithFormat:@"点击了分享 %@ ==> %@", @(shareOption), client.currentWebViewURL]];
}

- (BOOL)webViewClient:(KwaiGameWebViewClient *)client shouldDenyRequest:(NSURL *)url {
    return NO;
}

- (void)webViewClientDidStartLoad:(KwaiGameWebViewClient *)client {
    
}

- (void)webViewClient:(KwaiGameWebViewClient *)client didFinishLoad:(NSError *)error {
    if (error) {
        [self _toast:error.localizedDescription];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

#pragma mark - toast
- (void)_toast:(NSString *)msg {
    [[UIApplication sharedApplication].keyWindow makeToast:msg?:@""];
}

@end
