//
//  KSFileMD5Helper.h
//  gif
//
//  Created by wangpeng on 2017/11/23.
//  Copyright © 2017年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSFileMD5Helper : NSObject

+ (NSString *)getFileMD5WithPath:(NSString *)path;
@end
