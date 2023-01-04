//
//  KGKwaiJumpViewController.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/11/23.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "KGKwaiJumpViewController.h"
#import <KwaiGameSDK/NSError+KwaiGame+Public.h>
#import <KwaiGameSDK/KwaiGameSDK+KwaiJump.h>

#define kDemoTestFileName @"test.zip"
#define kDemoUpdateDuration (0.2f)      // 1s

@interface KGKwaiJumpViewController ()

@property (nonatomic, strong) UIButton *changeKeyButton;
@property (nonatomic, copy) NSString *jumpKey;

@property (nonatomic, weak) UITextField *serverInputTextField;
@property (nonatomic, weak) UITextField *levelInputTextField;


@end

@implementation KGKwaiJumpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(customParams)];
    self.changeKeyButton = [self addSubButton:@"设置Key" frame:CGRectMake(15, 200, 200, 30) selector:@selector(changeKey)];
    [self addSubButton:@"快跳" frame:CGRectMake(15, 200, 200, 30) selector:@selector(jump)];
    [self addSubButton:@"清除数据" frame:CGRectMake(15, 200, 200, 30) selector:@selector(resetData)];
    [self addSubButton:@"检查Key是否可用" frame:CGRectMake(15, 200, 200, 30) selector:@selector(checkKey)];
}

- (void)checkKey{
    if (self.jumpKey.length > 0){
        __weak typeof(self) weakSelf = self;
        [[KwaiGameSDK sharedSDK] checkJumpKeyEnable:self.jumpKey complete:^(BOOL enable) {
            [weakSelf toast:@"%@ %@",self.jumpKey,enable?@"可用":@"不可用"];
        }];
    }
}

- (void)jump {
    [[KwaiGameSDK sharedSDK] jump:self.jumpKey completion:^(KwaiJumpResultType code, NSString *msg) {
        GLOBAL_RUN_IN_MAIN_THREAD_AFTER_BEGIN(1.0f)
        if (code < 0) {
            if (code == KwaiJumpResultType_UserCancel) {
                [self toast:@"快跳取消"];
            } else {
                if (msg.length > 0) {
                    [self toast:@"%@", msg];
                } else {
                    [self toast:@"快跳失败:%@", msg];
                }
            }
        } else {
            if (code == KwaiJumpResultType_JumpInsideApp_NoNext) {
                [self showInAppJumpAlertNeedCallNext:NO message:msg];
            } else if (code == KwaiJumpResultType_JumpInsideApp_HasNext) {
                [self showInAppJumpAlertNeedCallNext:YES message:msg];
            } else {
                [self toast:@"快跳完成"];
            }
        }
        GLOBAL_RUN_IN_MAIN_THREAD_AFTER_END
    }];
}

- (void)showInAppJumpAlertNeedCallNext:(BOOL)isNeed message:(NSString *)msg{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"快跳InApp跳转处理" message:msg?:@"" preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:isNeed?@"后面还有图":@"后面没图了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (isNeed) {
            [self jump];
        }
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)changeKey {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置Key" message:[NSString stringWithFormat:@"当前Key:%@",self.jumpKey] preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertController.textFields.firstObject;
        if (textField.text.length) {
            self.jumpKey = textField.text;
        }
        if (self.jumpKey.length > 0) {
            [self.changeKeyButton setTitle:self.jumpKey forState:UIControlStateNormal];
        }
    }]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = self.jumpKey;
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)resetData {
    Class cls = NSClassFromString(@"KwaiGameJumpStore");
    if (cls != nil) {
        if ([cls respondsToSelector:@selector(resetData)]) {
            [cls performSelector:@selector(resetData)];
        }
    }
}


- (void)customParams {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof(self) weakSelf = self;
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"serverID";
        weakSelf.serverInputTextField = textField;
    }];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"user level";
        weakSelf.levelInputTextField = textField;
    }];
    
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[KwaiGameSDK sharedSDK] updateUserData:@{kLevel:weakSelf.levelInputTextField.text}];
        [[KwaiGameSDK sharedSDK] updateUserData:@{kServerId:weakSelf.serverInputTextField.text}];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}


@end
