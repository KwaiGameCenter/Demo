//
//  KSTLogPluginProtocol.h
//  KSTLog
//
//  Created by liushengxiang on 2020/6/3.
//

#import <Foundation/Foundation.h>

@class KSTLogger, KSTLogMessage;

NS_ASSUME_NONNULL_BEGIN

@protocol KSTLogPluginProtocol <NSObject>

@optional

/// 将输出日志
- (void)kstLogger:(KSTLogger *)logger willLogMessage:(KSTLogMessage *)message;

/// 输出日志
- (void)kstLogger:(KSTLogger *)logger logMessage:(KSTLogMessage *)message;

/// 已输出日志
- (void)kstLogger:(KSTLogger *)logger didLogMessage:(KSTLogMessage *)message;

/// 是否共享插件实例
+ (BOOL)kstLoggerCanShareInstance:(KSTLogger *)logger;

@end

NS_ASSUME_NONNULL_END
