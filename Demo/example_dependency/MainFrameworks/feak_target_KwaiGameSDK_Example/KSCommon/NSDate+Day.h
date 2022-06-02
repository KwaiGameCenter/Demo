//
//  NSDate+Day.h
//  gif
//
//  Created by Hale Chan on 16/3/11.
//  Copyright © 2016年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Day)

@property (nonatomic, readonly) BOOL isToday;
- (BOOL)isSameDay:(NSDate *)otherDate;
+ (BOOL)is2020NYE;

- (NSInteger)daysCountFromDate:(NSDate *)date;

/*
 date是否在一天的startTime和endTime的时间段中
 startTime： 开始的时间（24进制）
 endTime： 结束的时间（24进制）
 */
- (BOOL)isBetweenStartTime:(NSUInteger)startTime endTime:(NSUInteger)endTime;

@end
