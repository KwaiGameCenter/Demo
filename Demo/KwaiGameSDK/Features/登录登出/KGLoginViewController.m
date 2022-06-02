//
//  KGLoginViewController.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/11/23.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "KGLoginViewController.h"
#import <KwaiGameSDK/KwaiGameSDK.h>
#import <KwaiGameSDK/KwaiGameSDK+Page.h>
#import <KwaiGameSDK-Oversea/KwaiGameSDK+Oversea.h>
#import <KwaiGameSDK/KwaiGameSDK+Gateway.h>
#import "UIViewController+DemoSupport.h"
#import "KGUtil.h"
#import "KGPayHelper.h"
#import "UIView+Toast.h"
#import "KwaiBase.h"
#import "UIView+DemoSupport.h"

@interface KGLoginViewController ()

@property (nonatomic, strong) UISwitch *supportCustomLogin;
@property (nonatomic, strong) UISwitch *supportKwaiApp;
@property (nonatomic, strong) UISwitch *supportPhone;
@property (nonatomic, strong) UISwitch *supportGuest;
@property (nonatomic, strong) UISwitch *supportSIWA;
@property (nonatomic, strong) UISwitch *supportQQ;
@property (nonatomic, strong) UISwitch *supportWx;
@property (nonatomic, strong) UISwitch *supportFaceBook;
@property (nonatomic, strong) UISwitch *supportGoogle;
@property (nonatomic, strong) UISwitch *supportGameCenter;
@property (nonatomic, strong) UISwitch *supportQrCode;

@property (nonatomic, strong) UIView *userInfoView;
@property (nonatomic, strong) UIButton *userIdButton;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *lastLoginTypeLabel;

@end

