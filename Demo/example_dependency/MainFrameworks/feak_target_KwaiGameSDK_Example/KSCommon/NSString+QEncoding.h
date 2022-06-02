//
//  NSString+Encoding.h
//  QWeiboSDK4iOS
//
//  Created on 11-1-12.
//  
//

#import <Foundation/Foundation.h>

// 字符串编码,加密
@interface NSString (QOAEncoding)
- (NSString*)urlEncode:(NSStringEncoding)stringEncoding;
- (NSString*)md5;
- (NSString*)HMACMd5WithSecret:(NSString*)secret;
@end
