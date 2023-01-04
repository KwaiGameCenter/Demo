//
//  KGUtil.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/12/7.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "KGUtil.h"
#import <KwaiGameSDK/KwaiGameSDK.h>
#import <KwaiGameSDK-Oversea/KwaiGameSDK+Oversea.h>
#import <objc/runtime.h>
#import "XFPreferenceHeader.h"

@interface KGUtil()

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSDictionary *userInfo;

@end

@implementation KGUtil

+ (instancetype)util {
    static KGUtil *_util = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _util = [[[self class] alloc] init];
    });
    return _util;
}

+ (id)getKey:(NSString *)key userId:(NSString *)userId {
    @synchronized (self) {
        NSMutableDictionary *map = [NSMutableDictionary dictionary];
        NSDictionary *tmp = [XFPreferenceUtil getGlobalDictKey:userId];
        if (tmp) {
            [map addEntriesFromDictionary:tmp];
        }
        return map[key];
    }
}

+ (void)setKey:(NSString *)key value:(id)value userId:(NSString *)userId syncWrite:(BOOL)syncWrite {
    @synchronized (self) {
        NSMutableDictionary *map = [NSMutableDictionary dictionary];
        NSDictionary *tmp = [XFPreferenceUtil getGlobalDictKey:userId];
        if (tmp) {
            [map addEntriesFromDictionary:tmp];
        }
        map[key] = value;
        [XFPreferenceUtil setGlobalDictKey:userId value:map syncWrite:syncWrite];
    }
}

#define kHasAgreeEnterGame @"kHasAgreeEnterGame"
+ (BOOL)hasAgreeEnterGame {
    id value = [self getKey:kHasAgreeEnterGame userId:kKGUtilsDomain];
    if (value) {
        return [value boolValue];
    }
    return NO;
}

+ (void)setHasAgreeEnterGame:(BOOL)hasAgreeEnterGame {
    [self setKey:kHasAgreeEnterGame value:@(hasAgreeEnterGame) userId:kKGUtilsDomain syncWrite:YES];
}

#define kEnableSDKPolicyPrivacy @"kEnableSDKPolicyPrivacy"
+ (void)setEnableSDKPolicyPrivacy:(BOOL)enableSDKPolicyPrivacy {
    [self setKey:kEnableSDKPolicyPrivacy value:@(enableSDKPolicyPrivacy) userId:kKGUtilsDomain syncWrite:YES];
}

+ (BOOL)enableSDKPolicyPrivacy {
    id value = [self getKey:kEnableSDKPolicyPrivacy userId:kKGUtilsDomain];
    if (value) {
        return [value boolValue];
    }
    return NO;
}

+ (BOOL)hideLogo {
    id value = [self getKey:kCustomLogo userId:kKGUtilsDomain];
    if (value) {
        return [value boolValue];
    }
    return NO;
}

+ (void)reportKanasError {
    Class cls = NSClassFromString(@"KwaiGameActionLog");
    if (cls && [cls respondsToSelector:@selector(testKanasError)]) {
        [cls performSelector:@selector(testKanasError)];
    }
}

+ (void)clearAllData {
    NSDictionary * tmp = [XFPreferenceUtil getGlobalDictKey:kKGUtilsDomain];
    [XFPreferenceUtil clearPrefenence];
    [XFPreferenceUtil setGlobalDictKey:kKGUtilsDomain value:tmp syncWrite:YES];
}

+ (void)resetSDKEnv {
    [self clearAllData];
    self.hasAgreeEnterGame = NO;
}

+ (BOOL)hasOverseaType {
    return [KGUtil getKey:kIsOversea userId:kKGUtilsDomain] != nil;
}

+ (NSInteger)overseaType {
    id value = [KGUtil getKey:kIsOversea userId:kKGUtilsDomain];
    if (value) {
        return [value integerValue];
    }
    return 0;
}

+ (void)setOverseaType:(NSInteger)oversea {
    [KGUtil setKey:kIsOversea value:@(oversea) userId:kKGUtilsDomain syncWrite:YES];
}

+ (BOOL)boolByRate:(CGFloat)rate {
    if (rate >= 1) return YES;
    if (rate <= 0) return NO;
    return (arc4random() % 100 / 99.0) < rate;
}

+ (void)setCustomLogo:(NSString *)name {
    [KGUtil setKey: kCustomLogo
                       value: name
                      userId:kKGUtilsDomain
                   syncWrite: YES];
}

+ (void)clearCustomLogo {
    [KGUtil setCustomLogo:kCustomNoneLogo];
}

+ (void)setCheckIdfaFirst:(BOOL)value {
    [KGUtil setKey: kCheckIdfaFirst
                       value: [NSString stringWithFormat:@"%d",value]
                      userId:kKGUtilsDomain
                   syncWrite: YES];
}

+ (BOOL)checkQAEnv {
    id value = [KGUtil getKey:kCheckQAEnv userId:kKGUtilsDomain];
    if (!value) {
        return NO;
    }
    return [value boolValue];
}

+ (void)setQAEnv:(BOOL)value {
    [KGUtil setKey: kCheckQAEnv
                       value: [NSString stringWithFormat:@"%d",value]
                      userId:kKGUtilsDomain
                   syncWrite: YES];
}

+ (BOOL)checkLandscape {
    id value = [KGUtil getKey:kCheckLandscape userId:kKGUtilsDomain];
    if (!value) {
        return NO;
    }
    return [value boolValue];
}

