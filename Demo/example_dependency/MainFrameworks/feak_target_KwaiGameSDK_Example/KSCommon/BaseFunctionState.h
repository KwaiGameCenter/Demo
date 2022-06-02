//
//  BaseFunctionState.h
//  Pods
//
//  Created by 刘玮 on 2016/12/6.
//  Copyright © 2016年 Kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseStateProtocol.h"

@interface BaseFunctionState : NSObject<BaseStateProtocol>

@property (nonatomic, readonly, strong) id extendData;

- (NSTimer *)startTime: (NSTimeInterval)duration
                repeat: (BOOL)repeat
                action: (SEL)action;

- (void)stopTime: (NSTimer *)timer;

@end
