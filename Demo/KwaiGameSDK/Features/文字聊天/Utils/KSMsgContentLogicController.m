//
//  KSMsgContentLogicController.m
//  gif
//
//  Created by yiyang on 2017/12/5.
//  Copyright © 2017年 kuaishou. All rights reserved.
//

#import <KwaiGameSDK-IM/KwaiIMManager+Group.h>
#import "KSMsgContentLogicController.h"
#import <KwaiGameSDK-IM/KwaiIMConversation.h>
#import "KwaiHelper.h"
#import "KwaiBase.h"
#import <KwaiGameSDK-IM/KwaiIMMessage.h>
#import <KwaiGameSDK-IM/KwaiIMTextMessage.h>
#import <KwaiGameSDK-IM/KwaiIMImageMessage.h>
#import <KwaiGameSDK-IM/KwaiIMEmotionMessage.h>
#import <KwaiGameSDK-IM/KwaiIMReferenceMessage.h>
#import <KwaiGameSDK-IM/KwaiIMPassThroughManager.h>
#import <KwaiGameSDK-IM/KwaiIMManager.h>

static NSInteger kKSLoadMessageLimit = 30;

typedef NS_ENUM(short, _KSIMMsgLoadingType) {
    _KSIMMsgLoadingTypeNone,
    _KSIMMsgLoadingTypeLoadEarlier,
    _KSIMMsgLoadingTypeLoadLater,
    _KSIMMsgLoadingTypeInitialLoading,
    _KSIMMsgLoadingTypeInChatUpdating
};

@interface KSMsgContentLogicController()<KwaiIMManagerMessageDelegate, KwaiIMPassThroughDelegate>
@property (nonatomic, strong) KwaiIMConversation *session;
@property (nonatomic, strong) NSMutableArray<KwaiIMMessage *> *messages;
@property (nonatomic, strong) NSString *linkStateToken;
@property (nonatomic, assign) long long currentMaxSeq;
@property (nonatomic, assign) UInt64 lastTime;
@property (nonatomic, assign) UInt64 lastMoreTime;
@property (nonatomic, assign) BOOL hasReceivedMessage;

@property (nonatomic, copy, readwrite) NSArray<KwaiIMBasicMember *> *groupMembers;

@end

@implementation KSMsgContentLogicController

- (void)dealloc
{
    [[KwaiIMManager sharedManager] removeMessageDelegate:self];
}

- (instancetype)initWithSession:(KwaiIMConversation *)session
{
    if (self = [self init]) {
        _session = session;
        _currentMaxSeq = session.lastMessage.seq;
    }
    return self;
}


- (instancetype)init
{
    if (self = [super init]) {
        _messages = [[NSMutableArray alloc] init];
        _lastTime = 0;
        _lastMoreTime = 0;
    }
    return self;
}

