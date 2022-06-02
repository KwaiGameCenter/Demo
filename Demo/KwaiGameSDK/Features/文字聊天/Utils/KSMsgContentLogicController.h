//
//  KSMsgContentLogicController.h
//  gif
//
//  Created by yiyang on 2017/12/5.
//  Copyright © 2017年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KwaiIMConversation, KwaiIMMessage, KwaiIMImageMessage, KwaiEmotion, KSMsgContentLogicController, KwaiIMBasicMember, KwaiIMReminderBody;

@protocol KSMsgContentLogicControllerDelegate <NSObject>
@optional
- (void)onLoadMessagesFinished;
- (void)onLoadMoreMessagesFinished:(NSArray *)result ;
- (void)onLoadMessagesLaterThanMessageFinish:(BOOL)highlight highlightIndexPath:(NSIndexPath *)indexPath countChange:(BOOL)countChange;

- (void)textMessageIsEmpty;
- (void)onPreprocessImageMessages;
- (void)onImageUploadFailed:(NSError *)error;
- (void)imageProgressChanged:(CGFloat)progress atIndex:(NSInteger)index;

- (void)deleteMessageComplete:(NSError *)error fromCell:(BOOL)fromCell;
- (void)fixMessageBlackholeComplete;
- (void)msgContentLogicController:(KSMsgContentLogicController *)logicController
                didReceiveMessage:(KwaiIMMessage *)message
                         isReload:(BOOL)isReload;
- (void)messageDidRemoved;
- (void)messageDidSent:(KwaiIMMessage *)message;
- (void)onMessageSentFailed:(KwaiIMMessage *)message error:(NSError *)error;
- (void)onRemoveCurrentSessionComplete:(NSError *)error;
- (void)onAddUserToBlackListComplete:(BOOL)success error:(NSError *)error;
- (void)didUpdateMessagesWithIndexs:(NSIndexSet *)indexSet;
- (void)didReceiveTypingSignalFromUser:(NSString *)userId witInterval:(NSInteger)interval;

@end

@interface KSMsgContentLogicController : NSObject

@property (nonatomic, weak) id<KSMsgContentLogicControllerDelegate> delegate;
@property (nonatomic, copy, readonly) NSArray<KwaiIMBasicMember *> *groupMembers;

- (instancetype)initWithSession:(KwaiIMConversation *)session;

- (void)setup;

- (BOOL)sendTextMessage:(NSString *)text;
- (BOOL)sendTextMessage:(NSString *)text withAtInfos:(NSArray<KwaiIMReminderBody *> *)atInfos;
- (BOOL)sendReferenceMessage:(KwaiIMMessage *)referenceMessage withText:(NSString *)text andAtInfos:(NSArray<KwaiIMReminderBody *> *)atInfos;

- (void)sendImageMessages:(NSArray<KwaiIMImageMessage *> *)images;
- (BOOL)sendEmotionMessage:(KwaiEmotion *)emotion;
- (void)sendVideoMessage:(KwaiIMMessage *)videoMessage;
- (void)resendMessage:(KwaiIMMessage *)message;

- (void)loadInitialMessagesWithCount:(NSInteger)count;
- (void)loadMoreMessages;
- (void)loadMessagesLaterThanMessage:(KwaiIMMessage *)message
                           highlight:(BOOL)highlight
           shouldIgnoreTargetMessage:(BOOL)shouldIgnoreTargetMessage;

- (void)loadMessagesLaterThanMessage:(KwaiIMMessage *)message
                           highlight:(BOOL)highlight
           shouldIgnoreTargetMessage:(BOOL)shouldIgnoreTargetMessage
shouldInsertUnreadMessagePromptMessage:(BOOL)shouldInsertUnreadMessagePromptMessage;

- (void)loadMessagesWithMessageType:(int)messageType;

- (void)deleteMessage:(KwaiIMMessage *)message isFromCell:(BOOL)fromCell;

- (NSInteger)indexOfMessage:(KwaiIMMessage *)message;
- (KwaiIMMessage *)getMessageAtIndex:(NSInteger)index;
- (NSInteger)getMessagesCount;
- (KwaiIMMessage *)lastMessage;
- (NSArray<KwaiIMMessage *> *)allMessages;
- (void)addMessage:(KwaiIMMessage *)message;
- (void)addMessage:(KwaiIMMessage *)message atIndex:(NSInteger)index;
- (void)removeMessage:(KwaiIMMessage *)message atIndex:(NSInteger)index;
- (void)removeAllMessages;
- (void)removeCurrentSession;
- (void)clearUnreadCount;
- (void)bringFailMessageToLatest:(KwaiIMMessage *)message;
- (void)setupThread:(KwaiIMConversation *)thread;

- (void)sendTypingState;

@end
