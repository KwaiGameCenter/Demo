//
//  MJMutableContainerSafeProxy.h
//  MJMutableContainerSafeProxy
//
//  Created by Hale Chan on 16/3/30.
//  Copyright © 2016年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  线程安全的MutableDictionary/NSMutableArray/NSMutableSet
 */
@interface MJMutableContainerSafeProxy : NSProxy

+ (NSMutableDictionary *)dictionary;
+ (NSMutableArray *)array;
+ (NSMutableSet *)set;

@end
