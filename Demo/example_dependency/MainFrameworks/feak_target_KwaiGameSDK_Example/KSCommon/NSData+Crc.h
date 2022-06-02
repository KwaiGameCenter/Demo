//
//  NSData+Crc.h
//  gifVideoProcessModule
//
//  Created by dajun on 2019/1/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Crc)

- (u_long)ks_crc32;

@end

NS_ASSUME_NONNULL_END
