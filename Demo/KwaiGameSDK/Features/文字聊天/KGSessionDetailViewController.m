//
//  KGSessionDetailViewController.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/12/6.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "KGSessionDetailViewController.h"
#import <KwaiGameSDK-IM/KwaiIMConversation.h>
#import <KwaiGameSDK-IM/KwaiIMManager.h>
#import <KwaiGameSDK-IM/KwaiIMMessage.h>
#import <KwaiGameSDK-IM/KwaiIMTextMessage.h>
#import <KwaiGameSDK-IM/KwaiIMImageMessage.h>
#import <KwaiGameSDK-IM/KwaiIMEmotionMessage.h>
#import <KwaiGameSDK-IM/KwaiIMVideoMessage.h>
#import "KGImagePickerController.h"
#import "KGUtil.h"
#import <KwaiGameSDK-IM/KwaiIMManager+Channel.h>
#import "KwaiHelper.h"
#import "KSMsgContentLogicController.h"
#import "KGMessageTextCell.h"
#import "KGMessageCellFactory.h"
#import "KSMessageKeyboardBar.h"
#import "UIViewController+DemoSupport.h"

static NSInteger const kKWAI_MESSAGE_UNREADLIMIT = 10;

@interface KGSessionDetailViewController ()
<UITableViewDelegate,
UITableViewDataSource,
KwaiMessageCellLongPressDelegate,
KSMsgContentLogicControllerDelegate,
KGImagePickerControllerDelegate,
UITextFieldDelegate,
KSMessageKeyboardBarActionDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KSMsgContentLogicController *logicController;
@property (nonatomic, strong) KSMessageKeyboardBar *keyboardBar;

@property (nonatomic, strong) UIButton *jumpToUnreadButton;

@end

@implementation KGSessionDetailViewController

#pragma mark - life cycle

- (void)dealloc {
    // 退出聊天室
    // 1. 取消频道订阅
    // 2. 删除聊天室会话
    if(self.conversation.type == KwaiIMConversationTypeChannel){
        [[KwaiIMManager sharedManager] unSubscribeChannel:self.conversation.conversationID completionBlock:^(NSError * _Nullable error) {
            
        }];
        
        [[KwaiIMManager sharedManager] deleteConversation:self.conversation completionBlock:^(NSError * _Nullable error) {
            
        }];
    }
    _logicController.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.logicController = [[KSMsgContentLogicController alloc] initWithSession:self.conversation];
    self.logicController.delegate = self;
    [self.logicController setup];
    if (self.conversation) {
        self.title = self.conversation.conversationID;
        [self reloadMessages:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.conversation syncDraft];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat tableViewY = self.navigationController.navigationBar.bottom;
    self.tableView.frame = CGRectMake(0, tableViewY, self.view.width, self.view.height - tableViewY - self.keyboardBar.height);
    CGFloat unreadWidth = 150;
    self.jumpToUnreadButton.frame = CGRectMake(self.view.width - unreadWidth + 20.0, self.navigationController.navigationBar.bottom + 50, unreadWidth, 40);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.logicController clearUnreadCount];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.logicController.getMessagesCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KwaiIMMessage *message = [self.logicController getMessageAtIndex:indexPath.row];
    KGMessageBaseCell *cell = [KGMessageCellFactory messageCellWithTableView:tableView message:message];
    cell.cellDelegate = self;
    cell.message = message;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    KwaiIMMessage *message = [self.logicController getMessageAtIndex:indexPath.row];
    KGMessageBaseCell *cell = [KGMessageCellFactory messageCellWithTableView:tableView message:message];
    return [cell.class contentSizeWithMessage:message].height;
}

#pragma mark - actions

- (void)jumpToUnreadIfNeeded {
    NSArray *visibleCells = self.tableView.visibleCells;
    if (visibleCells.count < self.conversation.unreadCount && self.conversation.unreadCount > kKWAI_MESSAGE_UNREADLIMIT) {
        [self showUnreadButton];
    } else {
        [self hideUnreadButton];
    }
}

- (IBAction)reloadMessages:(id)sender {
    [self.logicController loadInitialMessagesWithCount:100];
}

- (void)deleteAllMessages {
    [self.logicController removeCurrentSession];
}

- (void)sendTextMessage:(NSString *)text {
    self.conversation.draft = @"";
    if (text.length == 0) {
        NSLog(@"发送的文案不能为空");
        return;
    }
    [self.logicController sendTextMessage:text];
}

- (void)saveDraftIfNeededWithText:(NSString *)text {
    self.conversation.draft = text;
}

