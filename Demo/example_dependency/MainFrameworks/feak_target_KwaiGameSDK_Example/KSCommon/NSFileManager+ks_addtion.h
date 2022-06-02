//
//  NSFileManager+ks_addtion.h
//  gif
//
//  Created by zhongchao.han on 15/9/25.
//  Copyright (c) 2015年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 设置自定义属性到文件
 */
@interface NSFileManager (ks_addtion)

- (void)setAttributeWithFilePath:(NSString*)path attribute:(NSString*)attribute forKey:(NSString*)key error:(NSError**)error;

- (NSString*)attributeWithFilePath:(NSString*)path forKey:(NSString*)key error:(NSError**)error;

- (id<NSCopying>)extendedAttributeWithPath:(NSString *)path key:(NSString *)key error:(NSError**)error;

- (BOOL)setExtendedAttributeWithPath:(NSString *)path key:(NSString *)key value:(id<NSCopying>)value error:(NSError**)error;

@end
