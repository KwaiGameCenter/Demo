//
//  ASIdentifierManager+IDFA.h
//  KSCommon
//
//  Created by 孟宪璞 on 2020/8/31.
//

#import <AdSupport/AdSupport.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASIdentifierManager (IDFA)

// 交换后调用的是 `advertisingIdentifier` 为了KSCommon内部使用
- (NSUUID *)ks_advertisingIdentifier;

// [ASIdentifierManager sharedManager] 每次返回的不是同一个对象，所以使用类属性
@property (class, nonatomic, assign) BOOL openAssert;

@end

NS_ASSUME_NONNULL_END
