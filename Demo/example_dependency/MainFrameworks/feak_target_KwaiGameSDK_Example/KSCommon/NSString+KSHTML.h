//
//  NSString+KSHTML.h
//  KSCommon
//
//  Created by 孟宪璞 on 2020/12/21.
//  ref: https://github.com/google/google-toolbox-for-mac/blob/master/Foundation/GTMNSString%2BHTML.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Utilities for NSStrings containing HTML
@interface NSString (KSHTML)

/// Get a string where internal characters that need escaping for HTML are escaped
//
///  For example, '&' become '&amp;'. This will only cover characters from table
///  A.2.2 of http://www.w3.org/TR/xhtml1/dtds.html#a_dtd_Special_characters
///  which is what you want for a unicode encoded webpage. If you have a ascii
///  or non-encoded webpage, please use stringByEscapingAsciiHTML which will
///  encode all characters.
///
/// For obvious reasons this call is only safe once.
//
//  Returns:
//    Autoreleased NSString
//
- (NSString *)ks_stringByEscapingForHTML;

/// Get a string where internal characters that need escaping for HTML are escaped
//
///  For example, '&' become '&amp;'
///  All non-mapped characters (unicode that don't have a &keyword; mapping)
///  will be converted to the appropriate &#xxx; value. If your webpage is
///  unicode encoded (UTF16 or UTF8) use stringByEscapingHTML instead as it is
///  faster, and produces less bloated and more readable HTML (as long as you
///  are using a unicode compliant HTML reader).
///
/// For obvious reasons this call is only safe once.
//
//  Returns:
//    Autoreleased NSString
//
- (NSString *)ks_stringByEscapingForAsciiHTML;

/// Get a string where internal characters that are escaped for HTML are unescaped
//
///  For example, '&amp;' becomes '&'
///  Handles &#32; and &#x32; cases as well
///
//  Returns:
//    Autoreleased NSString
//
- (NSString *)ks_stringByUnescapingFromHTML;

@end

NS_ASSUME_NONNULL_END
