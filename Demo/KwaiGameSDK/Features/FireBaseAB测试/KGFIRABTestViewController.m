//
//  KGFIRABTestViewController.m
//  KwaiGameSDK_Example
//
//  Created by ljw on 2021/12/6.
//  Copyright © 2021 mookhf. All rights reserved.
//

#import "KGFIRABTestViewController.h"
#import "UIViewController+DemoSupport.h"
#import "KwaiGameSDK-ABtest-Firebase/KwaiFIRABtestManager.h"
#import "UIView+Toast.h"
#import "MLCCommand.h"

@interface KGFIRABTestViewController ()

@end

@implementation KGFIRABTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addSpliteLine:@"基础设置" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];
    
    [self addSubButton:@"设置拉取间隔" frame:CGRectMake(0, 80, 200, 30) selector:@selector(configFetchInterval)];
    
    [self addSubButton:@"设置默认配置" frame:CGRectMake(0, 80, 200, 30) selector:@selector(setDefaultDic)];
    
    [self addSpliteLine:@"拉取相关" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];
    
    [self addSubButton:@"拉取远端配置" frame:CGRectMake(0, 80, 200, 30) selector:@selector(fetchFirebaseABtest)];
    
    [self addSubButton:@"获取指定key数据" frame:CGRectMake(0, 80, 200, 30) selector:@selector(getFirebaseABtestValueForKey)];
    
    [self addSubButton:@"输出全部配置" frame:CGRectMake(0, 80, 200, 30) selector:@selector(getAllFirebaseABtestDic)];
    
}

- (void)configFetchInterval {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入拉取间隔(单位:秒)" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *keyTextField = alertController.textFields.firstObject;
        NSString *timeStr = keyTextField.text ?: @"";
        // 判断是否全为数字
        if ([timeStr stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length == 0) {
            NSInteger time = timeStr.integerValue;
            if (time >= 0) {
                [[KwaiFIRABtestManager sharedManager] setRemoteFetchIntervalInSeconds:time];
                [self.view makeToast:@"设置成功！"];
                NSLog(@"设置成功!");
            } else {
                [self.view makeToast:@"设置失败，间隔需大于0"];
                NSLog(@"设置失败，间隔需大于0");
            }
        } else {
            [self.view makeToast:@"设置失败，请输入数字"];
            NSLog(@"设置失败，请输入数字");
        }

    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"在这里输入时间（单位:秒）";
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)setDefaultDic {
    NSMutableDictionary *defaultTestDic = [[NSMutableDictionary alloc] init];
    [defaultTestDic setValue:@666 forKey:@"testNumber"];
    [defaultTestDic setValue:@"test" forKey:@"testString"];
    [defaultTestDic setValue:@YES forKey:@"testBOOL"];
    [[KwaiFIRABtestManager sharedManager] setRemoteDefaultsValues:defaultTestDic];
    [self.view makeToast:[NSString stringWithFormat:@"默认值已设置: %@", defaultTestDic]];
    NSLog(@"默认值已设置: %@", defaultTestDic);
}

- (void)fetchFirebaseABtest {
    [[KwaiFIRABtestManager sharedManager] remoteFetchAndActivehWithCompletion:^(BOOL isSuccess, BOOL isUpdated, NSError * _Nullable error) {
        RUN_IN_MAIN_THREAD_START
        [self.view makeToast:[NSString stringWithFormat:@"拉取结果: %@, 激活结果(配置是否改动): %@", isSuccess? @"成功":@"失败", isUpdated? @"是":@"否"]];
        NSLog(@"拉取结果: %@, 激活结果(配置是否改动): %@", isSuccess? @"成功":@"失败", isUpdated? @"是":@"否");
        RUN_IN_MAIN_THREAD_END
    }];
}

- (void)getFirebaseABtestValueForKey {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入要获取的key值" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *keyTextField = alertController.textFields.firstObject;
        NSString *key = keyTextField.text ?: @"";
        NSString *result = [[KwaiFIRABtestManager sharedManager] getRemoteConfigConfigValue:key];
        if (!result || [result isEqualToString:@""]) {
            result = @"未找到输入key对应结果！";
        }
        [self.view makeToast:result];
        NSLog(@"结果输出: %@", result);
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"在这里输入key值";
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)getAllFirebaseABtestDic {
    NSDictionary *result = [[KwaiFIRABtestManager sharedManager] getRemoteConfigAllValues];
    if (!result || [result isEqual: @{}]) {
        [self.view makeToast:@"获取配置为空"];
        NSLog(@"结果输出: 获取配置为空");
    }
    [self.view makeToast:[result description]];
    NSLog(@"结果输出: %@", result);
}

@end
