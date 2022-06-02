//
//  KGSessionListViewController.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/12/6.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "KGSessionListViewController.h"
#import <KwaiGameSDK-IM/KwaiIMManager.h>
#import <KwaiGameSDK-IM/KwaiIMConversation.h>
#import <KwaiGameSDK-IM/KwaiIMMessage.h>
#import <KwaiGameSDK-IM/KwaiIMManager+Channel.h>
#import "KGSessionListCell.h"
#import "KGSessionDetailViewController.h"
#import "KwaiHelper.h"

@interface KGSessionListViewController ()<KwaiIMManagerStatusChangeDelegate, KwaiIMManagerConversationDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray<KwaiIMConversation *> *dataSource;
@property (nonatomic, strong) NSString *pid;
@end

@implementation KGSessionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *createButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [createButton setTitle:@"+" forState:UIControlStateNormal];
    [createButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [createButton addTarget:self action:@selector(addNewConversation:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *createItem = [[UIBarButtonItem alloc]initWithCustomView:createButton];
    
    UIButton *refreshButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [refreshButton setTitle:@"↩︎" forState:UIControlStateNormal];
    [refreshButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(reloadConversations:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc]initWithCustomView:refreshButton];
    
    self.navigationItem.rightBarButtonItems = @[createItem, refreshItem];
    
    [self.tableView registerClass:[KGSessionListCell class] forCellReuseIdentifier:@"KwaiMessageListCell"];
    
    [KwaiIMManager addConnectionDelegate:self delegateQueue:dispatch_get_main_queue()];
    [[KwaiIMManager sharedManager] addConversationDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [self reloadConversations:nil];
}

- (void)dealloc {
    [[KwaiIMManager sharedManager] removeConversationDelegate:self];
    [KwaiIMManager removeConnectionDelegate:self];
}

#pragma mark - KwaiIMManagerConnectionDelegate

- (void)manager:(nonnull KwaiIMManager *)manager connectStateDidChange:(KwaiIMConnectState)state {
    NSLog(@"Connection status %ld", (long)state);
    if (state == KwaiIMConnectStateConnected) {
        [self reloadConversations:nil];
    }
}

- (void)addNewConversation:(UIButton *)sender {
    UIAlertController *menuController = [UIAlertController alertControllerWithTitle:@"选择聊天类型" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    NSArray<NSString *> *items = @[@"P2P",
                                   @"Channel"];
    for(NSString *title in items){
        UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SEL sel = NSSelectorFromString([NSString stringWithFormat:@"create%@Conversation",title]);
            ((void (*)(id, SEL))[self methodForSelector:sel])(self, sel);
        }];
        [menuController addAction:action];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [menuController addAction:cancel];
    
    [self presentViewController:menuController
                       animated:YES
                     completion:nil];
}

- (void)createP2PConversation{
    [KwaiHelper showInputAlertWithPlaceholder:@"Please input Conversation/User ID" text:@"" handler:self completion:^(NSString * _Nonnull textString) {
        if (textString.length > 0) {
            KwaiIMConversation *conversation = [KwaiIMConversation new];
            conversation.conversationID = textString;
            conversation.type = KwaiIMConversationTypeSingle;
            KGSessionDetailViewController *vc = [KGSessionDetailViewController new];
            vc.conversation = conversation;
            [self.navigationController pushViewController:vc animated:true];
        }
    } cancelBlock:nil];
}

- (void)createChannelConversation{
    [KwaiHelper showInputAlertWithPlaceholder:@"Please input Channel ID" text:@"" handler:self completion:^(NSString *textString) {
        if(textString.length >= 1){
            NSString *channelId = textString;
            [[KwaiIMManager sharedManager] subscribeChannel:channelId completionBlock:^(NSError * _Nullable error) {
                if(!error){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        KwaiIMConversation *conversation = [KwaiIMConversation new];
                        conversation.conversationID = channelId;
                        conversation.type = KwaiIMConversationTypeChannel;
                        KGSessionDetailViewController *vc = [KGSessionDetailViewController new];
                        vc.conversation = conversation;
                        [self.navigationController pushViewController:vc animated:true];
                    });
                }
            }];
        }
    } cancelBlock:nil];
}

- (void)reloadConversations:(id)sender {
    [[KwaiIMManager sharedManager] fetchConversationListWithParentConversationID:self.pid countLimit:0 resultBlock:^(NSArray<KwaiIMConversation *> * _Nullable conversations, NSError * _Nullable error, BOOL isLoadedToEnd) {
        if (error == nil) {
            for (KwaiIMConversation *conversation in conversations) {
                [self insertOrUpdateConversation:conversation];
            }
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - KwaiIMManagerConversationDelegate

- (void)manager:(KwaiIMManager *)manager didUpdateConversations:(NSArray<KwaiIMConversation *> *)conversations parentConversationId:(NSString *)pConversationId {
    for (KwaiIMConversation *conversation in conversations) {
        [self insertOrUpdateConversation:conversation];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)manager:(KwaiIMManager *)manager didRemoveConversations:(NSArray<KwaiIMConversation *> *)conversations parentConversation:(NSString *)pConversationId {
    for (KwaiIMConversation *conversation in conversations) {
        if ([self.dataSource containsObject:conversation]) {
            [self.dataSource removeObject:conversation];
        }
    }
    [self.tableView reloadData];
}

- (void)manager:(KwaiIMManager *)manager didReloadWithNewConversations:(NSArray<KwaiIMConversation *> *)conversations parentConversation:(NSString *)pConversationId {
    if (![self.pid isEqualToString:pConversationId]) {
        return;
    }
    [self.dataSource removeAllObjects];
    for (KwaiIMConversation *conversation in conversations) {
        [self insertOrUpdateConversation:conversation];
    }
    [self.tableView reloadData];
}

- (void)insertOrUpdateConversation:(KwaiIMConversation *)conversation {
    if (conversation == nil) {
        return;
    }
    if (self.dataSource.count == 0) {
        [self.dataSource addObject:conversation];
        return;
    }
    NSInteger index = [self.dataSource indexOfObject:conversation];
    if(index != NSNotFound) {
        [self.dataSource removeObjectAtIndex:index];
    }
    
    if (![conversation.parentConversationID isEqualToString:self.pid]){
        // thread category change , just remove
        return;
    }
    
    NSComparator comparator =  ^(id obj1,id obj2){
        return [obj2 compare:obj1];
    };
    // 二分查找插入位置,保证有序性
    NSInteger newIndex = [self.dataSource indexOfObject:conversation
                                          inSortedRange:NSMakeRange(0,self.dataSource.count)
                                                options:NSBinarySearchingInsertionIndex | NSBinarySearchingFirstEqual
                                        usingComparator:comparator];
    [self.dataSource insertObject:conversation atIndex:newIndex];
}

#pragma mark - UITableViewDataSource

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"delete";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    KwaiIMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    [[KwaiIMManager sharedManager] deleteConversation:conversation
                                    completionBlock:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KGSessionListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KwaiMessageListCell"];
    KwaiIMConversation *conversation = self.dataSource[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.conversation = conversation;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    KwaiIMConversation *conversation = self.dataSource[indexPath.row];
    KGSessionDetailViewController *vc = [KGSessionDetailViewController new];
    vc.conversation = conversation;
    [self.navigationController pushViewController:vc animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (NSMutableArray<KwaiIMConversation *> *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSString *)pid {
    return @"0";
}

@end
