//
//  NSString+KSURLEncoded.h
//  gif
//
//  Created by 薛辉 on 8/3/15.
//  Copyright (c) 2015 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

// 字符串编码
@interface NSString (KSURLEncoded)

- (NSString *)ks_URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding charactersToBeEscaped:(NSString *)characters;
- (NSString *)ks_URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding;
- (NSString *)ks_URLEncodedString;

- (NSString *)ks_URLDecodedString;

@end
