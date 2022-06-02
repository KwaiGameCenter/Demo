//
//  KGABTestViewController.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/12/14.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "KGABTestViewController.h"
#import "UIViewController+DemoSupport.h"
#import <KwaiGameSDK/KwaiGameSDK.h>

@interface KGABTestViewController ()<UITextFieldDelegate, KwaiGameABTestDelegate>
@property (nonatomic, strong) UITextField *keyFiled;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *abtestLabel;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UITextView *immediateLabel;
@end

@implementation KGABTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.keyFiled = [[UITextField alloc] initWithFrame:CGRectMake(30, 80, 200, 50)];
    self.keyFiled.backgroundColor = [UIColor grayColor];
    self.keyFiled.returnKeyType = UIReturnKeyDone;
    self.keyFiled.delegate = self;
    [self.view addSubview:self.keyFiled];
    
    self.submitBtn = [self addSubButton:@"查询" frame:CGRectMake(0, 80, 100, 50) selector:@selector(search)];
    self.submitBtn.left = self.keyFiled.right + 10;
    self.resultLabel = [self addSubLabel:@"" frame:CGRectMake(0, 140, 310, 50)];
    self.resultLabel.left = 30;
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(30, 200, 310, 300)];
    self.textView.backgroundColor = [UIColor grayColor];
    self.textView.editable = NO;
    [self.textView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(update)]];
    [self.view addSubview:self.textView];
    
    self.abtestLabel = [self addSubLabel:@"" frame:CGRectMake(30, 510, 310, 50)];
    self.abtestLabel.left = 30;
    
    self.immediateLabel = [[UITextView alloc] initWithFrame:CGRectMake(30, 570, 310, 100)];
    self.immediateLabel.editable = NO;
    self.immediateLabel.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.immediateLabel];
    
    [[KwaiGameSDK sharedSDK] setABTestDelegate:self];
    [self update];
}

- (void)search {
    if (self.keyFiled.text.length <= 0) {
        [self toast:@"请输入key"];
        return;
    }
    id result = [[[KwaiGameSDK sharedSDK] abtest] testValueForKey:self.keyFiled.text];
    self.resultLabel.text = [NSString stringWithFormat:@"%@", result?:@"没有找到key"];
}

- (void)update {
    BOOL abtestEnable = [[[KwaiGameSDK sharedSDK] abtest] abTestEnable];
//    NSDictionary *dict = [[KwaiGameSDK sharedSDK] allLocalConfig];
    self.abtestLabel.text = [NSString stringWithFormat:@"abtest开关：%@", abtestEnable?@"开":@"关"];
//    self.textView.text = [NSString stringWithFormat:@"%@", dict?:@""];
}

- (void)addEffectiveImmediatelyKey:(NSArray<NSString *> *)keys {
    self.immediateLabel.text = [NSString stringWithFormat:@"%@", keys.count > 0 ? keys : @""];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

@end
