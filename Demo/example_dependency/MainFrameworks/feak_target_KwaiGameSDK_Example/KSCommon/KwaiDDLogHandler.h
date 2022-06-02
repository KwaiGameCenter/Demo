//
//  KwaiDDLogManager.h
//  AFNetworking
//
//  Created by 小火神 on 2017/10/19.
//

#import <Foundation/Foundation.h>
#import <KSCommon/KwaiBaseLog.h>

@interface KwaiDDLogHandler : NSObject <KwaiBaseLogHandler>

- (instancetype)initWithLogDirectory:(NSString *)logDirectory;

- (instancetype)initWithLogDirectory:(NSString *)logDirectory fileSizeMB:(int)fileSizeMB fileNumbers:(int)fileNumbers context:(int)context prefix:(NSString *)prefix;

@property (nonatomic,readonly) NSString *logDirectory; // default : /Cache/logs
@property (nonatomic,readonly) int fileSizeMB; // default : 1
@property (nonatomic,readonly) int fileNumbers; // default : 10
@property (nonatomic,readonly) int context; // default: 666
@property (nonatomic,readonly) NSString *prefix;    // default: nil

@property (nonatomic,assign) KWAIBaseLogLevel filterLevel;
@property (nonatomic,assign) BOOL enableConsoleLog; // default: NO
@property (nonatomic,assign) BOOL enableFileLog;    // default: YES

- (void)kwai_logWithLevel:(KWAIBaseLogLevel)level
              filterLevel:(KWAIBaseLogLevel)filterLevel
                     file:(NSString *)file
                 function:(NSString *)function
                     line:(int)line
                  message:(NSString *)message;

@end
