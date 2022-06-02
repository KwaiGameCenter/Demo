//
//  MLCUniqueEventHandlerHelper.h
//  DevelopTools
//
//  Created by 刘玮 on 2016/12/6.
//  Copyright © 2016年 Kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLCEventsQueueHandler.h"

@interface MLCUniqueEventHandlerHelper : NSObject

+ (id<MLCEventQueueInterface>) getHandler: (NSString *)handlerId;

+ (id<MLCEventQueueInterface>) getHandler: (NSString *)handlerId
                                 priority: (QueuePriority)priority;

+ (void) removeHandler: (NSString *)handlerId;

@end
