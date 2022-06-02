//
//  NSDate+MetaData.h
//  KSCommon
//
//  Created by tang xiaobing on 2020/3/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (MetaData)

- (NSInteger)ks_year;
- (NSInteger)ks_month;
- (NSInteger)ks_day;
- (NSInteger)ks_hour;
- (NSInteger)ks_minute;
- (NSInteger)ks_second;
- (NSInteger)ks_weekday;
- (NSInteger)ks_weekOfYear;
- (NSInteger)ks_weekOfMonth;

@end

NS_ASSUME_NONNULL_END
