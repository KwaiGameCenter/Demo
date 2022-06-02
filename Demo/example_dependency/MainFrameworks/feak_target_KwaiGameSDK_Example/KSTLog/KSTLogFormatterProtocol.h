//
//  KSTLogFormatterProtocol.h
//  KSTLog
//
//  Created by liushengxiang on 2020/6/4.
//

#import <Foundation/Foundation.h>

@class KSTLogger, KSTLogMessage;

NS_ASSUME_NONNULL_BEGIN

@protocol KSTLogFormatterProtocol <NSObject>

/// 格式化日志
- (void)kstLogger:(KSTLogger *)logger formatLogMessage:(KSTLogMessage *)message;

@end

NS_ASSUME_NONNULL_END
