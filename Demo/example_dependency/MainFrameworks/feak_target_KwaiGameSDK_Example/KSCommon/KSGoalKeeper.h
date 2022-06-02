//
//  KSGoalKeeper.h
//  gif
//
//  Created by 薛辉 on 8/5/15.
//  Copyright (c) 2015 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NSString *ks_clientKey();
NSString *ks_addressBookKey();

@interface KSGoalKeeper : NSObject

/// 生成 sig 签名。
/// @param params 参数列表。
+ (NSString *)generateSig:(NSDictionary *)params;
/// 按规则拼接参数。
/// @param params 参数列表
+ (NSString *)joinedParams:(NSDictionary *)params;
/// MD5 处理字符串。
/// @param string 待处理的字符串。
+ (NSString *)generateSigString:(NSString *)string;

+ (NSString *)md5HexDigest:(NSString *)input;
+ (NSString *)md5HexDigestForData:(NSData *)input;

@end

NS_ASSUME_NONNULL_END
