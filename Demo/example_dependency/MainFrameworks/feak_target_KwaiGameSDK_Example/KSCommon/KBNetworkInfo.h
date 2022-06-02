//
//  KBNetworkInfo.h
//  KwaiBase
//
//  Created by long on 2017/2/9.
//  Copyright © 2017年 Kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KBNetworkInfo : NSObject

// Network Information

// Get Current IP Address
+ (NSString *)currentIPAddress;

// Get Current MAC Address
+ (NSString *)currentMACAddress;

// Get the External IP Address
+ (NSString *)externalIPAddress;

// Get Cell IP Address
+ (NSString *)cellIPAddress;

// Get Cell MAC Address
+ (NSString *)cellMACAddress;

// Get Cell Netmask Address
+ (NSString *)cellNetmaskAddress;

// Get Cell Broadcast Address
+ (NSString *)cellBroadcastAddress;

// Get WiFi IP Address
+ (NSString *)wiFiIPAddress;

// Get WiFi MAC Address
+ (NSString *)wiFiMACAddress;

// Get WiFi Netmask Address
+ (NSString *)wiFiNetmaskAddress;

// Get WiFi Broadcast Address
+ (NSString *)wiFiBroadcastAddress;

// Get WiFi SSID
+ (NSString *)fetchSSIDInfo;

// Connected to WiFi?
+ (BOOL)connectedToWiFi;

// Connected to Cellular Network?
+ (BOOL)connectedToCellNetwork;

@end
