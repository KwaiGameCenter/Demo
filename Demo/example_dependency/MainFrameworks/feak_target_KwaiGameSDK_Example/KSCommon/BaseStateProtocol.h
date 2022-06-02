//
//  BaseStateProtocol.h
//  Pods
//
//  Created by 刘玮 on 2016/12/6.
//  Copyright © 2016年 Kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLCPublicCommand.h"
#import "CategoryMan.h"

@class CoreContext;
@protocol CoreSession;

@protocol BaseStateProtocol <NSObject>

@property (nonatomic, weak) CoreContext *context;
@property (nonatomic, strong) CategoryMan<CoreSession> *session;
@property (nonatomic, readonly, assign) BOOL isStart;

- (void)start;

- (void)start: (id)obj;

- (void)stop;

- (void)configUI;

- (void)clearUIConfigs;

@end
