//
//  KGPerformanceReportExpandInfoViewController.m
//  KwaiGameSDK_Example
//
//  Created by yan long on 2022/9/19.
//  Copyright © 2022 mookhf. All rights reserved.
//

#import "KGPerformanceReportExpandInfoViewController.h"
#import <Masonry/Masonry.h>

@interface KGPerformanceReportExpandInfoViewController ()

@property (nonatomic, weak) UITextView  *expandTextView;

@end

@implementation KGPerformanceReportExpandInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Expand Report";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(handleDone)];
    
    
    UITextView *expandTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 300)];
    expandTextView.backgroundColor = [UIColor grayColor];
    expandTextView.text = @"{\"drawCalls\":\"200\"}";
    self.expandTextView = expandTextView;
    [self.view addSubview:expandTextView];
    
    [expandTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(300);
    }];
    
}

- (void)handleDone {
    
    NSString *jsonString = self.expandTextView.text;
    if (self.reportExpandInfo){
        self.reportExpandInfo(jsonString);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
