//
//  NSObject+LcInvokeAllMethod.h
//  LcCategoryPropertySample
//
//  Created by 刘玮 on 2016/12/6.
//  Copyright © 2016年 Kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LcInvokeAllMethod)

/**
 *  通过selector调用所有实例的方法，包括被category覆盖的方法
 *  @param selector 要调用方法的selector
 *  @param firstParameter 首个参数
 */

- (void)invokeAllInstanceMethodWithSelector:(SEL)selector;

- (void)invokeAllInstanceMethodWithSelector:(SEL)selector withParameters: (id)firstParameter, ...;

/**
 *  通过selector调用所有类的方法，包括被category覆盖的方法
 *  @param selector 方法的selector
 *  @param firstParameter 首个参数
 */

+ (void)invokeAllClassMethodWithSelector:(SEL)selector;

+ (void)invokeAllClassMethodWithSelector:(SEL)selector withParameters: (id)firstParameter, ...;

@end
