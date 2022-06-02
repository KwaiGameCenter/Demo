//
//  NSMutableURLRequest+KSIp.h
//  KSCommon
//
//  Created by 舒祯 on 2019/1/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableURLRequest (KSIp)

- (void)ks_setIp:(NSString *)ip;

@end

@interface NSURL (KSIp)

- (NSURL *)ks_URLWithIp:(NSString *)ip;

@end

NS_ASSUME_NONNULL_END