@implementation KGLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.userInfoView = [[UIView alloc] init];
    self.userInfoView.demoParams.demoCellDistance = 15.0f;
    self.userInfoView.demoTargetProxy = self;
    [self addSubView:self.userInfoView frame:CGRectMake(0.0f, 0.0f, DemoUIScreenWidth, 180)];
    [self.userInfoView addSpliteLine:@"用户信息" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];
    self.userIdButton = [self.userInfoView addSubButton:@"获取用户Id" frame:CGRectMake(0, 60, 200, 30) selector:@selector(copyUid:)];
    self.userNameLabel = [self.userInfoView addSubLabel:@"未登录" frame:CGRectMake(0, 60, 200, 30)];
    self.lastLoginTypeLabel = [self.userInfoView addSubLabel:@"登录方式:未登录" frame:CGRectMake(0, 60, 200, 30)];
    
    [self addSpliteLine:@"登录登出" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];
    
    [self addSubButton:@"登录" frame:CGRectMake(0, 60, 200, 30) selector:@selector(login)];
    [self addSubButton:@"退出" frame:CGRectMake(0, 110, 200, 30) selector:@selector(logout)];
    [self addSubButton:@"无UI登录" frame:CGRectMake(0, 260, 200, 30) selector:@selector(directLogin)];
    [self addSubButton:@"展示公告" frame:CGRectMake(0, 310, 200, 30) selector:@selector(showAnnouncement)];
    [self addSubButton:@"获取公告信息" frame:CGRectMake(0, 310, 200, 30) selector:@selector(getAnnouncementInfo)];
    
    [self addSubButton:@"绑定" frame:CGRectMake(0, 210, 200, 30) selector:@selector(bind)];
    [self addSubButton:@"直接绑定" frame:CGRectMake(0, 260, 200, 30) selector:@selector(directBind)];
    [self addSubButton:@"账号管理" frame:CGRectMake(0, 110, 200, 30) selector:@selector(openAccountManager)];
    
    if (![KwaiGameSDK sharedSDK].isOversea) {
        [self addSubButton:@"同步游戏信息" frame:CGRectMake(0, 110, 200, 30) selector:@selector(updateGameData)];
        [self addSubButton:@"获取信息" frame:CGRectMake(0, 160, 200, 30) selector:@selector(getUserInfo)];
        [self addSubButton:@"实名认证" frame:CGRectMake(0, 110, 200, 30) selector:@selector(doUserCert)];
        [self addSubButton:@"切换账号" frame:CGRectMake(0, 310, 200, 30) selector:@selector(switchAccount)];
    }
    
        [self addSpliteLine:@"自定义登录方式" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];
        
        self.supportCustomLogin = [self addSubSwitch:@"自定义" frame:CGRectMake(10, 450, 80.0f, 80.0) selector:@selector(didChangedSupport:)];
        
    // 自定义登录方式switch
    if ([KwaiGameSDK sharedSDK].isOversea) {
        UIView *containerView = [[UIView alloc] init];
        [self addSubView:containerView frame:CGRectMake(0, 0, DemoUIScreenWidth, 80.0)];
        containerView.demoParams.demoIsLandscape = YES;
        
        
        CGFloat width = 80.0f;
        containerView.demoParams.demoCellDistance = (DemoUIScreenWidth - 3 * width) / 4;

        self.supportGuest = [containerView addSubSwitch:@"游客" frame:CGRectMake(0, 0, width, 80.0) selector:nil];
        self.supportFaceBook = [containerView addSubSwitch:@"facebook" frame:CGRectMake(0, 0, width, 80.0) selector:nil];
        self.supportGoogle = [containerView addSubSwitch:@"google" frame:CGRectMake(0, 0, width, 80.0) selector:nil];
        
        containerView = [[UIView alloc] init];
        [self addSubView:containerView frame:CGRectMake(0, 0, DemoUIScreenWidth, 80.0)];
        containerView.demoParams.demoIsLandscape = YES;
        containerView.demoParams.demoCellDistance = (DemoUIScreenWidth - 3 * width) / 4;

        self.supportSIWA = [containerView addSubSwitch:@"苹果" frame:CGRectMake(0, 0, width, 80.0) selector:nil];
        self.supportGameCenter = [containerView addSubSwitch:@"GameCenter" frame:CGRectMake(0, 0, width, 80.0) selector:nil];
        
        self.supportGuest.superview.hidden = YES;
        self.supportFaceBook.superview.hidden = YES;
        self.supportGoogle.superview.hidden = YES;
        self.supportSIWA.superview.hidden = YES;
        self.supportGameCenter.superview.hidden = YES;
        
        
        self.supportGuest.on = YES;
        self.supportFaceBook.on = YES;
        self.supportGoogle.on = YES;
        self.supportSIWA.on = YES;
        self.supportGameCenter.on = YES;
    } else {
        // 国内登录方式
        UIView *containerView = [[UIView alloc] init];
        [self addSubView:containerView frame:CGRectMake(0, 0, DemoUIScreenWidth, 80.0)];
        containerView.demoParams.demoIsLandscape = YES;
        
        
        CGFloat width = 80.0f;
        containerView.demoParams.demoCellDistance = (DemoUIScreenWidth - 3 * width) / 4;

        self.supportKwaiApp = [containerView addSubSwitch:@"快手" frame:CGRectMake(0, 0, width, 80.0) selector:nil];
        self.supportPhone = [containerView addSubSwitch:@"手机" frame:CGRectMake(0, 0, width, 80.0) selector:nil];
        self.supportGuest = [containerView addSubSwitch:@"游客" frame:CGRectMake(0, 0, width, 80.0) selector:nil];
        
        containerView = [[UIView alloc] init];
        [self addSubView:containerView frame:CGRectMake(0, 0, DemoUIScreenWidth, 80.0)];
        containerView.demoParams.demoIsLandscape = YES;
        containerView.demoParams.demoCellDistance = (DemoUIScreenWidth - 3 * width) / 4;
        
        self.supportSIWA = [containerView addSubSwitch:@"苹果" frame:CGRectMake(0, 0, width, 80.0) selector:nil];
        self.supportQQ = [containerView addSubSwitch:@"QQ" frame:CGRectMake(0, 0, width, 80.0) selector:nil];
        self.supportWx = [containerView addSubSwitch:@"微信" frame:CGRectMake(0, 0, width, 80.0) selector:nil];
        
        containerView = [[UIView alloc] init];
        [self addSubView:containerView frame:CGRectMake(0, 0, DemoUIScreenWidth, 80.0)];
        containerView.demoParams.demoIsLandscape = YES;
        containerView.demoParams.demoCellDistance = (DemoUIScreenWidth - 3 * width) / 4;
        
        self.supportQrCode = [containerView addSubSwitch:@"二维码" frame:CGRectMake(0, 0, width, 80.0) selector:nil];
        
        self.supportKwaiApp.superview.hidden = YES;
        self.supportPhone.superview.hidden = YES;
        self.supportGuest.superview.hidden = YES;
        self.supportSIWA.superview.hidden = YES;
        self.supportQQ.superview.hidden = YES;
        self.supportWx.superview.hidden = YES;
        self.supportQrCode.superview.hidden = YES;
        
        self.supportKwaiApp.on = YES;
        self.supportPhone.on = YES;
        self.supportGuest.on = YES;
        self.supportSIWA.on = YES;
        self.supportQQ.on = YES;
        self.supportWx.on = YES;
        self.supportQrCode.on = YES;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((arc4random()%100/800.0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([KwaiGameSDK sharedSDK].account == nil) {
            [self login];
        } else {
            [self updateUserInfo];
        }
    });
}

