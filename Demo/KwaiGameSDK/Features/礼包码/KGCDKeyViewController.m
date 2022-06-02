//
//  KGCDKeyViewController.m
//  KwaiGameSDK_Example
//
//  Created by 刘玮 on 2019/7/10.
//  Copyright © 2019 mookhf. All rights reserved.
//

#import "KGCDKeyViewController.h"
#import "KGTokenHelper.h"
#import "UIView+Toast.h"
#import "KwaiBase.h"
#import "NSError+KwaiBase.h"

@interface KGCDKeyViewController()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *cdkeyInput;
@property (weak, nonatomic) IBOutlet UITextField *roleNameInput;
@property (weak, nonatomic) IBOutlet UITextField *serverNameInput;

@end

@implementation KGCDKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cdkeyInput.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)vertifyAction: (id)sender {
    if (self.cdkeyInput.text.length <= 0) {
        [self.view makeToast: @"激活码不合法!!!"];
        return;
    }
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:@{@"cdkey": self.cdkeyInput.text}];
    
    if (self.roleNameInput.text.length > 0 && self.serverNameInput.text.length > 0) {
        [paramsDic addEntriesFromDictionary:@{@"role_id":self.roleNameInput.text,
                                    @"server_name":self.serverNameInput.text}];
        
        [self.view makeToast:[[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:paramsDic options:NSJSONWritingPrettyPrinted error:nil]encoding:kCFStringEncodingUTF8]];
    }
    
    
    // 服务器接口，请勿调用
    [KGTokenHelper vertifyCDKey:paramsDic completion: ^(NSError *error, NSDictionary *result) {
        RUN_IN_MAIN_THREAD_START
        UIView *view = self.view;
        if (error) {
            [view makeToast: [NSString stringWithFormat: @"%@(%ld)", error.errorMsg, error.code]];
            return;
        }
        if (result != nil) {
            [view makeToast: [NSString stringWithFormat: @"%@", result]];
        }
        RUN_IN_MAIN_THREAD_END
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn: (UITextField *)textField {
    [textField resignFirstResponder];
    [self vertifyAction: nil];
    return YES;
}

@end
