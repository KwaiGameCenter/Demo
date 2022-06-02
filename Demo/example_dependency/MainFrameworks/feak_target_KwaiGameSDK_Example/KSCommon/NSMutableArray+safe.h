//
//  NSMutableArray+safe.h
//  QWeiboSDK4iOSDemo
//
//  Created by zhongchao.han on 14/12/10.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (safe)

/**
 * 防止因为object为空引起crash
 */
- (void)safe_addObject:(id)object;

/**
 * 防止因nill，或者out of bounds crash
 */
- (void)safe_insertObject:(id)object atIndex:(NSUInteger)index;

/**
 * 替换指定位置的object，如果object为nil，或者index越界，不会crash
 */
- (void)safe_replaceObjectAtIndex:(NSUInteger)index withObject:(id)object;

/**
 * 删除对象
 */
- (void)safe_removeObject:(id)object;

/**
 * 安全删除某位置的对象
 */
- (void)safe_removeObjectAtIndex:(NSUInteger)index;

/**
 * 安全删除最后一个对象
 */
- (void)safe_removeLastObject;

@end
