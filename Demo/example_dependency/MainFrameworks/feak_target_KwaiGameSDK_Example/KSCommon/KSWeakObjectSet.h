//
//  KSWeakObjectSet.h
//  gif
//
//  Created by Hale Chan on 11/19/15.
//  Copyright © 2015 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 弱对象即将销毁时可以执行的block
 @param object 即将销毁的对象
 */
typedef void(^KSWeakObjectSetDeallocBlock)(id object);

/**
 *  弱对象集
 *  @notice 非线程安全
 */
@interface KSWeakObjectSet : NSObject

@property (readonly) NSUInteger count;
/**
 *  添加一弱引用的对象
 *
 *  @notice 反复插入同一个对象时，会有去重机制，可保证对象的唯一性。
 *
 *  @param object 一个对象
 */
- (void)addObject:(id)object;
- (void)removeObject:(id)object;
- (void)removeAllObjects;
- (NSArray *)objectsArray;
- (BOOL)containsObject:(id)object;
@end
