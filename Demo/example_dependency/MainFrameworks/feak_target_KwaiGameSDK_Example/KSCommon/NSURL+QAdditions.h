//
//  NSURL+QAdditions.h
//  QWeiboSDK4iOS
//
//  Created on 11-1-13.
//  
//

#import <Foundation/Foundation.h>

// 将URL的参数解析成字典
@interface NSURL (QAdditions)

+ (NSDictionary *)parseURLQueryString:(NSString *)queryString;

- (NSDictionary *)ks_queryDictionary;

@end
