//
//  KGWithdrawViewController.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2020/3/23.
//  Copyright © 2020 mookhf. All rights reserved.
//

#import "KGWithdrawViewController.h"
#import <KwaiGameSDK-Withdraw/KwaiGameSDK+Withdraw.h>
#import "UIViewController+DemoSupport.h"

@interface KGWithdrawViewController ()

@end

@implementation KGWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addSubButton:@"提现入口" frame:CGRectMake(0, 20, 200, 40) selector:@selector(withdraw)];
    [self addSubButton:@"提现历史列表" frame:CGRectMake(0, 80, 200, 40) selector:@selector(withdrawList)];
    
    [KwaiGameSDK registerWechatAppID:@"wx480780df0cd0d404" universalLink:@"https://linkxxdrzjb.gamekuaishou.com/kwaiapp/"];
}

- (void)withdraw {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入提现金额" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *amountTextField = alertController.textFields.firstObject;
        int amout = [amountTextField.text intValue];
        [KwaiGameSDK withdraw:self accountKey:@"GAME_XXDR" money:amout params:@{} completion:^(NSError *error) {
            if (error) {
                if (error.localizedDescription.length) {
                    [self toast:error.localizedDescription];
                } else {
                    [self toast:@"取消提现"];
                }
            } else {
                [self toast:@"提现成功"];
            }
        }];
    }]];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"提现金额(单位：分)，可不填";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)withdrawList {
    [KwaiGameSDK withdrawList:self accountKey:@"GAME_XXDR" completion:^(NSError *error) {
        if (error.localizedDescription.length) {
            [self toast:error.localizedDescription];
        }
    }];
}


@end
