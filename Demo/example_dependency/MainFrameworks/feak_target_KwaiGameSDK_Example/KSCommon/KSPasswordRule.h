//
//  KSPasswordRule.h
//  WeakPassword
//
//  Created by Hale Chan on 16/7/22.
//  Copyright © 2016年 Tips4app. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KSPasswordRule <NSObject>

- (BOOL)evaluateWithString:(NSString *)string;

@end

@interface KSAllowedCharactersPasswordRule : NSObject <KSPasswordRule>

+ (instancetype)ruleWithAllowedCharacterSet:(NSCharacterSet *)characterSet;

@end

@interface KSRequiredCharactersPasswordRule : NSObject <KSPasswordRule>

+ (instancetype)ruleWithRequiredCharacterSet:(NSCharacterSet *)characterSet;

@end

@interface KSLengthPasswordRule : NSObject <KSPasswordRule>

+ (instancetype)ruleWithMinLength:(NSUInteger)minLength maxLength:(NSUInteger)maxLength;

@end

@interface KSBlockPasswordRule : NSObject <KSPasswordRule>

+ (instancetype)ruleWithBlock:(BOOL (^)(NSString *password))block;

@end

@interface KSRepeatPasswordRule : NSObject <KSPasswordRule>

+ (instancetype)ruleWithMaxRepeatLength:(NSInteger)length;

@end

@interface KSPasswordRuleGroup : NSObject <KSPasswordRule>

+ (instancetype)ruleWithRules:(NSArray<id<KSPasswordRule>> *)rules minimumNumberOfRequiredRules:(NSInteger)minCount;

@end
