//
//  NSDate+KSAge.h
//  gif
//
//  Created by neeeo on 2017/7/17.
//  Copyright © 2017年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (KSAge)

/**
 @abstract 通过生日算年龄
 @return 返回生日
 */
- (NSInteger)ks_getAge;

/**
 @abstract 返回年月日形式的生日
 @return yyyy-mm-dd
 */
- (NSString*)ks_getBirthdayString;

@end
