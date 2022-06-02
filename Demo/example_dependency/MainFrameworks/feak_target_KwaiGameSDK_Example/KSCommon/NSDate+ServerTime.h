//
//  NSDate+ServerTime.h
//  源码:可修改，install后生效
//
//  Created by 李宁 on 2019/7/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 服务端ntp校时 正常情况下 ks_syncServerTime 会进行多次重试请求时间戳请求来校准时间差(服务端与系统启动时间差,不会被手机修改时间等问题影响)
 在规定的次数内 成功请求或者达到最大重试次数 重试会有时间间隔 会停止重试
 外部调用ks_syncServerTime 后会触发内部重试校时
 内部在监听到网络状态改变的时候也会触发多次重试至成功  大概率降低在获取 服务端时间戳时候不准确或返回空的问题
 如果对时间戳要求比较高的地方 可以通过手动提前调用一次ks_syncServerTime 来进一步降低出错概率
 外部如果需要通过其他方式校时 可以通过ks_syncServerTimeWithDate 传入 但是内部会判断传入的是否误差比内部小 仅在误差较小的时候会成功同步否则会被丢弃
 */
@interface NSDate (ServerTime)

/**
 开启时间同步
 非主线程调用会回到主线程触发同步
 */
+ (void)ks_syncServerTime;


/**
 获取服务端时间戳，应用刚启动未校准之前可能为 nil，如不想处理异常，请使用 ks_safeServerDate

 @return 返回内部时间戳
 */
+ (nullable NSDate *)ks_serverDate;

/**
 获取安全服务端时间戳，如果 ks_serverDate 返回 nil，则返回 networkDate
 
 @return 返回内部时间戳
 */
+ (NSDate *)ks_safeServerDate;

/**
 外部更新服务端时间戳
 外部如需要更新时间戳要求误差必须比内部的误差小才能被成功更新
 非主线程调用会回调到主线程去更新
 @param date 外部提供的 date
 */
+ (void)ks_syncServerTimeWithDate:(NSDate *)date;

#pragma mark - socket server clock

+ (void)synchronizeWithSocketTimestamp:(uint64_t)socketTimetemp;

+ (NSDate *)ks_socketServerDate;

+ (NSTimeInterval)ks_timeIntervalOfSystemBootSince1970;

@end

NS_ASSUME_NONNULL_END
