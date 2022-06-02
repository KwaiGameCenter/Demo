//
//  KGPromotionADViewController.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/11/23.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "KGPromotionADViewController.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h""
#import <KwaiGameSDK-AppBox/KwaiGameSDK+AppBox.h>
#import <KwaiGameSDK-AppBox/KwaiAppBox.h>
#import <KwaiGameSDK-AppBox/KwaiAppTask.h>
#import "KwaiBase.h"

DescClass(KwaiAppTask);

@interface KGPromotionADViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<KwaiAppTask *> *tasks;
 
@end

@implementation KGPromotionADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubView:self.tableView frame:CGRectMake(0.0f, 0.0f, DemoUIScreenWidth, DemoUIScreenHeight)];
    [[KwaiGameSDK sharedSDK] getMultiPromotionTasks:10 completion:^(NSArray<KwaiAppTask *> * _Nonnull tasks) {
        DemoRunInMainThreadStart
        if (tasks.count <= 0) {
            [self toast:@"当前没有任务"];
            return;
        }
        self.tasks = tasks;
        [self.tableView reloadData];
        DemoRunInMainThreadEnd
    }];
}

#pragma mark - UI

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: NSStringFromClass(UITableViewCell.class)];
    if (indexPath.row < self.tasks.count) {
        KwaiAppTask *task = self.tasks[indexPath.row];
        cell.textLabel.text = task.appName;
        cell.detailTextLabel.text = task.appDesc;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:task.icon] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [cell setNeedsLayout];
        }];
        [[KwaiGameSDK sharedSDK] taskPromotionExposure:KwaiAppBoxExposureStyle_List task:task];
    } else {
        cell.textLabel.text = nil;
        cell.imageView.image = nil;
        cell.detailTextLabel.text = nil;
        [cell.imageView sd_cancelCurrentImageLoad];
        cell.imageView.image = nil;
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: true];
    if (indexPath.row < self.tasks.count) {
        KwaiAppTask *task = self.tasks[indexPath.row];
        [[KwaiGameSDK sharedSDK] doPromotionTask:task];
        [[KwaiGameSDK sharedSDK] log:@"%@",task];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
      return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(copy:)) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    if (action == @selector(copy:)) {
        if (indexPath.row < self.tasks.count) {
            KwaiAppTask *task = self.tasks[indexPath.row];
            [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"%@",task];
        }
    }
}
 
@end
