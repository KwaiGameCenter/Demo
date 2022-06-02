//
//  NSString+KSAesGcm.h
//  KSCommon
//
//  Created by zhankai zhang on 2021/8/20.
//
//  本类提供的是 AES GCM 的通用加密方案，不提供秘钥的生成、存储、分发、销毁等加密流程。目的是应对网信办安全合规 “护航计划”，不允许敏感信息明文存储，不是一套完整的加密方案。真正使用它做加密，请自行考虑好密钥的设计。

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (KSAesGcm)

/// AES GCM 加密，会添加 12 位随机 iv，拼到加密后的 data 的前面。
/// @param key 加密用的 key，16 位 data，会做 base64 URLSafe + NoPadding 解码。
/// @param error 若有错误，则会指定 error。
- (nullable NSString *)ks_aesGcmEncryptWithKey:(NSString *)key error:(NSError ** _Nullable)error;

/// AES GCM 解密，与 -aesGcmEncryptionWithString:key:error: 相对应。会将 data 的前 12 位视为随机 iv，并以此解析出后面的 data。不满足这个条件，则返回 nil。
/// @param key 解密用的 key，16 位 data，会做 base64 URLSafe + NoPadding 解码。
/// @param error 若有错误，则会指定 error。
- (nullable NSString *)ks_aesGcmDecipherWithKey:(NSString *)key error:(NSError ** _Nullable)error;

@end

@interface KSAesGcmUtil : NSObject

/// AES GCM 加密，会添加 12 位随机 iv，拼到加密后的 data 的前面。会用一个默认的 key 来加密。不推荐使用。
/// @param string 待加密的字符串。
/// @param error 若有错误，则会指定 error。
+ (nullable NSString *)aesGcmEncryptWithString:(NSString *)string error:(NSError ** _Nullable)error;

/// AES GCM 解密，与 -aesGcmEncryptionWithString:error: 相对应。会将 data 的前 12 位视为随机 iv，并以此解析出后面的 data。不满足这个条件，则返回 nil。会用一个默认的 key 来加密。不推荐使用。
/// @param string 待加密的字符串。
/// @param error 若有错误，则会指定 error。
+ (nullable NSString *)aesGcmDecipherWithString:(NSString *)string error:(NSError ** _Nullable)error;

/// AES GCM 加密，会添加 12 位随机 iv，拼到加密后的 data 的前面。
/// @param string 待加密的字符串。
/// @param key 加密用的 key，16 位 data，会做 base64 URLSafe + NoPadding 解码。
/// @param error 若有错误，则会指定 error。
+ (nullable NSString *)aesGcmEncryptWithString:(NSString *)string key:(NSString *)key error:(NSError ** _Nullable)error;

/// AES GCM 解密，与 -aesGcmEncryptionWithString:key:error: 相对应。会将 data 的前 12 位视为随机 iv，并以此解析出后面的 data。不满足这个条件，则返回 nil。
/// @param encryptString 待解密的字符串。
/// @param key 解密用的 key，16 位 data，会做 base64 URLSafe + NoPadding 解码。
/// @param error 若有错误，则会指定 error。
+ (nullable NSString *)aesGcmDecipherWithString:(NSString *)encryptString key:(NSString *)key error:(NSError ** _Nullable)error;

@end

NS_ASSUME_NONNULL_END
