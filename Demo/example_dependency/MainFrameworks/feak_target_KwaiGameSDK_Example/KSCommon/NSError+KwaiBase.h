//
//  NSError+KwaiBase.h
//  KwaiBase
//
//  Created by 小火神 on 2017/7/24.
//  Copyright © 2017年 Kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kKCErrorUserInfoKeyExtData           @"ext_error_data"
#define kKCErrorCodeDomain                   @"com.error.domin.kwai"
#define kKCErrorCodeModuleDomain(module)           [NSString stringWithFormat: @"%@.%@", kKCErrorCodeDomain, module]

#define kKCErrorCodeSuccess                  (0L)
#define kKCErrorCodeInvalidArgument          (-1L)
#define kKCErrorCodeStorageError             (-2L)
#define kKCErrorCodeInvalidResponse          (-3L)
#define kKCErrorCodeParseError               (-4L)
#define kKCErrorCodeInconsistency            (-5L)
#define kWGErrorCodeUploadFailedNoUrl        (-6L)
#define kWGErrorCodeImageIsNil               (-7L)
#define kWGErrorCodeGenerateImage            (-8L)
#define kWGErrorCodeNoImageSize              (-9L)


@interface NSError (KwaiBase)

@property (nonatomic, readonly, copy) NSString *errorDomain;

@property (nonatomic, readonly, copy) NSString *errorMsg;

@property (nonatomic, readonly, copy) NSData *errorData;

+ (instancetype)kc_errorWithCode:(NSInteger)code msg:(NSString *)message;

+ (instancetype)kc_errorWithCode:(NSInteger)code msg:(NSString *)message extData:(id)data;

+ (instancetype)kc_errorWithCode:(NSInteger)code module:(NSString *)module msg:(NSString *)message;

+ (instancetype)kc_errorWithCode:(NSInteger)code
                          module:(NSString *)module
                             msg:(NSString *)message
                         extData:(id)data;

+ (instancetype)kc_errorWithModuleDomain: (NSString *)moduleDomain;

- (instancetype)kc_errorWithCode:(NSInteger)code;

- (instancetype)kc_errorWithCode:(NSInteger)code msg:(NSString *)message;

- (instancetype)kc_errorWithCode:(NSInteger)code msg:(NSString *)message extData:(id)data;

- (instancetype)kc_errorWithError:(NSError *)error;

- (BOOL)isSameModuleDomain: (NSString *)moduleDomain;

@end