- (void)setup
{
    [[KwaiIMManager sharedManager] addMessageDelegate:self delegateQueue:dispatch_get_main_queue()];
    [[KwaiIMPassThroughManager sharedManager] addPassThroughDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)setupThread:(KwaiIMConversation *)thread
{
    self.session = thread;
    _currentMaxSeq = self.session.lastMessage.seq;
}

- (void)resendMessage:(KwaiIMMessage *)message{
    [[KwaiIMManager sharedManager] sendMessage:message
                                                         resultBlock:nil
                                                       progressBlock:nil];
}

- (BOOL)sendTextMessage:(NSString *)text
{
    if (text.length == 0) {
        if ([self.delegate respondsToSelector:@selector(textMessageIsEmpty)]) {
            [self.delegate textMessageIsEmpty];
        }
        return false;
    }
    KwaiIMTextMessage *message = [[KwaiIMTextMessage alloc] initWithTargetId:self.session.conversationID conversationType:self.session.type text:text extra:nil];
    //    message.receiptRequired = YES;
    [[KwaiIMManager sharedManager] sendMessage:message
                                                         resultBlock:nil
                                                       progressBlock:nil];
    return true;
}

- (BOOL)sendTextMessage:(NSString *)text withAtInfos:(NSArray<KwaiIMReminderBody *> *)atInfos {
    if (text.length == 0) {
        if ([self.delegate respondsToSelector:@selector(textMessageIsEmpty)]) {
            [self.delegate textMessageIsEmpty];
        }
        return false;
    }
    KwaiIMTextMessage *message = [[KwaiIMTextMessage alloc] initWithTargetId:self.session.conversationID conversationType:self.session.type text:text extra:nil];
    //    message.receiptR2equired = YES;
    KwaiIMReminder *reminder = [KwaiIMReminder new];
    reminder.bodys = atInfos;
    [[KwaiIMManager sharedManager] sendMessage:message resultBlock:nil progressBlock:nil];
    return true;
}

- (BOOL)sendReferenceMessage:(KwaiIMMessage *)referenceMessage withText:(NSString *)text andAtInfos:(NSArray<KwaiIMReminderBody *> *)atInfos {
    KwaiIMReferenceMessage *message = [[KwaiIMReferenceMessage alloc] initWithTargetId:self.session.conversationID
                                                                      conversationType:self.session.type
                                                                         originMessage:referenceMessage
                                                                                  text:text
                                                                                 extra:nil];
    KwaiIMReminder *reminder = [[KwaiIMReminder alloc] init];
    reminder.bodys = atInfos;
    message.reminder = reminder;
    [[KwaiIMManager sharedManager] sendMessage:message resultBlock:nil progressBlock:nil];
    return true;
}

- (BOOL)sendEmotionMessage:(KwaiEmotion *)emotion
{
    if (emotion == nil) {
        return false;
    }
    KwaiIMEmotionMessage *message = [KwaiHelper messageFromEmotion:emotion conversation:self.session];
    //    [[KwaiIMManager sharedManager] sendMessage:message resultBlock:nil progressBlock:nil];
    [[KwaiIMManager sharedManager] sendMessage:message
                                                         resultBlock:nil
                                                       progressBlock:nil];
    return true;
}


- (void)sendImageMessages:(NSArray<KwaiIMImageMessage *> *)imageMessages{
    [[KwaiIMManager sharedManager] sendMessages:imageMessages resultBlock:^(KwaiIMMessage * _Nullable message, NSError * _Nullable error) {
        NSLog(@"%@", error);
    } progressBlock:^(KwaiIMMessage * _Nullable message, float progress, NSInteger index) {
        [self.delegate imageProgressChanged:progress atIndex:index];
    }];
    
    if ([self.delegate respondsToSelector:@selector(onPreprocessImageMessages)]) {
        [self.delegate onPreprocessImageMessages];
    }
}

- (void)sendVideoMessage:(KwaiIMMessage *)videoMessage {
    [[KwaiIMManager sharedManager] sendMessage:videoMessage resultBlock:^(KwaiIMMessage * _Nullable message, NSError * _Nullable error) {
        NSLog(@"%@", message);
    } progressBlock:^(KwaiIMMessage * _Nullable message, float progress, NSInteger index) {
    }];
}

- (void)loadInitialMessagesWithCount:(NSInteger)count {
    NSInteger loadMessageNum = count >= kKSLoadMessageLimit ? count : kKSLoadMessageLimit;
    //    KwaiIMMessage *cursorMessage = [KwaiIMMessage new];
    //    cursorMessage.seq = self.session.maxSeq + 1;
    //    cursorMessage.conversationId = self.session.conversationID;
    //    cursorMessage.conversationType = self.session.type;
    [[KwaiIMManager sharedManager] fetchMessagesWithConversation:self.session earlierThanMessage:nil countLimit:loadMessageNum fromCache:false resultBlock:^(NSArray<KwaiIMMessage *> * _Nullable messages, NSError * _Nullable error, BOOL isLoadedToEnd) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray *preProcessMsgs = [[NSMutableArray alloc] init];
            [preProcessMsgs addObjectsFromArray:[self _preProcessMessages:messages loadingType:_KSIMMsgLoadingTypeInitialLoading]];
            if (![preProcessMsgs containsObject:self.session.lastMessage] && self.session.lastMessage) {
                [preProcessMsgs addObject:self.session.lastMessage];
            }
            [self.messages removeAllObjects];
            [self.messages addObjectsFromArray:preProcessMsgs];
            if ([self.delegate respondsToSelector:@selector(onLoadMessagesFinished)]) {
                [self.delegate onLoadMessagesFinished];
            }
        });
    }];
}

