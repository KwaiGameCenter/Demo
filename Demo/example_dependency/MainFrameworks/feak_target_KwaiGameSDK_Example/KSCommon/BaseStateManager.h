//
//  BaseStateManager.h
//  Pods
//
//  Created by 刘玮 on 2016/12/6.
//  Copyright © 2016年 Kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseStateProtocol.h"
#import "CategoryMan.h"

typedef void (^print_log_block) (NSString *logMsg);

@interface BaseStateManager : NSObject

+ (CategoryMan<BaseStateProtocol> *)stateWithState: (NSString *)className printBlock: (print_log_block)printBlock;

+ (NSString *)stateName: (CategoryMan<BaseStateProtocol> *)state;

@end
