//
//  KSTLoggerConfig.h
//  KSTLog
//
//  Created by liushengxiang on 2020/11/23.
//

#import <Foundation/Foundation.h>
#import <KSTLog/KSTLogMessage.h>

NS_ASSUME_NONNULL_BEGIN

@interface KSTLoggerConfig : NSObject

/// 开启日志输出。默认为YES。
@property (atomic) BOOL enableLog;

/// 开启降级输出，enableLog为NO时生效。默认为YES。
@property (atomic) BOOL enableDowngrade;

/**
 *  最低输出级别，数值小于设定值的日志会输出。
 *  默认：KSTLogLevelInfo
 *  DEBUG：KSTLogLevelDebug
 */
@property (atomic) KSTLogLevel outputLevel;

/// 原始配置json，框架不读取，仅用于记录和透传
@property (atomic, copy) NSDictionary *originInfo;

@end

NS_ASSUME_NONNULL_END