- (KwaiGameLoginTypeOption)loginOption {
    KwaiGameLoginTypeOption loginType = KwaiGameLoginType_None;
    // 共有登录方式
    if (self.supportGuest.isOn) {
        loginType |= KwaiGameLoginType_Visitor;
    }
    if (self.supportSIWA.isOn) {
        loginType |= KwaiGameLoginType_AppleId;
    }
    if(![KwaiGameSDK sharedSDK].isOversea) {
        // 国内独有登录方式
        if (self.supportKwaiApp.isOn) {
            loginType |= KwaiGameLoginType_KwaiApp;
            loginType |= KwaiGameLoginType_KwaiWeb;
        }
        if (self.supportPhone.isOn) {
            loginType |= KwaiGameLoginType_Phone;
        }
        if (self.supportQQ.isOn) {
            loginType |= KwaiGameLoginType_QQ;
        }
        if (self.supportWx.isOn) {
            loginType |= KwaiGameLoginType_Wx;
        }
        if (self.supportWx.isOn) {
            loginType |= KwaiGameLoginType_Wx;
        }
        if (self.supportQrCode.isOn) {
            loginType |= KwaiGameLoginType_QrCode;
        }
    } else {
        // 海外登录方式
        if (self.supportFaceBook.isOn) {
            loginType |= KwaiGameLoginType_Facebook;
        }
        if (self.supportGoogle.isOn) {
            loginType |= KwaiGameLoginType_Google;
        }
        if (self.supportGameCenter.isOn) {
            loginType |= KwaiGameLoginType_GameCenter;
        }
    }
    
    return loginType;
}

- (KwaiGameAuthType)firstAuthType:(BOOL)login {
    NSArray<UISwitch *> *allAuthButton = @[];
    if (login) {
        if ([KwaiGameSDK sharedSDK].isOversea) {
            // 海外
            allAuthButton = @[self.supportGuest, self.supportGoogle, self.supportFaceBook, self.supportSIWA, self.supportGameCenter];
        } else {
           //  国内
            allAuthButton = @[self.supportKwaiApp, self.supportPhone, self.supportSIWA, self.supportWx, self.supportQQ, self.supportGuest, self.supportQrCode];

        }
    } else {
        if ([KwaiGameSDK sharedSDK].isOversea) {
            // 海外
            allAuthButton = @[self.supportFaceBook, self.supportGoogle, self.supportSIWA, self.supportGameCenter];
        } else {
           //  国内
            allAuthButton = @[self.supportKwaiApp, self.supportPhone, self.supportSIWA, self.supportWx, self.supportQQ];

        }
    }
    __block int enableNumber = 0;
    [allAuthButton enumerateObjectsUsingBlock:^(UISwitch *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isOn) {
            enableNumber++;
        }
    }];
    if (enableNumber != 1) {
        return -1;
    }
    if (self.supportKwaiApp.isOn) {
        return KwaiGameAuthTypeKwaiApp;
    }
    if (self.supportPhone.isOn) {
        return KwaiGameAuthTypePhone;
    }
    if (self.supportSIWA.isOn) {
        return KwaiGameAuthTypeAppleId;
    }
    if (self.supportWx.isOn) {
        return KwaiGameAuthTypeWx;
    }
    if (self.supportQQ.isOn) {
        return KwaiGameAuthTypeQQ;
    }
    if (self.supportGuest.isOn) {
        return KwaiGameAuthTypeVisitor;
    }
    if (self.supportQrCode.isOn) {
        return KwaiGameAuthTypeQrCode;
    }
    if (self.supportGoogle.isOn) {
        return KwaiGameAuthTypeGoogle;
    }
    if (self.supportFaceBook.isOn) {
        return KwaiGameAuthTypeFacebook;
    }
    if (self.supportGameCenter.isOn) {
        return KwaiGameAuthTypeGameCenter;
    }
    return -1;
}

