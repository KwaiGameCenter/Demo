//
//  BlockExecutor.h
//  Pods
//
//  Created by 刘玮 on 2016/12/6.
//  Copyright © 2016年 Kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^voidBlock)(void);

@interface BlockExecutor : NSObject

- (id)initWithBlock:(voidBlock)block;

@end
