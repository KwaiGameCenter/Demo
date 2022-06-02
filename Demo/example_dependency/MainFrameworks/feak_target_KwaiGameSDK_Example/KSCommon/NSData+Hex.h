//
//  NSData+Hex.h
//  SecurityAIO
//
//  Created by master on 2019/3/4.
//  Copyright © 2019 zhangyansheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Hex)

- (NSString*)hexRepresentationWithSpaces_AS:(BOOL)spaces;
+ (id)dataWithHexString:(NSString *)hex;

@end

NS_ASSUME_NONNULL_END
