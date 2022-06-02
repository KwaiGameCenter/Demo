//
//  UIDevice+Info.h
//  KSCommon
//
//  Created by 孟宪璞 on 2020/8/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Info)

/**
 *  保存实时计算的IDFA, 需要在用户变更IDFA获取权限的时候手动调用 setIdfaNeedUpdate 方法，
 *  因此本方法值的准确性依赖外部，通常在 applicationDidBecomeActive 中设置为需要重新获取。
 */
+ (nullable NSString *)ks_idfaWithMemoryCache;
+ (void)ks_setIdfaNeedUpdate:(BOOL)update hotLaunch:(BOOL)hotLaunch;

/**
 *  该方法在 iOS 14 上也不会主动弹窗请求权限，仅会根据当前状态获取idfa
 */
+ (nullable NSString *)ks_idfaWithoutStore;

/**
 *  该方法在 iOS 14 上也不会主动弹窗请求权限，仅会根据当前状态获取idfa并且更新keychain缓存。
 *  如果不能从系统方法获取到，则会返回 keychain 中缓存的。
 */
+ (nullable NSString *)ks_idfaWithStore;

/**
 *  无效 idfa 返回 nil
 */
+ (nullable NSString *)validIdfaFromIdfa:(NSString *)idfa;

@end

NS_ASSUME_NONNULL_END
