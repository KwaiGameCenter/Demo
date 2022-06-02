//
//  KSCarrierPublicHeader.h
//  KSCarrierInfo
//
//  Created by Kealdish Xu on 2019/12/11.
//  Copyright © 2019 Kealdish. All rights reserved.
//

#ifndef KSCarrierPublicHeader_h
#define KSCarrierPublicHeader_h

typedef NS_ENUM(NSUInteger, KSCarrierType) {
    KSCarrierType_Unknown       = 0,    // 未知
    KSCarrierType_ChinaMobile   = 1,    // 中国移动
    KSCarrierType_ChinaUnicom   = 2,    // 中国联通
    KSCarrierType_Telecom       = 3,    // 中国电信
    KSCarrierType_Others        = 9,    // 其他运营商
};

typedef NS_ENUM(NSUInteger, KSNetworkState) {
    KSNetworkState_NotConnected = 0,    // 无网络
    KSNetworkState_2G           = 1,    // 2G
    KSNetworkState_3G           = 2,    // 3G
    KSNetworkState_4G           = 3,    // 4G
    KSNetworkState_Unkown       = 4,    // 未知
    KSNetworkState_WIFI         = 5,    // WIFI
    KSNetworkState_5G_NSA       = 6,    // 5G_NSA
    KSNetworkState_5G_SA        = 7,    // 5G_SA
};

// 自定义的换卡消息通知
OBJC_EXTERN NSString *const KSUSIMCardDidChangeNotification;

#endif /* KSCarrierPublicHeader_h */
