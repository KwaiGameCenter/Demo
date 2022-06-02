//
//  KSCityHash.h
//  gif
//
//  Created by tanbing on 2018/5/21.
//  Copyright © 2018年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

// 移植AB Test平台生成hash的算法
@interface KSCityHash : NSObject

+ (NSString *)hashStringForString:(NSString *)str;

@end
