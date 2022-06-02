//
//  NSData+ks_security.h
//  gif
//
//  Created by zhongchao.han on 15/9/23.
//  Copyright (c) 2015年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ks_security)

- (NSData *)ks_AES256EncryptWithKey:(NSString *)key;

- (NSData *)ks_AES256DecryptWithKey:(NSString *)key;

@end
