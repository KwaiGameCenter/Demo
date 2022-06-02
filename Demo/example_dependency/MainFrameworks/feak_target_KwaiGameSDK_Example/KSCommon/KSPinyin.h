//
//  KSPinyin.h
//  gifIMBaseModule
//
//  Created by lihuan05 on 2020/12/7.
//

#import <Foundation/Foundation.h>
#import "KSPinyinResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSPinyin : NSObject

+ (instancetype)sharedInstance;

- (void)setup;

- (NSString *)pinyinFromString:(NSString *)string;

- (KSPinyinResult *)pinyinResultFromString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
