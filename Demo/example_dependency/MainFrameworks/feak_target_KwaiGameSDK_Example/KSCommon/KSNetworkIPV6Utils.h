//
//  KSNetworkIPV6Utils.h
//  Pods
//
//  Created by 舒祯 on 2019/7/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KSNetworkIPV6Utils : NSObject

// 排除fe开头的IPv6
+ (nullable NSArray<NSString *> *)getAllWifiValidIPv6Address;
+ (nullable NSArray<NSString *> *)getAllCellValidIPv6Address;

+ (NSArray *)cellIPAddresses:(BOOL)isIPv4;

@end

NS_ASSUME_NONNULL_END
