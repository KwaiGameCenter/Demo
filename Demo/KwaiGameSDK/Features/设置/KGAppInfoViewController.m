//
//  KGAppInfoViewController.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/12/27.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "KGAppInfoViewController.h"
#import <KwaiGameSDK/KwaiGameSDK.h>
#import <KwaiGameSDK/KwaiGameSDK+Tools.h>
#import "KwaiGameSDK+Demo.h"
#import <KwaiGameSDK/KwaiGameDeviceInfo.h>
#import <KwaiGameSDK-WWP/KwaiGameWWPToken.h>
#import "UIViewController+DemoSupport.h"
#import "MBProgressHUD.h"
#import "KwaiBase.h"
#import "KGUtil.h"

DescClass(KwaiGameTimestamp);

@interface KGAppInfoViewController ()

@property (nonatomic, assign) BOOL isStaging;

@end

@implementation KGAppInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(close)];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addSpliteLine:@"基础信息" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];
    [self addSubLabel:[NSString stringWithFormat:@"APP版本: %@", [self appVersion]] frame:CGRectMake(0, 80, 200, 30)];
    [self addSubLabel:[NSString stringWithFormat:@"SDK版本: %@[%@]", [[KwaiGameSDK sharedSDK] sdkVersion], [[KwaiGameSDK sharedSDK] sdkBranch]] frame:CGRectMake(0, 120, 200, 60)];
    [self addSubButton:@"拷贝快手设别指纹" frame:CGRectMake(0, 480, 200, 30) selector:@selector(copyFingerPrint)];
    [self addSubButton:@"复制设备ID" frame:CGRectMake(0, 520, 200, 30) selector:@selector(showdeviceid)];
    [self addSubButton:@"复制IDFA" frame:CGRectMake(0, 560, 200, 30) selector:@selector(showidfa)];
    [self addSubButton:@"获取服务器时间戳" frame:CGRectMake(0, 560, 200, 30) selector:@selector(getTiemstamp)];
    
    [self addSpliteLine:@"修改工具" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];
    
    self.isStaging = [KwaiGameSDK sharedSDK].currentEnv == KwaiGameEnv_Staging;
    [self addSubButton:[NSString stringWithFormat:@"%@， 点击切换",self.isStaging ?  @"测试环境" : @"线上环境"] frame:CGRectMake(0, 200, 200, 30) selector:@selector(changeEnv)];
    
    BOOL isOversea = NO;
    if ([KGUtil overseaType] == 1) {
        isOversea = YES;
        [self addSubButton:@"海外(超休闲)" frame:CGRectMake(20, 720, 200, 30)  selector:@selector(changeOverseaType)];
    } else if ([KGUtil overseaType] == 2) {
        isOversea = YES;
        [self addSubButton:@"海外(大游戏)" frame:CGRectMake(20, 720, 200, 30)  selector:@selector(changeOverseaType)];
    } else {
        [self addSubButton:@"国内" frame:CGRectMake(20, 720, 200, 30)  selector:@selector(changeOverseaType)];
    }
    
    if (isOversea) {
        if (KGUtil.enableSDKPolicyPrivacy) {
            [self addSubButton:@"关闭海外隐私合规" frame:CGRectMake(20, 720, 200, 30)  selector:@selector(disableSDKPolicyPrivacy)];
        } else {
            [self addSubButton:@"开启海外隐私合规" frame:CGRectMake(20, 720, 200, 30)  selector:@selector(enableSDKPolicyPrivacy)];
        }
    }
    
    if ([KGUtil checkQAEnv]) {
        [self addSubButton:@"关闭QA模式" frame:CGRectMake(20, 720, 200, 30)  selector:@selector(clearQAEnv)];
    } else {
        [self addSubButton:@"开启QA模式" frame:CGRectMake(20, 720, 200, 30)  selector:@selector(setQAEnv)];
    }
    
    if ([KGUtil checkLandscape]) {
        [self addSubButton:@"模拟竖屏游戏" frame:CGRectMake(20, 720, 200, 30)  selector:@selector(clearLandscape)];
    } else {
        [self addSubButton:@"模拟横屏游戏" frame:CGRectMake(20, 720, 200, 30)  selector:@selector(setLandscape)];
    }
    
    if ([KGUtil logoName].length > 0) {
        [self addSubButton:@"去快手品牌" frame:CGRectMake(20, 720, 200, 30)  selector:@selector(clearLogo)];
    } else {
        [self addSubButton:@"恢复快手品牌" frame:CGRectMake(20, 720, 200, 30)  selector:@selector(revertLogo)];
    }
    
    if ([KGUtil checkIdfaFirst]) {
        [self addSubButton:@"打开测试idfa授权" frame:CGRectMake(20, 720, 200, 30)  selector:@selector(clearCheckIdfaFirstFlag)];
    } else {
        [self addSubButton:@"关闭测试idfa授权" frame:CGRectMake(20, 720, 200, 30)  selector:@selector(setCheckIdfaFirstFlag)];
    }
    
    [self addSubButton:@"自定义AppId" frame:CGRectMake(20, 720, 200, 30)  selector:@selector(changeAppId)];
    
    [self addSubButton:@"自定义测试环境域名" frame:CGRectMake(20, 720, 200, 30)  selector:@selector(changeTestStagingURL)];
    
    [self addSpliteLine:@"清理工具" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];

    [self addSubButton:@"清除快手OAuth登录状态" frame:CGRectMake(20, 640, 200, 30) selector:@selector(clearBundleToekn)];
    [self addSubButton:@"清除快手设备指纹" frame:CGRectMake(20, 680, 200, 30) selector:@selector(clearFingerPrint)];
    
    [self addSpliteLine:@"测试工具" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];
    
    [self addSubButton:@"导出日志" frame:CGRectMake(0, 160, 200, 30) selector:@selector(exportLogs)];
    [self addSubButton:@"上传日志到服务器" frame:CGRectMake(0, 160, 200, 30) selector:@selector(sendLogsToServer)];
    [self addSubButton:@"上传图片" frame:CGRectMake(0, 240, 200, 30) selector:@selector(uploadImage)];
    [self addSubButton:@"上传ZIP" frame:CGRectMake(0, 280, 200, 30) selector:@selector(uploadZip)];
    [self addSubButton:@"CRASH" frame:CGRectMake(0, 400, 200, 30) selector:@selector(crash)];
    [self addSubButton:@"CRASH AFTER 10s" frame:CGRectMake(0, 440, 200, 30) selector:@selector(crashlater)];
}

