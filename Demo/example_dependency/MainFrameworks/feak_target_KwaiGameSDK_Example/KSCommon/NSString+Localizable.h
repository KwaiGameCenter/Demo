//
//  NSString+Localizable.h
//  Pods
//
//  Created by 刘玮 on 2017/6/5.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Localizable)

/**
 * This works very similar to
 * [NSString localizedStringWithFormat:(NSString *)format, ...], besides that
 * this format string for In-App locale, not the system one.
 */
+ (instancetype)stringWithFormatWithAppLocale:(NSString *)format, ...;

@end
