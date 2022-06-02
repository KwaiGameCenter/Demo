//
//  KSAudioSessionRouteMonitor.h
//  gif
//
//  Created by tanbing on 2017/7/6.
//  Copyright © 2017年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^KSAudioSessionRouteChangedBlock)(BOOL flag, AVAudioSessionRouteChangeReason reason);
// 默认创建完毕就会开始监听
@interface KSAudioSessionRouteMonitor : NSObject

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, copy) KSAudioSessionRouteChangedBlock headsetRouteChanged;

@property (nonatomic, assign, readonly) BOOL hasHeadset;

- (void)startMonitor;
- (void)stopMonitor;

@end
