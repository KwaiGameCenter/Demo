//
//  KBLocalizeUtil.h
//  KwaiBase
//
//  Created by long on 2017/2/28.
//  Copyright © 2017年 Kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Localizable.h"

#define KBLocalizedString(key, comment) \
[[KBLocalizeUtil sharedLocalSystem] localizedStringForKey:(key) value:(comment)]

#define KBLocalizedFormatString(key, comment, ...) \
[NSString stringWithFormatWithAppLocale: KBLocalizedString(key, comment), __VA_ARGS__]

#define KwaiLocalizeChangedNotification    @"KwaiLocalizeChangedNotification"

@interface KBLocalizeUtil : NSObject

// 系统当前位置信息
@property (nonatomic, copy) NSString *currentLocale;
@property (nonatomic, copy) NSArray *availableLocaleArray;

/**
 *  Get singleton object
 *
 *  @return object
 */
+ (KBLocalizeUtil *)sharedLocalSystem;

/**
 *  Get the current localized string as in XMLocalizedString.
 *
 *  @param key     key
 *  @param comment value
 *
 *  @return current localized string
 */
- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)comment;

/**
 *  Get the current localized string as in XMLocalizedString.
 *
 *  @param key     key
 *  @param comment value
 *
 *  @return current localized string
 */
- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)comment table:(NSString *)tableName;

@end
