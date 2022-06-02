//
//  KGCustomUIViewController.m
//  KwaiGameSDK_Example
//
//  Created by 刘玮 on 2019/7/10.
//  Copyright © 2019 mookhf. All rights reserved.
//

#import "KGCustomUIViewController.h"
#import <KwaiGameSDK/KwaiGameSDK+CustomUIAdapter.h>
#import <KwaiGameSDK/KwaiGamePhoneVerifyInfo+Public.h>
#import <KwaiGameSDK/KwaiGameAntiAddict.h>
#import <KwaiGameSDK/KwaiGameCertInfo+Public.h>
#import "KwaiBase.h"

DescClass(KwaiGameCertGiftItem);
DescClass(KwaiGameCertInfo);
DescClass(KwaiGameAntiAddictInfo);
DescClass(KwaiGamePhoneVerifyInfo);
DescClass(KwaiGamePhoneVerifyGiftItem);

@interface KGCustomUIViewController()<KwaiGameSDKCustomUIAdapter>

@end

@implementation KGCustomUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addSpliteLine:@"自定义手机号绑定:开启" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];
    [self addSubButton:@"绑定手机号" frame:CGRectMake(15, 400, 200, 30) selector:@selector(doBindPhone)];
    [self addSpliteLine:@"自定义实名认证:开启" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];
    [self addSubButton:@"实名认证" frame:CGRectMake(15, 400, 200, 30) selector:@selector(doCert)];
    [self addSpliteLine:@"自定义防沉迷:开启" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];
    [self addSubButton:@"同步状态" frame:CGRectMake(15, 400, 200, 30) selector:@selector(doSync)];
    [KwaiGameSDK sharedSDK].customUIAdapter = self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [KwaiGameSDK sharedSDK].customUIAdapter = nil;
}

#pragma mark - private

- (void)doBindPhone {
    [[KwaiGameSDK sharedSDK] bindAccountWithPhoneUsingCustomUI:^(KwaiGamePhoneVerifyInfo * _Nonnull bindPhoneInfo) {
        [self doGetVerifyCode:bindPhoneInfo];
    } completion:^(NSError * _Nonnull error, KwaiGameBindResult * _Nonnull bindResult) {
        GLOBAL_RUN_IN_MAIN_THREAD_START
        if (error) {
            [self toast:@"%@", error];
            return;
        }
        [self toast:@"绑定成功"];
        GLOBAL_RUN_IN_MAIN_THREAD_END
    }];
}

- (void)doCert {
    [[KwaiGameSDK sharedSDK] certificateUsingCustomUI:^(KwaiGameCertInfo * _Nonnull certInfo) {
        [self didCertificationInfoUpdate:certInfo];
    } completion:^(BOOL certificated, NSError * _Nonnull error) {
        GLOBAL_RUN_IN_MAIN_THREAD_START
        if (error) {
            [self toast:@"%@", error];
            return;
        }
        [self toast:@"实名成功"];
        GLOBAL_RUN_IN_MAIN_THREAD_END
    }];
}

- (void)doSync {
    [KwaiGameAntiAddict syncAntiAddictStatus];
}

#pragma mark - KwaiGameSDKCustomUIAdapter

- (BOOL)didAddictInfoUpdate:(KwaiGameAntiAddictInfo *)info {
    [[KwaiGameSDK sharedSDK] log:@"addict info:%@",info];
    if (info.status <= 0 && info.remindStatus <= 0) {
        return YES;
    }
    if (info.showToast) {
        [self toast:info.message];
        return YES;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"防沉迷提示" message:info.message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (info.needLogout) {
            [[KwaiGameSDK sharedSDK] logoutWithCompletion:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }]];
    if (info.canClose) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    }
    [self presentViewController:alertController animated:YES completion:nil];
    return YES;
}