- (void)loadMessagesWithMessageType:(int)messageType {
    [[KwaiIMManager sharedManager] fetchMessagesWithConversation:self.session messageType:messageType cursorMessage:self.session.lastMessage isEarlier:true countLimit:30 resultBlock:^(NSArray<KwaiIMMessage *> * _Nullable messages, NSError * _Nullable error, BOOL isLoadedToEnd) {
        //        NSLog(@"Total count: %lu", messages.count);
        [[KwaiIMManager sharedManager] fetchMessagesWithConversation:self.session earlierThanMessage:self.session.lastMessage countLimit:100 fromCache:true resultBlock:^(NSArray<KwaiIMMessage *> * _Nullable s_messages, NSError * _Nullable error, BOOL isLoadedToEnd) {
            NSMutableArray *temp = [NSMutableArray array];
            for (KwaiIMMessage *message in s_messages) {
                if (message.type == KwaiIMMessageTypeImage) {
                    [temp addObject:message];
                }
            }
            NSLog(@"%@", temp);
        }];
    }];
}

- (void)loadMoreMessages
{
    self.lastMoreTime = 0;
    KwaiIMMessage *firstMessage = self.messages.firstObject;
    [[KwaiIMManager sharedManager] fetchMessagesWithConversation:self.session earlierThanMessage:firstMessage countLimit:kKSLoadMessageLimit fromCache:false resultBlock:^(NSArray<KwaiIMMessage *> * _Nullable messages, NSError * _Nullable error, BOOL isLoadedToEnd) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *result = [self _preProcessMessages:messages loadingType:_KSIMMsgLoadingTypeLoadEarlier];
            [self.messages insertObjects:result atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, result.count)]];
            if ([self.delegate respondsToSelector:@selector(onLoadMoreMessagesFinished:)]) {
                [self.delegate onLoadMoreMessagesFinished:result];
            }
        });
    }];
}

- (void)loadMessagesLaterThanMessage:(KwaiIMMessage *)message
                           highlight:(BOOL)highlight
           shouldIgnoreTargetMessage:(BOOL)shouldIgnoreTargetMessage
{
    [self loadMessagesLaterThanMessage:message
                             highlight:highlight
             shouldIgnoreTargetMessage:shouldIgnoreTargetMessage
shouldInsertUnreadMessagePromptMessage:NO];
}

- (void)loadMessagesLaterThanMessage:(KwaiIMMessage *)message
                           highlight:(BOOL)highlight
           shouldIgnoreTargetMessage:(BOOL)shouldIgnoreTargetMessage
shouldInsertUnreadMessagePromptMessage:(BOOL)shouldInsertUnreadMessagePromptMessage
{
    [[KwaiIMManager sharedManager] fetchMessagesWithConversation:self.session laterThanMessage:message countLimit:kKSLoadMessageLimit fromCache:false resultBlock:^(NSArray<KwaiIMMessage *> * _Nullable messages, NSError * _Nullable error, BOOL isLoadedToEnd) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(onLoadMessagesLaterThanMessageFinish:highlightIndexPath:countChange:)]) {
                NSInteger oldMessageCount = self.messages.count;
                NSInteger originIndex = MAX(0, oldMessageCount - 1);
                NSArray *preProcessMsgs = [self _preProcessMessages:messages loadingType:_KSIMMsgLoadingTypeLoadLater];
                [self.messages addObjectsFromArray:preProcessMsgs];
                if (oldMessageCount != self.messages.count) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:originIndex inSection:0];
                    [self.delegate onLoadMessagesLaterThanMessageFinish:highlight highlightIndexPath:indexPath countChange:true];
                } else {
                    [self.delegate onLoadMessagesLaterThanMessageFinish:highlight highlightIndexPath:nil countChange:false];
                }
                if ([self.delegate respondsToSelector:@selector(onLoadMessagesFinished)]) {
                    [self.delegate onLoadMessagesFinished];
                }
            }
        });
    }];
}

