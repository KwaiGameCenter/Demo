//
//  KwaiBaseLog.h
//  KwaiBase
//
//  Created by 小火神 on 2017/7/24.
//  Copyright © 2017年 Kuaishou. All rights reserved.
//

#ifndef KwaiBaseLog_h
#define KwaiBaseLog_h

#import "KwaiBaseLogHandler.h"

/*
#define KWAI_LOG_INFO(FORMAT, ...) DDLogInfo((@"[FILE:%s]" "[FUNC:%s]" "[LINE:%d] %@\n"), __FILE__, __FUNCTION__, __LINE__, [NSString stringWithFormat:FORMAT, ##__VA_ARGS__])
#define KWAI_LOG_ERROR(FORMAT, ...) DDLogError((@"[FILE:%s]" "[FUNC:%s]" "[LINE:%d] %@\n"), __FILE__, __FUNCTION__, __LINE__, [NSString stringWithFormat:FORMAT, ##__VA_ARGS__])
#define KWAI_LOG_WARN(FORMAT, ...) DDLogWarn((@"[FILE:%s]" "[FUNC:%s]" "[LINE:%d] %@\n"), __FILE__, __FUNCTION__, __LINE__, [NSString stringWithFormat:FORMAT, ##__VA_ARGS__])
#define KWAI_LOG_VERBOSE(FORMAT, ...) DDLogVerbose((@"[FILE:%s]" "[FUNC:%s]" "[LINE:%d] %@\n"), __FILE__, __FUNCTION__, __LINE__, [NSString stringWithFormat:FORMAT, ##__VA_ARGS__]) */

//#else

#define KWAI_LOG_INFO(FORMAT, ...) KWAI_LOG(KWAIBaseLogLevelInfo,FORMAT,##__VA_ARGS__)
#define KWAI_LOG_VERBOSE(FORMAT, ...) KWAI_LOG(KWAIBaseLogLevelVerbose,FORMAT,##__VA_ARGS__)
#define KWAI_LOG_WARN(FORMAT, ...) KWAI_LOG(KWAIBaseLogLevelWarning,FORMAT,##__VA_ARGS__)
#define KWAI_LOG_ERROR(FORMAT, ...) KWAI_LOG(KWAIBaseLogLevelError,FORMAT,##__VA_ARGS__)

#define KWAI_CONTEXT_LOG_INFO(context,FORMAT, ...) KWAI_CONTEXT_LOG(KWAIBaseLogLevelInfo,context,FORMAT,##__VA_ARGS__)
#define KWAI_CONTEXT_LOG_VERBOSE(context,FORMAT, ...) KWAI_CONTEXT_LOG(KWAIBaseLogLevelVerbose,context,FORMAT,##__VA_ARGS__)
#define KWAI_CONTEXT_LOG_WARN(context,FORMAT, ...) KWAI_CONTEXT_LOG(KWAIBaseLogLevelWarning,context,FORMAT,##__VA_ARGS__)
#define KWAI_CONTEXT_LOG_ERROR(context,FORMAT, ...) KWAI_CONTEXT_LOG(KWAIBaseLogLevelError,context,FORMAT,##__VA_ARGS__)

#ifdef DEBUG
    #define KWAI_LOG_CONSOLE(FORMAT,...) NSLog(@"[FILE:%s]" "[FUNC:%s]" "[LINE:%d] %@\n",__FILE__, __FUNCTION__, __LINE__, [NSString stringWithFormat:FORMAT, ##__VA_ARGS__])
#else
    #define KWAI_LOG_CONSOLE(FORMAT,...)
#endif

#define KWAI_LOG(logLevel,FORMAT,...) \
    [[KwaiBaseLogHandler defaultHandler] logWithLevel:logLevel \
                                                 file:[NSString stringWithUTF8String:__FILE__] \
                                             function:[NSString stringWithUTF8String:__FUNCTION__] \
                                                 line:__LINE__ \
                                              message:[NSString stringWithFormat:FORMAT, ##__VA_ARGS__]]

#define KWAI_CONTEXT_LOG(logLevel,logContext,FORMAT,...) \
    if ([[KwaiBaseLogHandler defaultHandler] respondsToSelector:@selector(logWithLevel:context:file:function:line:message:)]) {\
        [[KwaiBaseLogHandler defaultHandler] logWithLevel:logLevel \
                                                  context:logContext   \
                                                     file:[NSString stringWithUTF8String:__FILE__] \
                                                 function:[NSString stringWithUTF8String:__FUNCTION__] \
                                                     line:__LINE__ \
                                                  message:[NSString stringWithFormat:FORMAT, ##__VA_ARGS__]];  \
    } else {    \
        NSLog(@"Not Support Log With Different Context"); \
    }

#endif /* KwaiBaseLog_h */
