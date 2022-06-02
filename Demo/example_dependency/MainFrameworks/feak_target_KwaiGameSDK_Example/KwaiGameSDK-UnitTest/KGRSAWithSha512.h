//
//  KGRSAWithSha512.h
//  KwaiGameSDK-Pay
//
//  Created by 刘玮 on 2019/5/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KGRSAWithSha512 : NSObject

+ (NSString *)encryptString: (NSString *)content privateKey: (NSString *)privateKey;

@end

NS_ASSUME_NONNULL_END
