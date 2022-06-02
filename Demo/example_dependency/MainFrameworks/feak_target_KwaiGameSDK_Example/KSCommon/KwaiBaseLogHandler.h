//
//  KwaiBaseLogHandler.h
//  KwaiBase
//
//  Created by 小火神 on 2017/7/24.
//  Copyright © 2017年 Kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,KWAIBaseLogLevel){
    KWAIBaseLogLevelVerbose,
    KWAIBaseLogLevelInfo,
    KWAIBaseLogLevelWarning,
    KWAIBaseLogLevelError,
    KWAIBaseLogLevelOFF = 10
};

@protocol KwaiBaseLogHandler <NSObject>

- (void)kwai_logWithLevel:(KWAIBaseLogLevel)level
                      file:(NSString *)file
                  function:(NSString *)function
                      line:(int)line
                   message:(NSString *)message;

@end

@interface KwaiBaseLogHandler : NSObject

+ (instancetype)defaultHandler;

@property (nonatomic,weak) id<KwaiBaseLogHandler>handler;

- (void)logWithLevel:(KWAIBaseLogLevel)level
                file:(NSString *)file
            function:(NSString *)function
                line:(int)line
             message:(NSString *)message;

- (void)logWithLevel:(KWAIBaseLogLevel)level
             context:(int)context
                file:(NSString *)file
            function:(NSString *)function
                line:(int)line
             message:(NSString *)message;

#pragma mark - Extend File Logger

- (void)addLogHandler:(id<KwaiBaseLogHandler>)handler context:(int)context;

- (void)removeLogHandler:(int)context;

- (id<KwaiBaseLogHandler>)getLogHandler:(int)context;

@end
