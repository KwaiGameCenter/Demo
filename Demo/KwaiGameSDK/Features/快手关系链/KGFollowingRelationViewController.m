//
//  KGFollowingRelationViewController.m
//  KwaiGameSDK_Example
//
//  Created by 刘玮 on 2019/8/13.
//  Copyright © 2019 mookhf. All rights reserved.
//

#import "KGFollowingRelationViewController.h"
#import "KGTokenHelper.h"
#import "UIViewController+DemoSupport.h"
#import <KwaiGameSDK/KwaiGameSDK.h>
#import <KwaiGameSDK-Relation/KwaiGameRelation.h>
#import <KwaiGameSDK-Relation/KSApiObject.h>
#import "NSError+KwaiBase.h"
#import "UIView+Toast.h"
#import "KGUtil.h"
#import "KGPayHelper.h"
#import "UIImageView+WebCache.h"

#define TOAST(message) [[UIApplication sharedApplication].keyWindow makeToast: message];

#define GR_RUN_IN_MAIN_THREAD_START dispatch_async(dispatch_get_main_queue(), ^{
#define GR_RUN_IN_MAIN_THREAD_END });

@interface KGFollowingRelationViewController ()<UITableViewDataSource, UITableViewDelegate, KwaiGameRelationDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray<NSDictionary *> *followingUserInfo;

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, strong) KwaiGameAccount *account;

@end

@implementation KGFollowingRelationViewController

- (void)setAppId:(NSString *)appId account:(KwaiGameAccount *)account {
    _appId = appId;
    _account = account;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.appId.length <= 0) {
        self.appId = [KwaiGameSDK sharedSDK].appId;
    }
    
    if (self.account == nil) {
        self.account = [KwaiGameSDK sharedSDK].account;
    }
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self syncDataFromServer];
    [KwaiGameRelation relation].delegate = self;
    [[KwaiGameSDK sharedSDK] log:@"快手关系链SDK Version:"];
    [[KwaiGameSDK sharedSDK] log:[[KwaiGameRelation relation]apiVersion]];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: NSStringFromClass(UITableViewCell.class)];
    if (indexPath.row < self.followingUserInfo.count) {
        NSDictionary *userInfo = self.followingUserInfo[indexPath.row];
        cell.textLabel.text = userInfo[@"user_name"];
        cell.detailTextLabel.text = [userInfo[@"user_gender"] isEqualToString: @"M"] ? @"男生" : @"女生";
    } else {
        cell.textLabel.text = nil;
        cell.imageView.image = nil;
        cell.detailTextLabel.text = nil;
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.followingUserInfo.count;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: true];
    if (indexPath.row < self.followingUserInfo.count) {
        NSDictionary *userInfo = self.followingUserInfo[indexPath.row];
        [[KwaiGameRelation relation] transformGameIds: @[self.account.uid , userInfo[@"game_id"]]
                                                appId: self.appId
                                              account: self.account
                                           completion: ^(NSError * error, NSDictionary<NSString *,NSString *> * openIdsMap) {
                                               if (error) {
                                                   GR_RUN_IN_MAIN_THREAD_START
                                                   [self.view makeToast: [NSString stringWithFormat: @"error code: %ld", (long)error.code]];
                                                   GR_RUN_IN_MAIN_THREAD_END
                                                   return;
                                               }
                                               GR_RUN_IN_MAIN_THREAD_START
                                               if (indexPath.row % 2 == 0) {
                                                   KSShowProfileRequest *request = [[KSShowProfileRequest alloc] init];
                                                   request.openID = openIdsMap[self.account.uid];
                                                   request.targetOpenID = openIdsMap[userInfo[@"game_id"]];
                                                   [[KwaiGameRelation relation] sendRequest: request];
                                               } else {
                                                   KSShareMessageRequest* req = [[KSShareMessageRequest alloc] init];
                                                   req.openID = openIdsMap[self.account.uid];
                                                   req.receiverOpenID = openIdsMap[userInfo[@"game_id"]];
                                                   
                                                   KSShareWebPageObject* shareObj = [KSShareWebPageObject new] ;
                                                   shareObj.title = [NSString stringWithUTF8String:"title"];
                                                   shareObj.desc = [NSString stringWithUTF8String:"des"];
                                                   shareObj.linkURL = [NSString stringWithUTF8String:"https://www.baidu.com"];
//                                                   shareObj.thumbImage = nil;
                                                   req.shareObject = shareObj;
                                                   [[KwaiGameRelation relation] sendRequest: req];
                                               }
                                               GR_RUN_IN_MAIN_THREAD_END
        }];
    }
}

- (void)syncDataFromServer {
    // 测试接口，请勿调用
    [KGTokenHelper requestFollowingRelation: self.appId
                                     gameId: self.account.uid
                                  gameToken: self.account.serviceToken
                                 completion: ^(NSError *error, NSDictionary *dictionary) {
                                     if (error != nil) {
                                         GR_RUN_IN_MAIN_THREAD_START
                                         if (error.code == 100201001) {
                                             UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"提示"
                                                                                                                      message: @"调用快手授权以获取关系链使用权限"
                                                                                                               preferredStyle: UIAlertControllerStyleAlert];
                                             UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                 [KwaiGameSDK sharedSDK].config.moreScopes = @[@"following",@"relation"];           // 需要扩展支持的Scopes
                                                 [[KwaiGameSDK sharedSDK] bindAccountWithAuthType:KwaiGameAuthTypeKwaiApp completion:^(NSError *error,KwaiGameBindResult *bindResult) {
                                                     if (error) {
                                                         [self.view toast:error.localizedDescription];
                                                     } else {
                                                         if (error) {
                                                             [self.view toast:error.localizedDescription];
                                                         } else {
                                                             [self.view toast:[KwaiGameSDK sharedSDK].account.uid];
                                                             [[KGUtil util] gameLogin:[KwaiGameSDK sharedSDK].account.uid
                                                                            gameToken:[KwaiGameSDK sharedSDK].account.serviceToken
                                                                           completion:^(NSError *error, NSString *uid, NSDictionary *userInfo) {
                                                                 NSLog(@"long uid is %@", uid);
                                                                 [self syncDataFromServer];
                                                                 [[KGPayHelper help] setup];
                                                                 [[KGUtil util] updateGameData];
                                                             }];
                                                         }
                                                     }
                                                 }];
                                             }];
                                             [alertController addAction:confirmAction];
                                             [self presentViewController:alertController animated:YES completion:nil];
                                         } else {
                                             TOAST(([NSString stringWithFormat: @"[%ld]%@", (long)error.code, error.errorMsg]));
                                         }
                                         GR_RUN_IN_MAIN_THREAD_END
                                         return;
                                     }
                                     GR_RUN_IN_MAIN_THREAD_START
                                     self.followingUserInfo = dictionary[@"followings"];
                                     [self.tableView reloadData];
                                     GR_RUN_IN_MAIN_THREAD_END
                                 }];
}
    
#pragma mark - KwaiGameRelationDelegate
    
- (void)didReceiveResponse:(__kindof KSBaseResponse *)response {
    GR_RUN_IN_MAIN_THREAD_START
    if (response.error.code != 1) {
        [self.view makeToast: [NSString stringWithFormat: @"error code:%@(%ld)", response.error, (long)response.error.code]];
    } else {
        [self.view makeToast: @"success"];
    }
    GR_RUN_IN_MAIN_THREAD_END
}

@end
