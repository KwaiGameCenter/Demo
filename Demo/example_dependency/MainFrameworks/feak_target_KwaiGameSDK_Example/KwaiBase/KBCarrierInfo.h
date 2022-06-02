//
//  KBCarrierInfo.h
//  KwaiBase
//
//  Created by long on 2017/2/9.
//  Copyright © 2017年 Kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KBCarrierInfo : NSObject

// Carrier Name
+ (NSString *)carrierName;

// Carrier Country
+ (NSString *)carrierCountry;

// Carrier Mobile Country Code
+ (NSString *)carrierMobileCountryCode;

// Carrier ISO Country Code
+ (NSString *)carrierISOCountryCode;

// Carrier Mobile Network Code
+ (NSString *)carrierMobileNetworkCode;

// Carrier Allows VOIP
+ (BOOL)carrierAllowsVOIP;

+ (NSString *)currentRadioAccessTechnology;

@end
