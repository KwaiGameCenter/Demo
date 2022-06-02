//
//  NSIndexPath+KSConvenience.h
//  gif
//
//  Created by LiSi on 2018/1/22.
//  Copyright © 2018年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexSet (KSConvenience)

/**
 *  根据当前 index set 以及 section 入参创建 indexPath 数组
 */
- (NSArray *)ks_indexPathsFromIndexesWithSection:(NSUInteger)section;

@end
