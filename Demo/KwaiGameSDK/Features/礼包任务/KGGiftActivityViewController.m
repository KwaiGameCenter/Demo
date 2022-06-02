//
//  KGGiftActivityViewController.m
//  KwaiGameSDK_Example
//
//  Created by 刘玮 on 2020/5/21.
//  Copyright © 2020 mookhf. All rights reserved.
//

#import "KGGiftActivityViewController.h"
#import <KwaiGameSDK/KwaiGameSDK.h>
#import <KwaiGameSDK/KwaiGameSDK+GiftActivity.h>

@interface KGGiftActivityViewController ()

@property (nonatomic, strong) UIButton *bindButton;

@end

@implementation KGGiftActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addSpliteLine:@"绑定手机号领取礼包" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];
    self.bindButton = [self addSubButton:@"绑定并领取" frame:CGRectMake(0, 260, 200, 30) selector:@selector(bindForGift)];
    [[KwaiGameSDK sharedSDK] checkGiftActivityStatus:KwaiGameGiftActivityType_BindPhone
                                          completion:^(NSError * _Nonnull error, BOOL result,BOOL isResend) {
        if (error) {
            GLOBAL_RUN_IN_MAIN_THREAD_START
            self.bindButton.enabled = NO;
            [self.bindButton setTitle:@"未开启" forState:UIControlStateNormal];
            GLOBAL_RUN_IN_MAIN_THREAD_END
        }
        if (result) {
            GLOBAL_RUN_IN_MAIN_THREAD_START
            self.bindButton.enabled = NO;
            if (isResend) {
                [self toast:@"补发成功"];
            }
            [self.bindButton setTitle:@"已领取" forState:UIControlStateNormal];
            GLOBAL_RUN_IN_MAIN_THREAD_END
        }
    }];
}

- (void)bindForGift {
    [[KwaiGameSDK sharedSDK] bindAccountWithAuthType:KwaiGameAuthTypePhone completion:^(NSError *error,KwaiGameBindResult *bindResult) {
        GLOBAL_RUN_IN_MAIN_THREAD_START
        if (error) {
            [self toast:error.localizedDescription];
        } else {
            GLOBAL_RUN_IN_MAIN_THREAD_AFTER_BEGIN(1.0f)
            if (bindResult.nickName != nil) {
                [self toast:[NSString stringWithFormat:@"绑定成功(%@)", bindResult.nickName]];
            } else {
                [self toast:@"绑定成功"];
            }
            GLOBAL_RUN_IN_MAIN_THREAD_AFTER_END
            self.bindButton.enabled = NO;
            [self.bindButton setTitle:@"已领取" forState:UIControlStateNormal];
        }
        GLOBAL_RUN_IN_MAIN_THREAD_END
    }];
}

@end

