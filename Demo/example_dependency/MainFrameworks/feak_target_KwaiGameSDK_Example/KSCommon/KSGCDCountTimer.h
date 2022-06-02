//
//  KSGCDCountTimer.h
//  gif
//
//  Created by coderlih on 2018/1/17.
//  Copyright © 2018年 kuaishou. All rights reserved.
//

#import <KSCommon/KSGCDTimer.h>

@interface KSGCDCountTimer : KSGCDTimer
@property(nonatomic, assign) BOOL enableFirstTrack;

- (NSInteger)countDownWithCount:(NSTimeInterval)timeLeft eventHandler:(KSGCDTimerBlock)eventHandler completion:(KSGCDTimerBlock)completionBlock;

@end
