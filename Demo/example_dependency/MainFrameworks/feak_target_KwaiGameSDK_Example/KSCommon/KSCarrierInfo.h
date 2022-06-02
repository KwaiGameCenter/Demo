//
//  KSCarrierInfo.h
//  KSCarrierInfo
//
//  Created by Kealdish Xu on 2019/12/11.
//  Copyright © 2019 Kealdish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <KSCommon/KSCarrierPublicHeader.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CallKit/CXCall.h>
#import <CallKit/CXCallObserver.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CallEventHandler)(CTCall *call);

@interface KSCarrierInfo : NSObject

@property (nonatomic, strong, readonly) CTTelephonyNetworkInfo *networkInfo;

@property (nonatomic, strong, readonly) CXCallObserver *callObserver API_AVAILABLE(ios(10.0));

@property (nonatomic, strong, readonly) CTCallCenter *callCenter;

/// Access current carrier type of the device, default is KSCarrierType_Unknown.
@property (nonatomic, assign, readonly) KSCarrierType carrierType;

/// Returns a boolean value that indicates whether current carrier is in China. Default is YES.
@property (nonatomic, assign, readonly) BOOL isChineseCarrier;

/// Returns a boolean value that indicates whether the device uses single sim-card. Default is YES.
@property (nonatomic, assign, readonly) BOOL isSingleSIMCard;

/// Access current cellular state of the device, default is KSNetworkState_Unkown.
@property (nonatomic, assign, readonly) KSNetworkState cellularState;

/// Access current country code of the carrieKBNetworkInfo.mr instance. Default is cn.
@property (nonatomic, copy, readonly) NSString *countryCode;

/// Access current using carrier instance. Default is nil.
@property (nonatomic, strong, readonly) CTCarrier *carrier;

/// 当前使用的蜂窝数据来自哪个运营商
@property (nonatomic, assign, readonly) KSCarrierType currentDataServiceCarrierType API_AVAILABLE(ios(13.0));


/// Access the singleton instance of KSCarrierInfo.
/// Prefer to use +sharedInstance rather than -init or +new.
+ (instancetype)sharedInstance;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

// Carrier Name
+ (NSString *)carrierName;

// 添加CTCallCenter回调Block
- (void)addCallCenterObserver:(id)observer callback:(CallEventHandler)callback;

@end

NS_ASSUME_NONNULL_END
