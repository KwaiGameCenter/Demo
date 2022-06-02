//
//  NSData+KSSecurity.h
//  gif
//
//  Created by 薛辉 on 11/10/16.
//  Copyright © 2016 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

@interface NSData (KSSecurity)

- (NSData *)ks_AESEncryptWithKey:(NSData *)key;
- (NSData *)ks_AESEncryptWithKey:(NSData *)key options:(CCOptions)options initVector:(NSData *)initVector;

- (NSData *)ks_AESDecryptWithKey:(NSData *)key;
- (NSData *)ks_AESDecryptWithKey:(NSData *)key options:(CCOptions)options initVector:(NSData *)initVector;

- (NSData *)ks_SHA512;
- (NSData *)ks_SHA256;
- (NSData *)ks_MD5;

- (NSString *)ks_hexString;
+ (NSData *)ks_dataFromHexString:(NSString *)hexString;

@end
