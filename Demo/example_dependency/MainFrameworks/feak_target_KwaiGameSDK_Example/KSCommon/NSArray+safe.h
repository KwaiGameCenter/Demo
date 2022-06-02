//
//  NSArray+safe.h
//  QWeiboSDK4iOSDemo
//
//  Created by zhongchao.han on 14/12/10.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (safe)

/**
 * 如果index越界，返回nil，而不是crash
 */
- (id)safe_objectAtIndex:(NSUInteger)index;

- (NSArray *)randomArray;

@end
