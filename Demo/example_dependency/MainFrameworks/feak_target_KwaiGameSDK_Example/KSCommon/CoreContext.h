//
//  CoreContext.h
//  Pods
//
//  Created by 刘玮 on 2016/12/6.
//  Copyright © 2016年 Kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+LcProperty.h"
#import "BaseStateProtocol.h"
#import "MLCPublicCommand.h"
#import "CategoryMan.h"
#import "CoreSession.h"

typedef NS_ENUM(NSInteger, DebugLevel) {
    DebugLevel_None = 0,
    DebugLevel_State = 1,
    DebugLevel_Session = 1 << 1,
    DebugLevel_Action = 1 << 2,
    DebugLevel_StateAndSession = DebugLevel_State | DebugLevel_Session,
    DebugLevel_All = DebugLevel_State | DebugLevel_Session | DebugLevel_Action
};

#define kDebugLevel(debugLevel, level) ((debugLevel & level) > 0)

@interface CoreContext : NSObject

@property (nonatomic, strong) CategoryMan<BaseStateProtocol> *currentState;
@property (nonatomic, strong) CategoryMan<CoreSession> *currentSession;
@property (nonatomic, copy) NSString *debugInformation;
@property (nonatomic, assign) int debugLevel;

- (void)setupWithSession: (id<CoreSession>)session
        withDefaultState: (NSString *)className;

#pragma mark - Session

- (BOOL)customSession: (id<CoreSession>)session;

- (void)clearSession;

#pragma mark - Context

- (void)customContext;

- (void)destroyContext;

- (BOOL)setState: (NSString *)className;

- (BOOL)setState: (NSString *)className extendData: (id)extendData;

- (BOOL)stateEuqal: (NSString *)className;

- (NSString *)currentStateName;

#pragma mark - If Use Categorty, implement these methods

+ (void)categoryInitialize;

- (void)categoryCustomSession: (id<CoreSession>)session;

- (void)categoryClearSession;

- (void)categoryCustomContext;

- (void)categoryDestoryContext;

#pragma mark - Log

- (void)printLog: (NSString *)log;

@end

BUILD_IN_OBJ_SINGLETON_THREAD_INTERFACE(CoreContext)
