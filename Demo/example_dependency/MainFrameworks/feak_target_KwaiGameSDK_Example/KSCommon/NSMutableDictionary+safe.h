//
//  NSMutableDictionary+safe.h
//  QWeiboSDK4iOSDemo
//
//  Created by zhongchao.han on 14/12/10.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (safe)

/**
 * 防止key或者objec为nil，引起的crash。
 * 预防编码中忘记检测为nil，引起crash。
 */
- (void)safe_setObject:(id)object forKey:(id<NSCopying>)key;

- (void)safe_removeObjectForKey:(NSString *)key;

@end