- (void)login {
    void(^completion)(NSError *error) = ^(NSError *error) {
        if (error) {
            if (error.code == KwaiGameSDKErrorCodeCertificationCanceled) {
                [self toast:@"未实名认证"];
            } else {
                [self toast:[NSString stringWithFormat: @"%@(%ld)", error.errorMsg, error.code]];
            }
        } else {
            [self toast:[KwaiGameSDK sharedSDK].account.uid];
            [self updateUserInfo];
            [[KGUtil util] gameLogin:[KwaiGameSDK sharedSDK].account.uid
                           gameToken:[KwaiGameSDK sharedSDK].account.serviceToken
                          completion:^(NSError *error, NSString *uid, NSDictionary *userInfo) {
                [[KGUtil util] updateGameData];
                [[KGPayHelper help] setup];
            }];
        }
    };
    if ([KwaiGameSDK sharedSDK].account == nil) {
        if (self.supportCustomLogin.isOn) {
            [[KwaiGameSDK sharedSDK] loginUsingBuiltUIWithLoginTypes:[self loginOption] completion:^(NSError *error) {
                completion(error);
            }];
        } else {
            [[KwaiGameSDK sharedSDK] loginUsingBuiltUIWithCompletion:^(NSError *error) {
                completion(error);
            }];
        }
    } else {
        [self toast:@"已经登录了"];
    }
}

- (void)directLogin {
    void(^completion)(NSError *error) = ^(NSError *error) {
        [self updateUserInfo];
        if (error) {
            if (error.code == KwaiGameSDKErrorCodeCertificationCanceled) {
                [self toast:@"未实名认证"];
            } else {
                [self toast:[NSString stringWithFormat: @"%@(%ld)", error.errorMsg, error.code]];
            }

        } else {
            [self toast:[KwaiGameSDK sharedSDK].account.uid];
            [[KGUtil util] gameLogin:[KwaiGameSDK sharedSDK].account.uid
                           gameToken:[KwaiGameSDK sharedSDK].account.serviceToken
                          completion:^(NSError *error, NSString *uid, NSDictionary *userInfo) {
                NSLog(@"long uid is %@", uid);
                [[KGUtil util] updateGameData];
                [[KGPayHelper help] setup];
            }];
        }
    };
    if ([KwaiGameSDK sharedSDK].account == nil) {
        if ([self firstAuthType:YES] == -1) {
            [self toast:@"请选择唯一一种登录方式"];
            return;
        }
        [[KwaiGameSDK sharedSDK] loginWithType:[self firstAuthType:YES] completion:completion];
    } else {
        [self toast:@"已经登录了"];
    }
}

- (void)logout {
    [[KwaiGameSDK sharedSDK] logoutWithCompletion:^(NSError *error) {
        [self updateUserInfo];
        if (error) {
            [self toast:[NSString stringWithFormat: @"%@(%ld)", error.errorMsg, error.code]];
        } else {
            [[KGUtil util] gameLogout];
            [self toast:@"退出成功"];
        }
    }];
}

- (void)getUserInfo {
    if ([KwaiGameSDK sharedSDK].account) {
        [[KwaiGameSDK sharedSDK] requestUserInfoWithCompletion:^(NSError *error, KwaiGameUser *user) {
            if (error) {
                [self toast:[NSString stringWithFormat: @"%@(%ld)", error.errorMsg, error.code]];
            } else {
                [self toast:[NSString stringWithFormat:@"%@", user]];
            }
        }];
    } else {
        [self toast:@"尚未登录"];
    }
}

