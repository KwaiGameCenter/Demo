//
//  KSTLogger.h
//  KSTLog
//
//  Created by liushengxiang on 2020/6/1.
//

#import <Foundation/Foundation.h>
#import <KSTLog/KSTLoggerConfig.h>
#import <KSTLog/KSTLogMessage.h>

@protocol KSTLogFormatterProtocol, KSTLogPluginProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface KSTLogger : NSObject

/**
 *  日志配置
 */
@property (atomic, strong, readonly) KSTLoggerConfig *logConfig;

/**
 *  日志格式化，默认为 KSTLogFormatterDefault
 */
@property (nonatomic, strong) id<KSTLogFormatterProtocol> logFormatter;

/**
 *  日志队列
 */
@property (nonatomic, strong, readonly) dispatch_queue_t logQueue;

+ (instancetype)sharedInstance;

/**
 *  @brief 更新日志配置
 *  @param config  配置
 */
- (void)setupWithConfig:(KSTLoggerConfig *)config;

/// 设置DDLog是否异步创建DDLogMessage对象
/// @param async 是否异步
+ (void)setupDDlogAsyncCreateMessage:(BOOL)async;

/**
 *  @brief 更新全局插件注册表，logger子类初始化时默认注册全局插件
 *  @param className  插件类名
 *  @param key  插件唯一标识
 *  @return 是否注册成功
 */
+ (BOOL)registerGlobalPlugin:(NSString *)className forKey:(NSString *)key;

/**
 *  @brief 注册插件
 *  @param className  插件类名
 *  @param key  插件唯一标识
 *  @return 是否注册成功
 */
- (BOOL)registerPlugin:(NSString *)className forKey:(NSString *)key;

/**
 *  @brief 查询已注册插件
 *  @param key  插件唯一标识
 *  @return 插件实例
 */
- (id<KSTLogPluginProtocol>)queryPluginForKey:(NSString *)key;

/**
 *  @brief 日志基础接口
 *  @param level  日志等级
 *  @param module  模块
 *  @param tags  标签
 *  @param file  文件路径
 *  @param function  函数
 *  @param line  行数
 *  @param desc  描述
 *  @param params  参数
 *  @param extend  扩展字段
 *  @discussion 深拷贝 params 和 extend 中的数组和字典，不强引用除 NSString、NSValue、NSNull 以外的数据类型，弱引用取值时需要解包 KSTWeakWrapper。
 */
- (void)log:(KSTLogLevel)level
     module:(nullable NSString *)module
       tags:(nullable NSArray<NSString *> *)tags
       file:(const char *)file
   function:(nullable const char *)function
       line:(NSUInteger)line
       desc:(NSString *)desc
     params:(nullable NSDictionary *)params
     extend:(nullable NSDictionary *)extend;

/// /// 要求必传module和tag的方法,DEBUG环境会有强校验和NSAssert提醒
/// @param level 日志级别
/// @param module 模块名
/// @param tags 自定义的标签
/// @param file 调用日志的文件名
/// @param function 调用日志的方法名
/// @param line 调用日志的行号
/// @param format 携带可变参数的日志内容
- (void)kst_log:(KSTLogLevel)level
         module:(NSString *)module
           tags:(NSArray<NSString *> *)tags
           file:(const char *)file
       function:(nullable const char *)function
           line:(NSUInteger)line
         format:(NSString *)format, ... NS_FORMAT_FUNCTION(7,8);

/// 要求必传module和tag的方法,DEBUG环境会有强校验和NSAssert提醒
/// @param level 日志级别
/// @param module 模块名
/// @param tags 自定义的标签
/// @param file 调用日志的文件名
/// @param function 调用日志的方法名
/// @param line 调用日志的行号
/// @param desc 日志内容
/// @param params 日志内容中的变量,可以通过key value形式使用,配套前端的展示页面可以基于参数去筛选日志
/// @param extend 预留参数
- (void)kst_log:(KSTLogLevel)level
         module:(NSString *)module
           tags:(NSArray<NSString *> *)tags
           file:(const char *)file
       function:(nullable const char *)function
           line:(NSUInteger)line
           desc:(NSString *)desc
         params:(nullable NSDictionary *)params
         extend:(nullable NSDictionary *)extend;

@end

NS_ASSUME_NONNULL_END