- (void)deleteMessage:(KwaiIMMessage *)message
           isFromCell:(BOOL)fromCell{
    [[KwaiIMManager sharedManager] deleteMessage:message completionBlock:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(deleteMessageComplete:fromCell:)]) {
                [self.delegate deleteMessageComplete:error
                                            fromCell:fromCell];
            }
        });
    }];
}

- (NSInteger)indexOfMessage:(KwaiIMMessage *)message
{
    return [self.messages indexOfObject:message];
}

- (NSInteger)getMessagesCount
{
    return self.messages.count;
}

- (void)bringFailMessageToLatest:(KwaiIMMessage *)message
{
    if (message) {
        [self.messages removeObject:message];
        [self.messages addObject:message];
    }
}

- (KwaiIMMessage *)lastMessage
{
    return self.messages.lastObject;
}

- (NSArray<KwaiIMMessage *> *)allMessages {
    return [self.messages copy];
}

- (void)clearUnreadCount
{
    [[KwaiIMManager sharedManager] markConversationAsRead:self.session completionBlock:nil];
    self.session.unreadCount = 0;
}

- (KwaiIMMessage *)getMessageAtIndex:(NSInteger)index
{
    if (index < self.messages.count && index >= 0) {
        return self.messages[index];
    }else {
        return nil;
    }
}

- (void)removeAllMessages
{
    [self.messages removeAllObjects];
}

- (void)addMessage:(KwaiIMMessage *)message
{
    if (message) {
        [self.messages addObject:message];
    }
}

- (void)addMessage:(KwaiIMMessage *)message atIndex:(NSInteger)index
{
    if (message) {
        [self.messages insertObject:message atIndex:index];
    }
}

- (void)removeMessage:(KwaiIMMessage *)message atIndex:(NSInteger)index
{
    if (message && index >= 0 && index < self.messages.count) {
        [self.messages removeObjectAtIndex:index];
    }
}

- (void)removeCurrentSession
{
    [[KwaiIMManager sharedManager] deleteConversation:self.session completionBlock:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(onRemoveCurrentSessionComplete:)]) {
                [self.delegate onRemoveCurrentSessionComplete:error];
            }
        });
    }];
}

- (void)_removeMessages:(NSArray<KwaiIMMessage *> *)messages {
    //检查多余的时间节点
    KwaiIMMessage *deletedMessage = messages.firstObject;
    if (deletedMessage.seq == self.currentMaxSeq) {
        self.currentMaxSeq --;
    }
    [self.messages removeObjectsInArray:messages];
    
    if ([self.delegate respondsToSelector:@selector(messageDidRemoved)]) {
        [self.delegate messageDidRemoved];
    }
}

#pragma mark -  KwaiIMManagerMessageDelegate

- (void)pringMessages:(NSArray<KwaiIMMessage *> * _Nullable)messages withOperation:(NSString *)operation {
    for (KwaiIMMessage *message in messages) {
        NSLog(@"%@ %@", operation, message);
    }
}

- (void)manager:(KwaiIMManager *)manager didUpdateMessages:(NSArray<KwaiIMMessage *> *)messages forConversationId:(NSString *)conversationId byChangeType:(KwaiIMMessageChangeType)changeType{
    if (messages.count == 0 || ![messages.firstObject.conversationId isEqualToString:self.session.conversationID] ) {
        return;
    }
    switch (changeType) {
        case KwaiIMMessageChangeTypeInsert:
        case KwaiIMMessageChangeTypeUpdate:
            [self _updateMessages:messages];
            break;
        case KwaiIMMessageChangeTypeDelete:
            [self _removeMessages:messages];
            break;
        default:
            break;
    }
}

