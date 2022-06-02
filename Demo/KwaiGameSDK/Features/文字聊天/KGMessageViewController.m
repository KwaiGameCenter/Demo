//
//  KGMessageViewController.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/12/6.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "KGMessageViewController.h"
#import <KwaiGameSDK-IM/KwaiGameIMManager.h>
#import "UIViewController+DemoSupport.h"
#import "KGSessionListViewController.h"
#import "KGUtil.h"
#import <KwaiGameSDK-IM/KwaiIMSDKConfig.h>

@interface KGMessageViewController ()
@property (nonatomic, strong) UILabel *uidLabel;
@end

@implementation KGMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self addSubButton:@"登录IMSDK" frame:CGRectMake(0, 130, 200, 40) selector:@selector(login)];
    self.uidLabel = [self addSubLabel:[KGUtil util].uid frame:CGRectMake(0, 180, 200, 40)];
}

- (void)login {
    [[KwaiGameIMManager sharedManager] loginWithUserId:[KGUtil util].uid completion:^(NSError *error) {
        if (error) {
            [self toast:error.localizedDescription];
        } else {
            [self.navigationController pushViewController:[KGSessionListViewController new] animated:YES];
        }
    }];
}

@end
