//
//  KSCookieModel.h
//  KSCommon
//
//  Created by 舒祯 on 2019/8/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 用于url请求header中的cookie生成
@interface KSCookieModel : NSObject

// "key1=val1;key2=val2"
@property (nonatomic, copy, readonly, nullable) NSString *cookieStr;

- (instancetype)initWithCookieDictionary:(nullable NSDictionary *)cookie NS_DESIGNATED_INITIALIZER;

- (nullable NSString *)cookieValueForKey:(NSString *)key;

// key存在时，会覆盖原有的value; value为nil时，不会增加对应的cookie
- (void)addCookieValue:(nullable NSString *)value forKey:(NSString *)key;

- (void)removeCookieForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