- (void)manager:(nonnull KwaiIMManager *)manager didRemoveMessages:(nonnull NSArray<KwaiIMMessage *> *)messages forConversation:(nonnull NSString *)conversationId {
}

- (void)manager:(nonnull KwaiIMManager *)manager didReceiveMessage:(nonnull NSArray<KwaiIMMessage *> *)messages forConversation:(nonnull NSString *)conversationId {
    if (![conversationId isEqualToString:self.session.conversationID] || messages.count == 0 || self.hasReceivedMessage) {
        return;
    }
    self.hasReceivedMessage = YES;
}

- (void)manager:(nonnull KwaiIMManager *)manager willSendMessage:(nonnull KwaiIMMessage *)message {
}

- (void)manager:(nonnull KwaiIMManager *)manager didFailedToSendMessage:(nonnull KwaiIMMessage *)message withError:(nullable NSError *)error {
    if (![message.conversationId isEqualToString:self.session.conversationID]) {
        
        return;
    }
    //    [self.messages addObjectsFromArray:[self _preProcessMessages:@[message] loadingType:_KSIMMsgLoadingTypeNone]];
    if ([self.delegate respondsToSelector:@selector(onMessageSentFailed:error:)]) {
        [self.delegate onMessageSentFailed:message error:error];
    }
}

- (void)manager:(nonnull KwaiIMManager *)manager didSucceedToSendMessage:(nonnull KwaiIMMessage *)message {
    if (![message.conversationId isEqualToString:self.session.conversationID]) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(messageDidSent:)]) {
        [self.delegate messageDidSent:message];
    }
}

- (void)_updateMessages:(NSArray *)messages
{
    BOOL isReload = NO;
    [self pringMessages:messages withOperation:@"Update"];
    for (KwaiIMMessage *message in messages){
        if ([self.messages containsObject:message]) {
            NSUInteger index = [self.messages indexOfObject:message];
            [self.messages replaceObjectAtIndex:index withObject:message];
            isReload = true;
        }
        if (message.seq > self.currentMaxSeq){
            self.currentMaxSeq = message.seq;
        }
    }
    if (!isReload) {
        [self.messages addObjectsFromArray:[self _preProcessMessages:messages loadingType:_KSIMMsgLoadingTypeInChatUpdating]];
    }
    SEL sel = @selector(msgContentLogicController:didReceiveMessage:isReload:);
    if ([self.delegate respondsToSelector:sel]) {
        [self.delegate msgContentLogicController:self
                               didReceiveMessage:messages.firstObject
                                        isReload:isReload];
    }
}

- (long long)_minSeqForMessage:(KwaiIMMessage *)message {
    if (message.type == KwaiIMMessageTypeNotice){
        return message.endSeq;
    } else {
        return message.seq;
    }
}

- (NSArray<KwaiIMMessage *> *)_preProcessMessages:(NSArray<KwaiIMMessage *> *)msgs loadingType:(_KSIMMsgLoadingType)loadingType{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:msgs.count];
    for (KwaiIMMessage *msg in msgs) {
        if (msg.type != KwaiIMMessageTypePlaceHolder) {
            [ret addObject:msg];
        }
    }
    return ret;
}

- (void)sendTypingState {
}

#pragma mark - KwaiIMPassThroughDelegate

- (void)didReceiveTypingSignalFromUser:(NSString *)userId witInterval:(NSInteger)interval {
    if ([userId isEqualToString:self.session.conversationID]) {
        if ([self.delegate respondsToSelector:@selector(didReceiveTypingSignalFromUser:witInterval:)]) {
            [self.delegate didReceiveTypingSignalFromUser:userId witInterval:interval];
        }
    }
}

@end

