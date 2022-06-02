//
//  NSString+KSHashes.h
//  gif
//
//  Created by Hale Chan on 12/14/15.
//  Copyright © 2015 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>
// 字符串加密
@interface NSString (KSHashes)

- (NSString *)ks_sha512;
- (NSString *)ks_SHA256Hex;
- (NSString *)ks_md5;

/**
 *  返回128AES加密后在进行BASE64的字符串
 *
 *  @param data       待加密的数据
 *  @param key        秘钥
 *  @param initVector 加密中初始适量，如果传入一个值不为nil的对象引用，则使用该值，否则返回随机生成的initVector
 *
 *  @return base64(AES(data,key,initVector))
 */
+ (NSString *)encryptData:(NSData *)data
                  withKey:(NSData *)key
               initVector:(NSString *__autoreleasing *)initVector;

@end


@interface NSData (KSHex)

- (NSString *)ks_hexString;
+ (NSData *)ks_dataWithHexString:(NSString *)hex;

@end
