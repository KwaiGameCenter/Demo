//
//  KBCryptor.h
//  KwaiBase
//
//  Created by long on 2017/2/9.
//  Copyright © 2017年 Kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KBCryptor : NSObject

+ (NSData *)md5OfData:(NSData *)data;

+ (NSData *)md5:(NSString *)str;

+ (NSString *)md5HexDigest:(NSString *)str;

+ (NSData *)dataAES128Encrypt:(NSData *)data withKey:(NSData *)key andIv:(NSData *)iv;

+ (NSData *)dataAES128Decrypt:(NSData *)data withKey:(NSData *)key andIv:(NSData *)iv;

+ (NSData *)dataAES128EncryptRandomIv:(NSData *)data withKey:(NSData *)key;

+ (NSData *)dataAES128DecryptRandomIv:(NSData *)data withKey:(NSData *)key;

@end
