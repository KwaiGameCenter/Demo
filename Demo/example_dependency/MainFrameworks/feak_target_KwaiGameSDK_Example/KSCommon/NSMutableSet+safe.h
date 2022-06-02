//
//  NSMutableSet+safe.h
//  gifMerchantBaseModule
//
//  Created by lujiazhou on 2020/12/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableSet (safe)

- (void)safe_addObject:(id)object;

@end

NS_ASSUME_NONNULL_END
