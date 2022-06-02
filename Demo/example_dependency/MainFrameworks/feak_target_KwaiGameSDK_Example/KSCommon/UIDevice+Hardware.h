//
//  UIDevice+Hardware.h
//  gif
//
//  Created by 薛辉 on 8/4/15.
//  Copyright (c) 2015 kuaishou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KSCommon/KSCarrierPublicHeader.h>

OBJC_EXTERN NSString * const kStatusBarTappedNotification;

@interface UIDevice (Hardware)

// 硬件型号
+ (NSString *)ks_deviceMode;

// 网络类型，返回KSNetworkState类型
+ (KSNetworkState)ks_networkStatus;
// 网络状态描述
+ (NSString *)ks_networkStatusDescription;
// 当前运营商
+ (NSString *)ks_carrierName;
// 是否中国
+ (BOOL)ks_isChina;
// 是否中国移动
+ (BOOL)ks_isChinaMobile API_DEPRECATED("双卡情况下不准确，可以使用 `ks_currentDataServiceIsChinaMobile`", ios(8.0, 13.0));
// 是否中国联通
+ (BOOL)ks_isChinaUnicom API_DEPRECATED("双卡情况下不准确，可以使用 `ks_currentDataServiceIsChinaUnicom`", ios(8.0, 13.0));
// 是否中国电信
+ (BOOL)ks_isChinaTelecom API_DEPRECATED("双卡情况下不准确，可以使用 `ks_currentDataServiceIsChinaTelecom`", ios(8.0, 13.0));

/**
 *  当前蜂窝数据提供的运营商
 */

+ (BOOL)ks_currentDataServiceIsChinaMobile API_AVAILABLE(ios(13.0));

+ (BOOL)ks_currentDataServiceIsChinaUnicom API_AVAILABLE(ios(13.0));

+ (BOOL)ks_currentDataServiceIsChinaTelecom API_AVAILABLE(ios(13.0));


/**
 * carrier与status一块
 */
+ (NSString *)ks_networkInfo;

/**
 * 手机机型
 */
+ (NSString*)ks_platform;

/**
 * cpu核数
 */
+ (NSUInteger)ks_cpuCoresCount;

/**
 * 系统版本
 */
+ (NSString*)ks_iosVersion;

/**
 * 内存总大小
 */
+ (NSUInteger)ks_totalMemory;

+ (unsigned)ks_freeMemory;

/**
 * 内存使用百分比
 */
+ (double)ks_memoryUsage;

/**
 * 像素为单位的屏幕大小
 */
+ (CGSize)ks_screenSizeInPixel;

/**
 * cpu使用百分比
 */
+ (float)ks_cpuUsage;

/**
 *  强制主线程执行 `setBatteryMonitoringEnabled`
 */
+ (void)ks_setBatteryMonitoringEnabledSafe:(BOOL)batteryMonitoringEnabled;

/**
 * 电池用量百分比
 */
+ (float)ks_battery;

/**
 * 是否充电中
 * 注：满格不是充电状态
 */
+ (BOOL)ks_charging;

/**
 * 获取音量百分比
 */
+ (float)ks_volume;

/**
 * 获取亮度百分比
 */
+ (float)ks_brightness;

/**
 * 正在运行的进程名称
 */
+ (NSMutableSet *)ks_runningProcesses;

/**
 * 是否插入耳机
 */
+ (BOOL)ks_usingEarphone;

/**
 * 磁盘总大小 bytes
 */
+ (uint64_t)ks_totalDiskSpace;

/**
 * 可用的剩余空间 bytes
 */
+ (uint64_t)ks_freeDiskSpace;

/**
 * 是否是越狱机型
 */
+ (BOOL)isJailBroken;

/**
 * appid
 */
+ (NSString *)appID;

/**
 * system version
 * iOS8 以后请使用NSProcessInfo
 */
+ (NSOperatingSystemVersion)ks_systemVersion;

/*
 当前wifi的bssid识别号
 */
+ (NSString *)currentWifiBSSID;

/*
 当前wifi的ssid识别号
 */
+ (NSString *)currentWifiSSID;

@end
