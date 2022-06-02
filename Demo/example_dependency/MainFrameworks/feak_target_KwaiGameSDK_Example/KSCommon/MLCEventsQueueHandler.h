//
//  MLCEventsQueueHandler.h
//  DevelopTools
//
//  Created by 刘玮 on 2016/12/6.
//  Copyright © 2016年 Kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, QueuePriority) {
    QueuePriority_Default = 0,      /*Work Like Default Global Queue*/
    QueuePriority_High = 1,         /*Work Like High Global Queue*/
    QueuePriority_Low = 2,          /*Work Like Low Global Queue*/
    QueuePriority_Background = 3,   /*Work Like Background Global Queue*/
    QueuePriority_LegalHigh = 4     /*Work Like Main Queue*/
};

typedef id (^MLCDoCellEvent)();                 // Worker Block
typedef void (^MLCDoCellResult)(id result);     // Result Block

/* A Serial Queue Interface easy for use*/
@protocol MLCEventQueueInterface <NSObject>

// Current Queue For Events.
@property (nonatomic, readonly) dispatch_queue_t syncQueue;

// Current Priority(Default is QueuePriority_Default).
@property (nonatomic, assign) QueuePriority priority;

// If set ignoreEventQueue == YES, the MLCEventQueueInterface object willn't use dispatch feature.
@property (nonatomic, assign) BOOL ignoreEventQueue;

// Disable anyway priority changed, it's always equal QueuePriority_Default.
+ (void)setDisablePriority: (BOOL)disable;

// If the current queue is the same as the MLCEventQueueInterface object's queue, the event will run immediately;
// If not, the event will be dispatch async to the MLCEventQueueInterface object's queue and wait to launch.
- (void) postW: (MLCDoCellEvent) event;

// If the current queue is the same as the MLCEventQueueInterface object's queue, the event will run immediately;
// If not, the event will be dispatch sync to the MLCEventQueueInterface object's queue and wait to launch;
// And you will get the result immediately.
- (id) postR: (MLCDoCellEvent) event;

// The Event will be dispatch async(or sync) to the MLCEventQueueInterface object's queue and wait to launch.
- (id) postW: (MLCDoCellEvent) event
        sync: (BOOL) sync;

// The Event will be dispatch async(or sync) to the MLCEventQueueInterface object's queue and wait to launch,
// And you will get the result immediately.
- (id) postR: (MLCDoCellEvent) event
        sync: (BOOL) sync;

@optional

// Return the current thread id.
- (NSString *) threadId;

// The Event will be dispatch async(or sync) to the MLCEventQueueInterface object's queue and wait to launch,
// If work as sync mode, you will get the result immediately, work as async mode, you will get the result through resultBlock.
- (id) postW: (MLCDoCellEvent) event
        sync: (BOOL) sync
       block: (MLCDoCellResult) resultBlock;

// The Event will be dispatch async(or sync) to the MLCEventQueueInterface object's queue and wait to launch,
// If work as sync mode, you will get the result immediately, work as async mode, you will get the result through resultBlock.
- (id) postR: (MLCDoCellEvent) event
        sync: (BOOL) sync
       block: (MLCDoCellResult) resultBlock;

// Dispatch All events to run at the same time, when all events has finished the complete will run at last.
- (void) postMultiEvents: (NSArray<MLCDoCellEvent> *)events
                complete: (MLCDoCellResult)complete;

@end

/* A Serial Queue Object easy for use*/
@interface MLCEventsQueueHandler : NSObject<MLCEventQueueInterface>

// init with unique handlerId
- (id) init: (NSString *)handlerId;

@end
