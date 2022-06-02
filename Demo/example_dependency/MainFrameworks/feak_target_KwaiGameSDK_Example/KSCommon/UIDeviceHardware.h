//
//  UIDeviceHardware.h
//  QWeiboSDK4iOSDemo
//
//  Created by zhongchao.han on 14-9-25.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, KSDeviceModelCategory) {
    KSDeviceModelUnknown = 0,
    KSDeviceModelIPhone = 1,
    KSDeviceModelIPad = 2,
    KSDeviceModelIPod = 3,
    KSDeviceModelX86_64,
    KSDeviceModelI386
};

typedef NS_ENUM(NSUInteger, KSIPhoneHardwareLevel) {
    KSIPhoneHardwareLevel1 = 1, // iPhone & iPhone 3G
    KSIPhoneHardwareLevel2 = 2, // iPhone 3GS
    KSIPhoneHardwareLevel3 = 3, // iPhone 4
    KSIPhoneHardwareLevel4 = 4, // iPhone 4S
    KSIPhoneHardwareLevel5 = 5, // iPhone 5 & iPhone 5c
    KSIPhoneHardwareLevel6 = 6, // iPhone 5S
    KSIPhoneHardwareLevel7 = 7, // iPhone 6 & iPhone 6 Plus
    KSIPhoneHardwareLevel8 = 8, // iPhone 6S & iPhone 6S Plus & iPhone SE
    KSIPhoneHardwareLevel9 = 9, // iPhone 7 & iPhone 7 Plus
    KSIPhoneHardwareLevel10 = 10, // iPhone 8 & iPhone 8 Plus & iPhone X
    KSIPhoneHardwareLevel11 = 11, // iPhone XS & iPhone XS Max & iPhone XR
    KSIPhoneHardwareLevel12 = 12, // iPhone 11 & iPhone 11 Pro & iPhone 11 Pro Max & iPhone SE2
    KSIPhoneHardwareLevel13 = 13  // iPhone 12 & iPhone 12 Pro & iPhone 12 Pro Max & iPhone 12 Mini
};

typedef NS_ENUM(NSUInteger, KSIPadHardwareLevel) {
    KSIPadHardwareLevel1 = 1, // iPad
    KSIPadHardwareLevel2 = 2, // iPad 2 & iPad Mini
    KSIPadHardwareLevel3 = 3, // iPad 3 & iPad 4
    KSIPadHardwareLevel4 = 4, // iPad Air & iPad Mini 2 & iPad Mini 3
    KSIPadHardwareLevel5 = 5, // iPad Air 2 & iPad Mini 4
    KSIPadHardwareLevel6 = 6, // iPad Pro 9.7-inch & iPad Pro 12.9-inch & iPad (5th generation)
    KSIPadHardwareLevel7 = 7, // iPad Pro 10.5-inch & iPad Pro 12.9-inch (2nd generation) & iPad (6th generation)
    KSIPadHardwareLevel8 = 8  // iPad Pro 11-inch & iPad Pro 12.9-inch (3rd generation)
};

typedef NS_ENUM(NSUInteger, KSIPodTouchHardwareLevel) {
    KSIPodTouchHardwareLevel1 = 1, // iPod Touch
    KSIPodTouchHardwareLevel2 = 2, // iPod Touch (2nd generation)
    KSIPodTouchHardwareLevel3 = 3, // iPod Touch (3rd generation)
    KSIPodTouchHardwareLevel4 = 4, // iPod Touch (4th generation)
    KSIPodTouchHardwareLevel5 = 5, // iPod Touch (5th generation)
    KSIPodTouchHardwareLevel7 = 7, // iPod Touch (6th generation)
    KSIPodTouchHardwareLevel9 = 9  // iPod Touch (7th generation)
};


@interface KSDeviceModel : NSObject

@property (nonatomic, assign) KSDeviceModelCategory category;
@property (nonatomic, assign) int majorVersion;
@property (nonatomic, assign) int minorversion;

+ (instancetype)deviceModelWithString:(NSString *)model;

@end

@interface UIDeviceHardware : NSObject

+ (NSString *)platform;
+ (NSString *)platformString;

+ (BOOL)belowIphone4S;
+ (BOOL)isIPhone5;

+ (BOOL)isIPhoneX;

/**
 * 根据屏幕size判断机型
 * 同宏定义: isXsMax
 */
+ (BOOL)isIPhoneXsMax;

/**
 *  是否为全面屏iPad设备
 */
+ (BOOL)isFullScreenIPad;

/**
 *  是否为全面屏iOS设备（包含iPhone与iPad）
 */
+ (BOOL)isFullScreenDevice;

/**
 * 根据高宽比判断全面屏
 * 同宏定义: KWAI_IS_ALL_SCREEN_DEVICE
 */
+ (BOOL)isALLScreenDevice;

/// FYI: dynamic为高风险敏感词，所以替换为别的词
+ (BOOL)isSupportAdaptiveWallPaper;

// 判断 iPhone 设备等级
+ (BOOL)isEqualOrAboveIPhoneLevel:(KSIPhoneHardwareLevel)level;

// 判断 iPad 设备等级
+ (BOOL)isEqualOrAboveIPadLevel:(KSIPadHardwareLevel)level;

// 判断 iPod Touch 设备等级
+ (BOOL)isEqualOrAboveIPodLevel:(KSIPodTouchHardwareLevel)level;

// 是否是低性能设备
+ (BOOL)isLowPerformanceDevice;

// iPhone 5s, ipod都不支持，iPad Air
+ (BOOL)isHighProfile;

// iPhone 6S/6S+, ipod都不支持，iPad Air 2
+ (BOOL)isToplevelDevice;

// iPhone 5s, ipod 默认都支持，iPad 默认都支持
// 目前用于编辑编码音频
+ (BOOL)isBelowIphone5S;


// 用于检查机型是否满足打开265硬解的条件
+ (BOOL)isDeviceSupportVodH265Hw;

// 用于检测机型是否满足开启OOM监控的条件（iPhone 7及以上）
+ (BOOL)isEqualOrAboveIphone7;

+ (NSUInteger)memoryUsed;

/**
 * 返回小写的国家编号
 */
+ (NSString*)countryCode;

/**
 * 返回手机所在国家的电话区号
 */
+ (NSString*)contryPhoneCode;

+ (KSDeviceModel *)deviceModel;

@end