- (BOOL)didCertificationInfoUpdate:(KwaiGameCertInfo *)info {
    [[KwaiGameSDK sharedSDK] log:@"cert info:%@",info];
    void(^showCertAlert)(NSArray<KwaiGameCertGiftItem *> * _Nullable items) = ^(NSArray<KwaiGameCertGiftItem *> * _Nullable items) {
        __block NSString *message = info.message;
        if (info.subTitle.length > 0) {
            message = [NSString stringWithFormat:@"%@\n%@", info.subTitle, message];
        }
        if (items != nil) {
            message = [NSString stringWithFormat:@"%@\n礼包信息", message];
            [items enumerateObjectsUsingBlock:^(KwaiGameCertGiftItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                message = [NSString stringWithFormat:@"%@\n%@(%.2f)", message, obj.name, obj.worth];
            }];
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:info.title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        __block int nameTag = 1;
        __block int idNumberTag = 2;
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.tag = nameTag;
            textField.placeholder = @"姓名";
        }];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.tag = idNumberTag;
            textField.placeholder = @"身份证号";
        }];
        if (!info.forceCert) {
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [info closeCert:^{
                    // do nothing
                }];
            }]];
        }
        [alertController addAction:[UIAlertAction actionWithTitle:info.buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __block NSString *name = nil;
            __block NSString *cardNumber = nil;
            [alertController.textFields enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.tag == nameTag) {
                    name = obj.text;
                }
                if (obj.tag == idNumberTag) {
                    cardNumber = obj.text;
                }
            }];
            [info doCert:name certNumber:cardNumber completion:^(NSError * _Nonnull error) {
                GLOBAL_RUN_IN_MAIN_THREAD_START
                if (error) {
                    [self toast:@"%@", error];
                }
                GLOBAL_RUN_IN_MAIN_THREAD_END
            }];
        }]];
        if (self.presentedViewController != nil || self.presentingViewController != nil) {
            [info closeCert:^{
                // do nothing
            }];
            return;
        }
        [self presentViewController:alertController animated:YES completion:nil];
    };
    if (!info.hasGiftActivity) {
        showCertAlert(nil);
        return YES;
    }
    [info fetchGiftActivity:^(NSError * _Nonnull error, NSArray<KwaiGameCertGiftItem *> * _Nonnull items) {
        GLOBAL_RUN_IN_MAIN_THREAD_START
        [[KwaiGameSDK sharedSDK] log:@"cert gift items:%@",items];
        showCertAlert(items);
        GLOBAL_RUN_IN_MAIN_THREAD_END
    }];
    return YES;
}

- (void)doGetVerifyCode:(KwaiGamePhoneVerifyInfo *)info {
    [[KwaiGameSDK sharedSDK] log:@"phone verify info:%@",info];
    void(^showBindAlert)(NSArray<KwaiGamePhoneVerifyGiftItem *> * _Nullable items) = ^(NSArray<KwaiGamePhoneVerifyGiftItem *> * _Nullable items) {
        __block NSString *message = @"发送验证码";
        if (items != nil) {
            message = [NSString stringWithFormat:@"%@\n礼包信息", message];
            [items enumerateObjectsUsingBlock:^(KwaiGamePhoneVerifyGiftItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                message = [NSString stringWithFormat:@"%@\n%@(%.2f)", message, obj.name, obj.worth];
            }];
        }
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"绑定手机号" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        __block int phoneTag = 1;
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.tag = phoneTag;
            textField.placeholder = @"手机号";
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [info didClose];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"获取验证码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __block NSString *phoneNumber = nil;
            [alertController.textFields enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.tag == phoneTag) {
                    phoneNumber = obj.text;
                }
            }];
            [info requestMobileCode:@"+86"
                              phone:phoneNumber
                         completion:^(NSError * _Nonnull error) {
                GLOBAL_RUN_IN_MAIN_THREAD_START
                if (error) {
                    [self toast:@"%@", error];
                } else {
                    [self doVetifyPhoneCode:info
                                countryCode:@"+86"
                                phoneNumber:phoneNumber];
                }
                GLOBAL_RUN_IN_MAIN_THREAD_END
            }];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    };
    if (!info.hasGiftActivity) {
        showBindAlert(nil);
        return;
    }
    [info fetchGiftActivity:^(NSError * _Nonnull error, NSArray<KwaiGamePhoneVerifyGiftItem *> * _Nonnull items) {
        GLOBAL_RUN_IN_MAIN_THREAD_START
        [[KwaiGameSDK sharedSDK] log:@"bind phone gift items:%@",items];
        showBindAlert(items);
        GLOBAL_RUN_IN_MAIN_THREAD_END
    }];
    return;
}

- (void)doVetifyPhoneCode:(KwaiGamePhoneVerifyInfo *)info
              countryCode:(NSString *)countryCode
              phoneNumber:(NSString *)phoneNumber {
    __block NSString *message = @"输入验证码";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"绑定手机号" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    __block int codeTag = 2;
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.tag = codeTag;
        textField.placeholder = @"验证码";
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [info didClose];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __block NSString *codeNumber = nil;
        [alertController.textFields enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.tag == codeTag) {
                codeNumber = obj.text;
            }
        }];
        [info verifyMobileCode:@"+86"
                         phone:phoneNumber
                       smsCode:codeNumber
                    completion:^(NSError * _Nonnull error) {
            GLOBAL_RUN_IN_MAIN_THREAD_START
            if (error) {
                [self toast:@"%@", error];
            }
            GLOBAL_RUN_IN_MAIN_THREAD_END
        }];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
