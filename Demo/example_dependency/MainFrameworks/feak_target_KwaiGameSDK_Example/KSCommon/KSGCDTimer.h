//
//  KSGCDTimer.h
//  gif
//
//  Created by coderlih on 2018/1/17.
//  Copyright © 2018年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^KSGCDTimerBlock)();

@interface KSGCDTimer : NSObject

@property (nonatomic, assign, readonly) BOOL timerTicking;
/// 将要回调的时间点，如果 timer 暂停/停止，则是上一次的调用时间
@property (nonatomic, strong, readonly) NSDate *fireDate;
/// timer 重复回调的间隔
@property (nonatomic, assign, readonly) NSTimeInterval timerInterval;

- (instancetype)initWithTargetQueue:(dispatch_queue_t)queue;

- (void)addEventHandler:(KSGCDTimerBlock)eventHandler;

- (void)removeAllEvents;

- (void)fireWithDelay:(NSTimeInterval)delay interval:(NSTimeInterval)interval;

- (void)fireWithDelay:(NSTimeInterval)delay;

- (BOOL)stop;

- (void)resume;

@end