+ (void)setLandscape:(BOOL)value {
    [KGUtil setKey: kCheckLandscape
                       value: [NSString stringWithFormat:@"%d",value]
                      userId:kKGUtilsDomain
                   syncWrite: YES];
}

+ (NSString *)feakScheme {
    NSString *feakScheme = [KGUtil getKey:kCheckFeakScheme userId:kKGUtilsDomain];
    if (feakScheme.length <= 0) {
        feakScheme = [KGUtil appId];
    }
    return feakScheme;
}

+ (void)setFeakScheme:(NSString *)feakScheme {
    [KGUtil setKey:kCheckFeakScheme value:feakScheme userId:kKGUtilsDomain syncWrite:YES];
}

+ (void)swizzlingInstanceMethodInClass: (Class)cls
                      originalSelector: (SEL)originalSelector
                      swizzledSelector: (SEL)swizzledSelector {
    Class tmpCls = cls;
    Method originalMethod = class_getInstanceMethod(tmpCls, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(tmpCls, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(tmpCls, originalSelector, method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(tmpCls, swizzledSelector, method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (NSString *)appId {
    NSString *feakScheme = [KGUtil getKey:kCheckFeakScheme userId:kKGUtilsDomain];
    if (feakScheme.length > 0) {
        return feakScheme;
    }
    // Default AppId
    if ([KwaiGameSDK sharedSDK].currentEnv == KwaiGameEnv_Staging && [KGUtil overseaType] == 0) {
        return @"ks678636172427043890";
    }
    return @"ks685673047210945076";
}

// 模拟游戏登录
- (void)gameLogin:(NSString *)gameId
        gameToken:(NSString *)gameToken
       completion:(void(^)(NSError *error, NSString *uid, NSDictionary *userInfo))completion {
    [[KwaiGameSDK sharedSDK] requestUserInfoWithCompletion: ^(NSError *error, KwaiGameUser *user) {
        @synchronized (self) {
            if (user) {
                self.uid = [NSString stringWithFormat: @"%lld", user.userLongUid];
                self.userInfo = @{
                    @"uid":self.uid,
                    @"name":user.name?:@"",
                    @"avatar":user.avatar?:@"",
                    @"city":user.city?:@"",
                    @"gender":user.gender?:@"",
                    @"level":@(88),
                    @"serverId":@"1",
                    @"zoneId":@"gamezone",
                    @"gameScene":@"game",
                    @"serverName":@"测试服ios",
                    @"roleId":@"1002",
                    @"roleName":[KwaiGameSDK sharedSDK].account.uid,
                    @"rolePower":@"12113",
                    @"avatarUrl":@"https://d2.game.kspkg.com/kos/nlav11526/game-cloud-community-4624d9c0-dc85-4ab6-9adc-a225b38ffff31%EF%BC%9A1.jpg?biz=100004",
                    @"reportType": @(KwaiGameReportTypeCreate),
                    @"roleCreateTime": @(11111)
                };
            }
            if (completion) {
                completion(error, self.uid, self.userInfo);
            }
        }
    }];
}

// 模拟游戏登出
- (void)gameLogout {
    @synchronized (self) {
        self.uid = nil;
        self.userInfo = nil;
    }
}

- (void)updateGameData {
    @synchronized (self) {
        if ([KGUtil util].uid.length > 0) {
            [[KwaiGameSDK sharedSDK] updateUserData:@{
                kGameUserId:[KGUtil util].userInfo[@"uid"],
                kServerId:[KGUtil util].userInfo[@"serverId"],
                kZoneId:[KGUtil util].userInfo[@"zoneId"],
                kGameScene:[KGUtil util].userInfo[@"gameScene"],
                kLevel:[KGUtil util].userInfo[@"level"],
                kserverName: [KGUtil util].userInfo[@"serverName"],
                kroleId:[KGUtil util].userInfo[@"roleId"],
                kroleName: [KGUtil util].userInfo[@"roleName"],
                krolePower: [KGUtil util].userInfo[@"rolePower"],
                kavatarUrl: [KGUtil util].userInfo[@"avatarUrl"],
                kreportType:[KGUtil util].userInfo[@"reportType"],
                kroleCreateTime:[KGUtil util].userInfo[@"roleCreateTime"]
            }];
        } else {
            if ([KwaiGameSDK sharedSDK].account != nil) {
                [[KGUtil util] gameLogin:[KwaiGameSDK sharedSDK].account.uid
                               gameToken:[KwaiGameSDK sharedSDK].account.serviceToken
                              completion:^(NSError *error, NSString *uid, NSDictionary *userInfo) {
                    NSLog(@"long uid is %@", uid);
                    // 这里更新游戏的用户信息
                    if (uid.length > 0) {
                        [[KwaiGameSDK sharedSDK] updateUserData:@{
                            kGameUserId:userInfo[@"uid"],
                            kServerId:userInfo[@"serverId"],
                            kZoneId:userInfo[@"zoneId"],
                            kGameScene:userInfo[@"gameScene"],
                            kLevel:userInfo[@"level"],
                            kserverName:userInfo[@"serverName"],
                            kroleId:userInfo[@"roleId"],
                            kroleName:userInfo[@"roleName"],
                            krolePower:userInfo[@"rolePower"],
                            kavatarUrl:userInfo[@"avatarUrl"],
                            kreportType:userInfo[@"reportType"],
                            kroleCreateTime:userInfo[@"roleCreateTime"]
                        }];
                    }
                }];
            }
        }
    }
}

@end
