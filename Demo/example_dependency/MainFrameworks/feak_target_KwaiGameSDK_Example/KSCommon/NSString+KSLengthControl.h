//
//  NSString+KSLengthControl.h
//  AFNetworking
//
//  Created by jft0m on 2018/6/20.
//

#import <Foundation/Foundation.h>

@interface NSString (KSLengthControl)
- (NSUInteger)ks_visualLength;
- (NSString *)ks_substringToVisualTextIndex:(NSUInteger)to;
- (NSString *)ks_stringByReplacingCharactersWithVisualRange:(NSRange)visualRange withString:(NSString *)string;
- (BOOL)ks_hasNewLine;
@end
