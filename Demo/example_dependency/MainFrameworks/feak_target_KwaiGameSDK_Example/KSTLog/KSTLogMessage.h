//
//  KSTLogMessage.h
//  KSTLog
//
//  Created by liushengxiang on 2020/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 日志分级
typedef NS_ENUM(NSUInteger, KSTLogLevel) {
    KSTLogLevelUnknown  = 0,
    KSTLogLevelError    = (1 << 0),
    KSTLogLevelWarning  = (1 << 1),
    KSTLogLevelInfo     = (1 << 2),
    KSTLogLevelDebug    = (1 << 3),
};

@interface KSTLogMessage : NSObject

@property (nonatomic)                   KSTLogLevel         level;          /**< 日志等级 */
@property (nonatomic, copy)             NSString            *desc;          /**< 描述 */
@property (nonatomic, nullable, copy)   NSString            *module;        /**< 模块 */
@property (nonatomic, nullable, copy)   NSArray             *tags;          /**< 标签 */
@property (nonatomic, nullable, copy)   NSDictionary        *params;        /**< 参数 */
@property (nonatomic, nullable, copy)   NSDictionary        *extend;        /**< 扩展字段 */

@property (nonatomic, strong)           NSDate              *time;          /**< 时间戳 */
@property (nonatomic, copy)             NSString            *fileName;      /**< 文件名 */
@property (nonatomic, nullable, copy)   NSString            *function;      /**< 函数名 */
@property (nonatomic)                   NSUInteger          line;           /**< 行数 */
@property (nonatomic, nullable, copy)   NSString            *threadId;      /**< 线程id */
@property (nonatomic, nullable, copy)   NSString            *threadName;    /**< 线程名称 */
@property (nonatomic, nullable, copy)   NSString            *queueLabel;    /**< 队列标识 */

/**
 *  @brief      是否可输出，默认为YES
 *  @discussion 插件可通过预处理协议-kstLogger:willLogMessage:修改此属性，若取值为NO，表示阻止输出，将跳过后续的格式化和输出协议。
 */
@property (nonatomic) BOOL shouldLog;

/**
 *  @brief      格式化输出文本
 *  @discussion 通过logFormatter格式化协议-kstLogger:formatLogMessage:修改此属性，若取值为nil，表示无格式化输出内容，将跳过后续输出协议。
 */
@property (nonatomic, nullable, copy) NSString *formattedString;

@end

NS_ASSUME_NONNULL_END
