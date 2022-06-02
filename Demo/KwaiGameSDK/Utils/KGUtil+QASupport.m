//
//  KGUtil+QASupport.m
//  QASupport
//
//  Created by 刘玮 on 2022/4/7.
//  Copyright © 2022 mookhf. All rights reserved.
//

#import "KGUtil+QASupport.h"
#import <objc/runtime.h>
#import <KwaiGameSDK/KwaiGameSDK.h>

@interface MobAdSDKProxy : NSObject

@end

@implementation MobAdSDKProxy(Feak)

- (BOOL)debugMode {
    return [KGUtil checkQAEnv];
}

@end

@implementation NSProcessInfo (TestStaging)

+ (void)load {
    [KGUtil swizzlingInstanceMethodInClass:self
                          originalSelector:@selector(arguments)
                          swizzledSelector:@selector(privateArguments)];
}

- (NSArray<NSString *> *)privateArguments {
    NSMutableArray *arguments = [NSMutableArray arrayWithArray:[self privateArguments]];
    if ([KGUtil checkQAEnv]) {
        if (![arguments containsObject:@"-FIRDebugEnabled"]) {
            [arguments addObject:@"-FIRDebugEnabled"];
        }
    }
    return arguments;
}

@end

@interface NSString(TestStaging)

+ (NSString *)kwaiGameHost;

@end

@implementation NSString(TestStaging)

+ (void)load {
    [KGUtil swizzlingInstanceMethodInClass:object_getClass(self)
                          originalSelector:@selector(kwaiGameHost)
                          swizzledSelector:@selector(privateKwaiGameHost)];
}

+ (NSString *)privateKwaiGameHost {
    KwaiGameEnv env = [[KwaiGameSDK sharedSDK] currentEnv];
    switch (env) {
        case KwaiGameEnv_Staging:
            if ([NSString tempStagingURL].length) {
                return [NSString tempStagingURL];
            }
            return [NSString privateKwaiGameHost];
        default:
            return [NSString privateKwaiGameHost];
    }
}

+ (NSString *)tempStagingURL {
    NSString *feakScheme = [KGUtil getKey:kCheckTestStagingURL userId:kKGUtilsDomain];
    return feakScheme;
}

@end

@interface KwaiUIStyle : NSObject

@end

@implementation KwaiUIStyle(Feak)

+ (NSString *)logoName {
    return [KGUtil getKey: kCustomLogo userId:kKGUtilsDomain];
}

+ (NSString *)customLogoName {
    if ([[self logoName] isEqualToString:kCustomNoneLogo]) {
        return nil;
    }
    return @"CustomLogo";
}

@end

// TODO: 合并firebase升级分支后，需要移动到KGUtil+QASupport中
@interface AppsFlyerAdPath : NSObject

@end

@implementation AppsFlyerAdPath(Feak)

- (BOOL)debugMode {
    return [KGUtil checkQAEnv];
}

@end

@interface KwaiGameDeviceUtil : NSObject

@end

@implementation KwaiGameDeviceUtil(Feak)

+ (BOOL)checkIdfaFirst {
    id value = [KGUtil getKey: kCheckIdfaFirst userId:kKGUtilsDomain];
    if (value != nil) {
        return [value boolValue];
    }
    return YES;
}

@end

@interface AppsFlyerHelper : NSObject

@end

@implementation AppsFlyerHelper(Feak)

- (BOOL)debugMode {
    return [KGUtil checkQAEnv];
}

@end

@implementation KGUtil (QASupport)

+ (BOOL)checkIdfaFirst {
    return [KwaiGameDeviceUtil checkIdfaFirst];
}

+ (NSString *)testStagingURL {
    return [NSString kwaiGameHost];
}

+ (void)setTestStagingURL:(NSString *)testStagingURL {
    [KGUtil setKey:kCheckTestStagingURL value:testStagingURL userId:kKGUtilsDomain syncWrite:YES];
}

+ (NSString *)logoName {
    return [KwaiUIStyle customLogoName];
}

@end