- (void)doUserCert {
    if ([KwaiGameSDK sharedSDK].account) {
        [[KwaiGameSDK sharedSDK] certificateWithCompletion:^(BOOL certificated, NSError * _Nonnull error) {
            if (error) {
                if (error.localizedDescription.length > 0) {
                    [self toast:[NSString stringWithFormat: @"%@(%ld)", error.errorMsg, error.code]];
                } else {
                    [self toast:@"实名失败"];
                }
            } else {
                [self toast:@"实名成功"];
            }
        }];
    } else {
        [self toast:@"尚未登录"];
    }
}

- (void)openAccountManager {
    if ([KwaiGameSDK sharedSDK].account) {
        [[KwaiGameSDK sharedSDK] showAccountManager];
    } else {
        [self toast:@"尚未登录"];
    }
}

- (void)bind {
    void(^completion)(NSError *error,KwaiGameBindResult *bindResult) = ^(NSError *error,KwaiGameBindResult *bindResult) {
        if (error) {
            // 内部有Toast提示
//            [self toast:[NSString stringWithFormat: @"%@(%ld)", error.errorMsg, error.code]];
        } else {
            if (bindResult.nickName != nil) {
                [self toast:[NSString stringWithFormat:@"绑定成功(%@)", bindResult.nickName]];
            } else {
                [self toast:@"绑定成功"];
            }
        }
    };
    if (self.supportCustomLogin.isOn) {
        [[KwaiGameSDK sharedSDK] bindAccountBuildUIWithType:[self loginOption] completion:completion];
    } else {
        [[KwaiGameSDK sharedSDK] bindAccountUsingBuiltUIWithCompletion:completion];
    }
}

- (void)directBind {
    if ([self firstAuthType:NO] == -1) {
        [self toast:@"请选择唯一一种授权方式"];
        return;
    }
    [[KwaiGameSDK sharedSDK] bindAccountWithAuthType:[self firstAuthType:NO] completion:^(NSError *error,KwaiGameBindResult *bindResult) {
        if (error) {
            [self toast:[NSString stringWithFormat: @"%@(%ld)", error.errorMsg, error.code]];
        } else {
            if (bindResult.nickName != nil) {
                [self toast:[NSString stringWithFormat:@"绑定成功(%@)", bindResult.nickName]];
            } else {
                [self toast:@"绑定成功"];
            }
        }
    }];
}

- (void)switchAccount {
    void(^completion)(NSError *error) = ^(NSError *error) {
        if (error) {
            [self toast:[NSString stringWithFormat: @"%@(%ld)", error.errorMsg, error.code]];
        } else {
            [self toast:[KwaiGameSDK sharedSDK].account.uid];
            [[KGUtil util] gameLogin:[KwaiGameSDK sharedSDK].account.uid
                           gameToken:[KwaiGameSDK sharedSDK].account.serviceToken
                          completion:^(NSError *error, NSString *uid, NSDictionary *userInfo) {
                NSLog(@"long uid is %@", uid);
                [[KGPayHelper help] setup];
                [[KGUtil util] updateGameData];
                [self updateUserInfo];
            }];
        }
    };
    if (self.supportCustomLogin.isOn) {
        [[KwaiGameSDK sharedSDK] switchAccountUsingBuiltUIWithType:[self loginOption] completion:completion];
    } else {
        [[KwaiGameSDK sharedSDK] switchAccountUsingBuiltUIWithCompletion:completion];
    }
}

- (void)didChangedSupport:(id)sender {
    UISwitch *bt = (UISwitch *)sender;
    self.supportKwaiApp.superview.hidden = !bt.isOn;
    self.supportPhone.superview.hidden = !bt.isOn;
    self.supportGuest.superview.hidden = !bt.isOn;
    self.supportSIWA.superview.hidden = !bt.isOn;
    self.supportQQ.superview.hidden = !bt.isOn;
    self.supportWx.superview.hidden = !bt.isOn;
    self.supportQrCode.superview.hidden = !bt.isOn;
    self.supportGoogle.superview.hidden = !bt.isOn;
    self.supportFaceBook.superview.hidden = !bt.isOn;
    self.supportGameCenter.superview.hidden = !bt.isOn;
    
    bt.superview.hidden = bt.isOn;
}

