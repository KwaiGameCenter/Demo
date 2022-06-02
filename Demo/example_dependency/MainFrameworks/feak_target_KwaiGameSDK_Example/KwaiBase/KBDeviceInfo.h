//
//  KBDeviceInfo.h
//  KwaiBase
//
//  Created by long on 2017/2/9.
//  Copyright © 2017年 Kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KBDeviceInfo : NSObject

+ (NSString *)uniqueGlobalDeviceIdentifier;

+ (NSString *)idfa;

+ (NSString *)idfv;

+ (NSString *)systemVersion;

+ (NSString *)deviceVersion;

+ (BOOL)isJailBroken;

#pragma mark -- Disk

+ (long long)freeDiskSpaceInBytes;

+ (long long)totalDiskSpaceInBytes;

#pragma mark -- Memory

+ (long long)totalMemorySizeInBytes;

+ (long long)availableMemorySizeInBytes;

#pragma mark -- CPU

+ (NSString *)cpuType;

+ (NSUInteger)cpuCount;

+ (NSArray<NSNumber *> *)perCpuUsage;

@end