- (void)showImagePicker {
    KGImagePickerController *picker = [[KGImagePickerController alloc] init];
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imageSelectButtonDidClick {
    [self showImagePicker];
}

- (void)imagePickerControllerCancelled:(KGImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(KGImagePickerController *)picker finishedPickingImage:(UIImage *)image {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

static NSString *LETTERS = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

- (void)autoSendMessage {
    __block NSInteger numberStart = arc4random()%100;
    NSString *letterStart = [LETTERS substringWithRange:NSMakeRange(arc4random()%52, 1)];
    for (int i = 0; i < 20 ; i ++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *text = [NSString stringWithFormat:@"%@%ld", letterStart, (long)numberStart ++];
            [self.logicController sendTextMessage:text];
        });
    }
}

#pragma mark - KwaiMessageCellLongPressDelegate
- (void)longPressForDeleteMessage:(KGMessageBaseCell *)cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    KwaiIMMessage *message = [self.logicController getMessageAtIndex:indexPath.row];
    
    [self.logicController deleteMessage:message
                             isFromCell:YES];
}

#pragma mark - Unread

- (void)jumpToUnread {
    NSArray<KwaiIMMessage *> *messages = self.logicController.allMessages;
    NSUInteger lastReadMessageIndex = [messages indexOfObjectWithOptions:NSEnumerationReverse passingTest:^BOOL(KwaiIMMessage * _Nonnull message, NSUInteger idx, BOOL * _Nonnull stop) {
        return message.seq == self.conversation.readSeq;
    }];
    if (lastReadMessageIndex != NSNotFound) {
        NSUInteger unreadPromptMessageIndex = MIN(lastReadMessageIndex + 1, messages.count - 1);
        
        //跳转到未读消息位置处
        NSIndexPath *firstVisCellIndexPath = [self.tableView indexPathForCell:self.tableView.visibleCells.firstObject];
        NSIndexPath *targetIndexPath = [NSIndexPath indexPathForRow:unreadPromptMessageIndex
                                                          inSection:firstVisCellIndexPath.section];
        [self.tableView scrollToRowAtIndexPath:targetIndexPath
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
    [self hideUnreadButton];
}

- (void)showUnreadButton {
    [self.jumpToUnreadButton setTitle:[NSString stringWithFormat:@"%lu条新消息", (unsigned long)self.conversation.unreadCount] forState:UIControlStateNormal];
    self.jumpToUnreadButton.hidden = false;
}

- (void)hideUnreadButton {
    self.jumpToUnreadButton.hidden = true;
}

#pragma mark - KSMsgContentLogicControllerDelegate
- (void)onLoadMessagesFinished {
    [self.tableView reloadData];
    [self scrollToLastMessageWithAnimated:true];
    [self jumpToUnreadIfNeeded];
}
- (void)onLoadMoreMessagesFinished:(NSArray *)result {
    [self.tableView reloadData];
    [self.tableView.refreshControl endRefreshing];
}
- (void)onLoadMessagesLaterThanMessageFinish:(BOOL)highlight highlightIndexPath:(NSIndexPath *)indexPath countChange:(BOOL)countChange {}

- (void)textMessageIsEmpty {}

- (void)onPreprocessImageMessages {}

- (void)onImageUploadFailed:(NSError *)error {}
- (void)imageProgressChanged:(CGFloat)progress atIndex:(NSInteger)index {}

- (void)deleteMessageComplete:(NSError *)error fromCell:(BOOL)fromCell {
    if(!error){
        [self.tableView reloadData];
    }
}
- (void)fixMessageBlackholeComplete {
    [self.tableView reloadData];
    [self scrollToLastMessageWithAnimated:true];
}

- (void)msgContentLogicController:(KSMsgContentLogicController *)logicController
                didReceiveMessage:(KwaiIMMessage *)message
                         isReload:(BOOL)isReload {
    [self.tableView reloadData];
    if (!isReload) {
        [self scrollToLastMessageWithAnimated:false];
    }
}

- (void)messageDidRemoved {
    [self.tableView reloadData];
}
- (void)messageDidSent:(KwaiIMMessage *)message {
    NSLog(@"%s, %@", __func__, message);
}
- (void)onMessageSentFailed:(KwaiIMMessage *)message error:(NSError *)error {
    NSLog(@"%s, %@", __func__, message);
}

- (void)onRemoveCurrentSessionComplete:(NSError *)error {}

- (void)scrollToLastMessageWithAnimated:(BOOL)animated {
    if(self.logicController.getMessagesCount >= 1){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.logicController.getMessagesCount - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

- (void)didUpdateMessagesWithIndexs:(NSIndexSet *)indexSet{
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    for(NSIndexPath *ip in self.tableView.indexPathsForVisibleRows){
        if([indexSet containsIndex:(NSUInteger)ip.row]){
            [indexPaths addObject:[NSIndexPath indexPathForRow:ip.row inSection:0]];
        }
    }
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveTypingSignalFromUser:(NSString *)userId witInterval:(NSInteger)interval {

}


#pragma mark - KSMessageKeyboardBarActionDelegate

- (void)keyboardWillShow:(KSMessageKeyboardBar *)keyboardBar duration:(NSTimeInterval)duration keyboardFrame:(CGRect)frame {
    [self scrollToLastMessageWithAnimated:false];
    
    CGRect keyboardFrame = keyboardBar.frame;
    keyboardFrame.origin.y = self.view.height - frame.size.height - keyboardFrame.size.height;
    self.keyboardBar.frame = keyboardFrame;
    
    UIEdgeInsets contentInsets = self.tableView.contentInset;
    contentInsets.bottom = frame.size.height + self.keyboardBar.height - [self.view demoSafeAreaInsets].bottom;
    self.tableView.contentInset = contentInsets;
    if (self.tableView.top + self.tableView.contentSize.height + frame.size.height + self.keyboardBar.height < UIScreen.mainScreen.bounds.size.height) {
        return;
    }
    CGFloat offsetY = self.tableView.contentSize.height + frame.size.height + self.keyboardBar.size.height - self.tableView.height - [self.view demoSafeAreaInsets].bottom;
    self.tableView.contentOffset = CGPointMake(0, offsetY);
}

- (void)keyboardWillHide:(KSMessageKeyboardBar *)keyboardBar duration:(NSTimeInterval)duration {
    
    CGRect keyboardBarFrame = self.keyboardBar.frame;
    keyboardBarFrame.origin.y = CGRectGetHeight(self.view.bounds) - (CGRectGetHeight(keyboardBarFrame) + [self.view demoSafeAreaInsets].bottom);
    self.keyboardBar.frame = keyboardBarFrame;
    
    UIEdgeInsets tableViewInsets = self.tableView.contentInset;
    tableViewInsets.bottom = self.keyboardBar.height;
    self.tableView.contentInset = tableViewInsets;
    
    CGFloat offsetY = self.tableView.contentSize.height + self.keyboardBar.size.height - self.tableView.bounds.size.height ;
    
    self.tableView.contentOffset = CGPointMake(0, (offsetY<self.tableView.contentInset.top*(-1)?self.tableView.contentInset.top*(-1):offsetY));
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *text = textField.text;
    [self.logicController sendTextMessage:text];
    textField.text = nil;
    return true;
}

- (void)keyboardBarDidClickImageButton:(KSMessageKeyboardBar *)keyboardBar {
    [self.keyboardBar resignFirstResponder];
    [self showImagePicker];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.keyboardBar resignFirstResponder];
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (KSMessageKeyboardBar *)keyboardBar {
    if (_keyboardBar == nil) {
        _keyboardBar = [[KSMessageKeyboardBar alloc] initWithViewController:self];
        [self.view addSubview:_keyboardBar];
        _keyboardBar.textFieldDelegate = self;
        _keyboardBar.actionDelegate = self;
    }
    return _keyboardBar;
}

- (UIButton *)jumpToUnreadButton {
    if (!_jumpToUnreadButton) {
        _jumpToUnreadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _jumpToUnreadButton.layer.cornerRadius = 20.0;
        [_jumpToUnreadButton addTarget:self action:@selector(jumpToUnread) forControlEvents:UIControlEventTouchUpInside];
        [_jumpToUnreadButton setTitleColor:[UIColor colorWithRed:0.36 green:0.79 blue:0.96 alpha:1.00]
                                  forState:UIControlStateNormal];
        _jumpToUnreadButton.titleLabel.font = [UIFont systemFontOfSize:15.0 weight:2];
        _jumpToUnreadButton.layer.borderColor = [UIColor colorWithRed:0.36 green:0.79 blue:0.96 alpha:1.00].CGColor;
        _jumpToUnreadButton.layer.borderWidth = 2.0;
        _jumpToUnreadButton.hidden = true;
        _jumpToUnreadButton.backgroundColor = UIColor.redColor;
        [self.view insertSubview:_jumpToUnreadButton aboveSubview:self.tableView];
    }
    
    return _jumpToUnreadButton;
}

@end
