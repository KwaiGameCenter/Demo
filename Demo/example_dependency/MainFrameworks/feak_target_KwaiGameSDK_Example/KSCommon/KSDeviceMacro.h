//
//  KSDeviceMacro.h
//  Appirater-Appirater
//
//  Created by 舒祯 on 2019/1/3.
//

#import <UIKit/UIKit.h>
#import <KSCommon/UIDeviceHardware.h>

#define iPhone5 (!UIDeviceHardware.belowIphone4S)
#define iPhone5And4 (([UIDeviceHardware deviceModel].majorVersion <= 6) || ((KSDeviceModelX86_64 == [UIDeviceHardware deviceModel].category || KSDeviceModelI386 == [UIDeviceHardware deviceModel].category) && 320 == MIN(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))))
#define iPhoneX ([UIDeviceHardware isIPhoneX])
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define isXsMax ([UIDeviceHardware isIPhoneXsMax])

#define Ver5 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.9)
#define Ver6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.9)
#define Ver7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.9)
#define Ver8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.9)
#define Ver9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.9)

