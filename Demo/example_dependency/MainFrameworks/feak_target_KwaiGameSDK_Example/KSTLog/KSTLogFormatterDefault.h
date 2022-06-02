//
//  KSTLogFormatterDefault.h
//  KSTLog
//
//  Created by liushengxiang on 2020/6/4.
//

#import <Foundation/Foundation.h>
#import "KSTLogFormatterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  日志格式：[日志级别][模块][标签1]...[标签N][描述][参数][扩展字段]
 */

@interface KSTLogFormatterDefault : NSObject <KSTLogFormatterProtocol>

@end

NS_ASSUME_NONNULL_END
