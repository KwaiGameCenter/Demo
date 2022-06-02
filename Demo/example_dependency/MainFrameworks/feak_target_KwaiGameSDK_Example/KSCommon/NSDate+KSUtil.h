//
//  NSDate+KSUtil.h
//  gif
//
//  Created by tanbing on 2017/12/13.
//  Copyright © 2017年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (KSUtil)

- (uint64_t)millisecondsSince1970;

- (uint64_t)millisecondsSinceDate:(NSDate *)anotherDate;

@end
