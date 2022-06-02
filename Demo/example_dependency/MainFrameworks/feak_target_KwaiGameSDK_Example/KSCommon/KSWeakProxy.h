//
// Created by zhongchao.han on 28/11/2017.
// Copyright (c) 2017 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSWeakProxy : NSProxy

- (instancetype)initWithTarget:(id)target;

@property (nonatomic, weak, readonly) id target;

@end
