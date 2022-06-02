//
//  NSDictionary+KPSExtension.h
//  solar
//
//  Created by 林萌 on 2019/8/26.
//  Copyright © 2019 chenzhong. All rights reserved.
//

/**
 *  根据 key 和期望类型查找结果
 */

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (KPSExtension)

- (id)dictionary_objectForKey:(id <NSCopying>)key class:(Class)class;

- (NSNumber *)kps_boolNumberForKey:(id <NSCopying>)key;
- (NSNumber *)kps_integerNumberForKey:(id <NSCopying>)key;
- (NSNumber *)kps_longLongNumberForKey:(id <NSCopying>)key;
- (NSNumber *)kps_floatNumberForKey:(id <NSCopying>)key;
- (NSNumber *)kps_doubleNumberForKey:(id <NSCopying>)key;
- (NSString *)kps_stringObjectForKey:(id <NSCopying>)key;
- (NSDictionary *)kps_dictionaryObjectForKey:(id <NSCopying>)key;
- (NSArray *)kps_arrayObjectForKey:(id <NSCopying>)key;
- (NSData *)kps_dataObjectForKey:(id <NSCopying>)key;

@end

NS_ASSUME_NONNULL_END