- (NSString *)appVersion {
    return [KwaiGameDeviceInfo appVersion];
}

- (void)exportLogs {
    [[KwaiGameSDK sharedSDK] performSelector:@selector(exportLogs)];
}

- (void)sendLogsToServer {
    [[KwaiGameSDK sharedSDK] updateLog:@"标签" completion:^(NSError * _Nonnull error) {
        if (error) {
            [self toast:@"上传失败:%@",error];
            return;
        }
        [self toast:@"上传成功"];
    }];
}

- (void)changeEnv {
    [[KwaiGameSDK sharedSDK] logoutWithCompletion:^(NSError *error) {
        if (error) {
            [self toast:error.localizedDescription?:@""];
        } else {
            [self forecCloseApp:NO completion: ^{
                [[KwaiGameSDK sharedSDK] switchGameEnv:self.isStaging ? KwaiGameEnv_Release : KwaiGameEnv_Staging completion:^{
                }];
            }];
        }
    }];
}

- (void)uploadImage {
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://b.hiphotos.baidu.com/image/pic/item/0ff41bd5ad6eddc4802878ba34dbb6fd536633a0.jpg"]]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabelText = @"网络图片上传中";
    [[KwaiGameSDK sharedSDK] uploadImage:image progress:^(CGFloat percent) {
        hud.progress = percent;
    } completion:^(NSError *error, NSString *uri) {
        [hud hide:YES];
        if (error) {
            [self toast:error.localizedDescription?:@"发生错误"];
        } else if (uri) {
            [self toast:uri];
        }
    }];
}

- (void)uploadZip {
    NSString *filepath = [[KwaiGameSDK sharedSDK] zipFeedback];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabelText = @"反馈日志上传中";
    [[KwaiGameSDK sharedSDK] uploadFile:filepath progress:^(CGFloat percent) {
        hud.progress = percent;
    } completion:^(NSError *error, NSString *uri) {
        [hud hide:YES];
        if (error) {
            [self toast:error.localizedDescription?:@"发生错误"];
        } else if (uri) {
            NSLog(@"%@", uri);
            [self toast:uri];
        }
    }];
}

- (void)showdeviceid {
    [self toast:[KwaiGameDeviceInfo deviceID]];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [KwaiGameDeviceInfo deviceID];
}

- (void)showidfa {
    [self toast:[KwaiGameDeviceInfo idfa]];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [KwaiGameDeviceInfo idfa];
}

- (void)crash {
    [@[] objectAtIndex:0];
}

