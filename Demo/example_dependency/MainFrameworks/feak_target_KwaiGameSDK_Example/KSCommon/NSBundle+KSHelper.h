//
//  NSBundle+KSHelper.h
//  gif
//
//  Created by 薛辉 on 8/5/15.
//  Copyright (c) 2015 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 给后端的的是
 */
@interface NSBundle (KSHelper)

/**
 * build number
 */
+ (NSString *)ks_mainBundleVersion;

/**
 * 3段的版本号，用于给统计平台用。原因是怕统计平台产生过多
 */
+ (NSString *)ks_mainBundleShortVersion;

+ (NSString *)ks_mainBundleId;

/**
 * 新的版本号,4段版本号
 */
+ (NSString*)majorMinorBugfixBuildVersion;
/**
 * 在 majorMinorBugfixBuildVersion 的基础上加了 debug／beta 标示
 * 如果有 commit id 也显示出来。
 */
+ (NSString*)displayMajorMinorBugfixBuildVersion;

/**
 * 旧参数传这个，2段版本号
 */
+ (NSString*)majorMinorVersion;

@end
