//
//  KSNetworkManager+KSReachability.h
//  gif
//
//  Created by hanshaopeng on 2017/5/16.
//  Copyright © 2017年 kuaishou. All rights reserved.
//

#import <Reachability/Reachability.h>

typedef NS_ENUM (NSInteger, KSNetworkReachabilityStatus) {
    KSNetworkReachabilityStatusUnknown          = -1,               //等于AFNetworkReachabilityStatusUnknown
    KSNetworkReachabilityStatusNotReachable     = NotReachable,     //等于AFNetworkReachabilityStatusNotReachable
    KSNetworkReachabilityStatusReachableViaWWAN = ReachableViaWWAN, //等于AFNetworkReachabilityStatusReachableViaWWAN
    KSNetworkReachabilityStatusReachableViaWiFi = ReachableViaWiFi, //等于AFNetworkReachabilityStatusReachableViaWiFi
};

typedef void (^KSNetworkReachabilityStatusBlock)(KSNetworkReachabilityStatus status, KSNetworkReachabilityStatus previousNetworkStatus);
/**
 监听网络状态变化
 */
@interface KSReachabilityManager : NSObject

@property (nonatomic, assign, readonly) KSNetworkReachabilityStatus networkReachabilityStatus;
@property (nonatomic, assign, readonly) KSNetworkReachabilityStatus previousNetworkStatus;
+ (instancetype)sharedManager;

- (BOOL)isMonitoring;

/**
 Whether or not the network is currently reachable.
 */
@property (readonly, nonatomic, assign, getter = isReachable) BOOL reachable;

/**
 Whether or not the network is currently reachable via WWAN.
 */
@property (readonly, nonatomic, assign, getter = isReachableViaWWAN) BOOL reachableViaWWAN;

/**
 Whether or not the network is currently reachable via WiFi.
 */
@property (readonly, nonatomic, assign, getter = isReachableViaWiFi) BOOL reachableViaWiFi;

/**
 监听网络状态变化
 @param observer 监听者
 @param block 回调
 @param object cancel token
 */
- (id <NSObject> )addObserverForReachabilityChanged:(KSNetworkReachabilityStatusBlock)block;

/**
 @note 必须主动移除监听, 否则会造成block无法释放
 @param observer addObserver:返回的监听者token
 */
- (void)removeReachabilityObserver:(id <NSObject> )observerToken;

@end
