//
//  KGUtil.h
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/12/7.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCustomLogo @"kCustomLogo"
#define kCustomNoneLogo @"kCustomNoneLogo"
#define kCheckIdfaFirst @"kCheckIdfaFirst"
#define kCheckQAEnv @"kCheckQAEnv"
#define kCheckLandscape @"kCheckLandscape"
#define kCheckFeakScheme @"kCheckFeakScheme"
#define kCheckTestStagingURL @"kCheckTestStagingURL"
#define kIsOversea @"kIsOversea"
#define kKGUtilsDomain @"kKGUtilsDomain"

@interface KGUtil : NSObject

@property (class, nonatomic, readonly, copy) NSString *appId;
// 表示游戏的账户id
@property (nonatomic, readonly, copy) NSString *uid;
@property (nonatomic, readonly, copy) NSDictionary *userInfo;

// config
@property (nonatomic, class) BOOL hasAgreeEnterGame;
@property (nonatomic, class) BOOL enableSDKPolicyPrivacy;

+ (instancetype)util;

+ (void)clearAllData;

+ (BOOL)hasOverseaType;

+ (NSInteger)overseaType;

+ (void)setOverseaType:(NSInteger)oversea;

+ (BOOL)boolByRate:(CGFloat)rate;

+ (void)setCustomLogo:(NSString *)name;

+ (void)clearCustomLogo;

+ (BOOL)checkIdfaFirst;

+ (void)setCheckIdfaFirst:(BOOL)value;

+ (BOOL)checkQAEnv;

+ (void)resetSDKEnv;

+ (void)setQAEnv:(BOOL)value;

+ (BOOL)checkLandscape;

+ (void)setLandscape:(BOOL)value;

+ (NSString *)feakScheme;

+ (void)setFeakScheme:(NSString *)feakScheme;

+ (NSString *)testStagingURL;

+ (void)setTestStagingURL:(NSString *)testStagingURL;

+ (NSString *)logoName;

+ (BOOL)hideLogo;

+ (void)swizzlingInstanceMethodInClass: (Class)cls
                      originalSelector: (SEL)originalSelector
                      swizzledSelector: (SEL)swizzledSelector;

+ (void)reportKanasError;

+ (id)getKey:(NSString *)key userId:(NSString *)userId;

+ (void)setKey:(NSString *)key value:(id)value userId:(NSString *)userId syncWrite:(BOOL)syncWrite;

// 模拟游戏登录
- (void)gameLogin:(NSString *)gameId
        gameToken:(NSString *)gameToken
       completion:(void(^)(NSError *error, NSString *uid, NSDictionary *userInfo))completion;

// 模拟游戏登出
- (void)gameLogout;

- (void)updateGameData;

@end

