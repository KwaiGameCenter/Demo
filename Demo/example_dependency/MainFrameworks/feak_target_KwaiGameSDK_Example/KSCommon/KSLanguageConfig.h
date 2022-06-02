//
//  KSLanguageConfig.h
//  gifCommonsModule
//
//  Created by 李帅 on 2019/1/23.
//

#import <Foundation/Foundation.h>

typedef NSString * KSLanguageCodeString;

FOUNDATION_EXTERN KSLanguageCodeString const kKSEnglishFlag;
FOUNDATION_EXTERN KSLanguageCodeString const kKSChineseSimplifiedFlag;
FOUNDATION_EXTERN KSLanguageCodeString const kKSChineseTraditionalFlag;


/**
 获取系统语言
 
 @return 语言简化代码
 */
FOUNDATION_EXTERN KSLanguageCodeString getSystemLanguage();


@interface KSLanguageConfig : NSObject

/// 只包括3种：zh-Hans, zh-Hant, en
@property (class, nonatomic, copy) NSString *userLanguage;
/// 只包括3种：zh-Hans, zh-Hant, en
@property (class, nonatomic, readonly, copy) NSString *appLanguage;
/// zh, en, ...等
@property (class, nonatomic, readonly, copy) NSString *localeLanguage;
/// 系统版本不同，元素值有差异(地域区分)
@property (class, nonatomic, readonly, copy) NSArray<NSString *> *preferredLanguages;

@property (class, nonatomic, readonly, getter=isChinese) BOOL chinese;
@property (class, nonatomic, readonly, getter=isEnglish) BOOL english;

/**
 重置系统语言
 */
+ (void)resetSystemLanguage;

@end
