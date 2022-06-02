//
//  NSURLResponse+KSDiagnosis.h
//  gif
//
//  Created by Hale Chan on 11/05/2017.
//  Copyright © 2017 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 用于网络请求染色日志的统计信息
 
 @notice    基于TLS来实现，典型使用方式如下:
 1. 生成requestID并发起请求
 2. 收到响应数据，获取responseID并调用[KSAPIDiagnosis setCurrentDiagnosis:obj]来配置染色数据
 3. 调用用来处理数据的block
 4. [KSAPIDiagnosis setCurrentDiagnosis:nil]
 */
@interface KSAPIDiagnosis : NSObject

@property (nonatomic, copy) NSString *requestID;
@property (nonatomic, copy) NSString *responseID;
@property (nonatomic, assign, getter=isError) BOOL error;

+ (instancetype)diagnosisWithRequestID:(NSString *)requestID responseID:(NSString *)responseID isError:(BOOL)error;
- (instancetype)initWithRequestID:(NSString *)requestID responseID:(NSString *)responseID isError:(BOOL)error;

- (NSDictionary *)toLogParams;


/**
 当前请求的染色信息

 @return 当前请求的染色信息
 */
+ (KSAPIDiagnosis *)currentDiagnosis;

/**
 设置当前请求的染色信息

 @param diagnosis 染色信息
 */
+ (void)setCurrentDiagnosis:(KSAPIDiagnosis *)diagnosis;

+ (NSString*)newXRequestID;
@end

@interface NSURLResponse (KSDiagnosis)

- (NSString *)ks_xResponseID;

@end

@interface NSURLRequest (KSDiagnosis)

- (NSString *)ks_xRequestID;

@end

@interface NSMutableURLRequest (KSDiagnosis)

- (NSString *)ks_addXRequestID;

@end