- (void)crashlater {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [@[] objectAtIndex:0];
    });
}

- (void)copyFingerPrint {
    [UIPasteboard generalPasteboard].string = [KwaiGameDeviceInfo kwai_deviceFingerPrint];
    [self toast: [NSString stringWithFormat: @"拷贝成功: %@", [KwaiGameDeviceInfo kwai_deviceFingerPrint]]];
}

- (void)clearFingerPrint {
    Class manager = NSClassFromString(@"KWDeviceFingerPrint");
    SEL objSEL = NSSelectorFromString(@"defaultInstance");
    id obj = [manager performSelector:objSEL];
    if (obj != nil) {
        SEL clearSEL = NSSelectorFromString(@"cleanSecurityDFPCache");
        [obj performSelector:clearSEL];
    }
    [self toast: @"重启app后，将获得新的设备指纹"];
}

- (void)clearBundleToekn {
    Class manager = NSClassFromString(@"KSBundleTokenManager");
    SEL clearSEL = NSSelectorFromString(@"deleteValueForKey:");
    [manager performSelector:clearSEL withObject:@"com.kwai.openSDK.bundleToken"];
    [self forecCloseApp];
}

- (void)changeAppId {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入新的AppId" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertController.textFields.firstObject;
        [KGUtil setFeakScheme:textField.text];
        [self forecCloseApp];
    }]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = [NSString stringWithFormat:@"例子:%@",[KGUtil appId]];
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)clearLogo {
    [KGUtil clearCustomLogo];
}

- (void)revertLogo {
    [KGUtil setCustomLogo:@"CustomLogo"];
}

- (void)clearCheckIdfaFirstFlag {
    [KGUtil setCheckIdfaFirst:NO];
    [self forecCloseApp];
}

- (void)setCheckIdfaFirstFlag {
    [KGUtil setCheckIdfaFirst:YES];
    [self forecCloseApp];
}

- (void)clearQAEnv {
    [KGUtil setQAEnv:NO];
    [self forecCloseApp];
}

- (void)setQAEnv {
    [KGUtil setQAEnv:YES];
    [self forecCloseApp];
}

- (void)changeOverseaType {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"切换海外环境" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"国内" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [KGUtil setOverseaType:0];
        [self forecCloseApp];

    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"海外(大游戏)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [KGUtil setOverseaType:2];
        [self forecCloseApp];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"海外(超休闲)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [KGUtil setOverseaType:1];
        [self forecCloseApp];

    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)enableSDKPolicyPrivacy {
    KGUtil.enableSDKPolicyPrivacy = YES;
    [self forecCloseApp];
}

- (void)disableSDKPolicyPrivacy {
    KGUtil.enableSDKPolicyPrivacy = NO;
    [self forecCloseApp];
}

- (void)setLandscape {
    [KGUtil setLandscape:YES];
    [self forecCloseApp];
}

- (void)clearLandscape {
    [KGUtil setLandscape:NO];
    [self forecCloseApp];
}

- (void)getTiemstamp {
    [[KwaiGameSDK sharedSDK] getTimestamp:^(NSError *error, KwaiGameTimestamp *timestamp) {
        RUN_IN_MAIN_THREAD_START
        [self toast: [NSString stringWithFormat: @"时间戳信息: %@", timestamp]];
        RUN_IN_MAIN_THREAD_END
    }];
}

- (void)forecCloseApp {
    [self forecCloseApp:YES completion:nil];
}

- (void)forecCloseApp:(BOOL)keepEnv completion:(void (^)(void))completion {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"重启App后生效" message:@"点击确定重启App" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [KGUtil resetSDKEnv];
        if (completion) {
            completion();
        }
        if (keepEnv) {
            // 切换配置后，会导致丢失测试环境状态，此处做一次确认
            [[KwaiGameSDK sharedSDK] switchGameEnv:self.isStaging ?  KwaiGameEnv_Staging : KwaiGameEnv_Release completion:^{
            }];
        }
        RUN_IN_MAIN_THREAD_START
        exit(0);
        RUN_IN_MAIN_THREAD_END
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)changeTestStagingURL {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入新测试环境URL" message:[NSString stringWithFormat:@"当前URL:%@",[KGUtil testStagingURL]] preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertController.textFields.firstObject;
        if (textField.text.length) {
            [KGUtil setTestStagingURL:textField.text];
        } else {
            [KGUtil setTestStagingURL:textField.placeholder];
        }
        [self forecCloseApp];
    }]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"https://gamecloud-api.test.gifshow.com";
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)close {
    if (self.presentingViewController != nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