- (void)updateGameData {
    [[KGUtil util] updateGameData];
    [self toast:[NSString stringWithFormat:@"%@", [KwaiGameSDK sharedSDK].gameData]];
}

- (void)updateUserInfo {
    if ([KwaiGameSDK sharedSDK].account != nil) {
        [[KwaiGameSDK sharedSDK] requestUserInfoWithCompletion:^(NSError *error, KwaiGameUser *user) {
            RUN_IN_MAIN_THREAD_START
            self.userNameLabel.text = user.name;
            NSString *loginName = [self loginTypeName:[KwaiGameSDK sharedSDK].account.lastLoginType];
            self.lastLoginTypeLabel.text = [NSString stringWithFormat:@"登录类型:%@",loginName];
            RUN_IN_MAIN_THREAD_END
        }];
    } else {
        self.userNameLabel.text = @"未登录";
        self.lastLoginTypeLabel.text = @"登录方式:未登录";
    }
}

- (void)copyUid:sender {
    if ([KwaiGameSDK sharedSDK].account == nil) {
        [self toast: @"拷贝失败: 未登录"];
    } else {
        [UIPasteboard generalPasteboard].string = [KwaiGameSDK sharedSDK].account.uid;
        [self toast: [NSString stringWithFormat: @"拷贝成功: %@", [KwaiGameSDK sharedSDK].account.uid]];
    }
}

- (void)showAnnouncement {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入要展示的公告类型" message:@"0:登录公告\n1:游戏公告" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertController.textFields.firstObject;
        NSString *typeStr = textField.text ?: @"";
        // 判断是否全为数字
        if ([typeStr stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length == 0) {
            NSInteger type = typeStr.integerValue;
            [[KwaiGameSDK sharedSDK] showGameNoticeDialogWithNoticeType:type];
        } else {
            [self.view makeToast:@"设置失败，请输入数字"];
            NSLog(@"设置失败，请输入数字");
        }
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"在这里输入公告类型";
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)getAnnouncementInfo {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"输入要展示的公告类型" message:@"0:登录公告\n1:游戏公告" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertController.textFields.firstObject;
        NSString *typeStr = textField.text ?: @"";
        // 判断是否全为数字
        if ([typeStr stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length == 0) {
            NSInteger type = typeStr.integerValue;
            [[KwaiGameSDK sharedSDK] getGameNoticeContentWithNoticeType:type success:^(NSInteger errorCode, NSString * _Nonnull errorMsg, NSString * _Nonnull data) {
                [self.view makeToast:data];
            } fail:^(NSInteger errorCode, NSString * _Nonnull errorMsg) {
                [self.view makeToast:[NSString stringWithFormat:@"获取失败errorCode: %ld, errorMsg: %@", (long)errorCode, errorMsg]];
            }];
        } else {
            [self.view makeToast:@"设置失败，请输入数字"];
            NSLog(@"设置失败，请输入数字");
        }
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"在这里输入公告类型";
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

#pragma mark -

- (NSString *)loginTypeName:(KwaiGameAuthType)authType {
    switch (authType) {
        case KwaiGameAuthTypeVisitor:
            return @"游客";
        case KwaiGameAuthTypeKwaiApp:
            return @"快手App";
        case KwaiGameAuthTypeKwaiWeb:
            return @"快手Web";
        case KwaiGameAuthTypeKwaiNative:
            return @"快手手机号";
        case KwaiGameAuthTypeAppleId:
            return @"苹果";
        case KwaiGameAuthTypeWx:
            return @"微信";
        case KwaiGameAuthTypeQQ:
            return @"QQ";
        case KwaiGameAuthTypePhone:
            return @"独立手机号";
        case KwaiGameAuthTypeQrCode:
            return @"二维码";
        case KwaiGameAuthTypeFacebook:
            return @"Facebook";
        case KwaiGameAuthTypeGoogle:
            return @"Google";
        case KwaiGameAuthTypeGameCenter:
            return @"GameCenter";
        default:
            return @"未知";
    }
}

@end
