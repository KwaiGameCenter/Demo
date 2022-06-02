//
//  KSUserDefaults.h
//  KSCommon
//
//  Created by shenge03 on 2020/8/4.
//

#import <Foundation/Foundation.h>
#import <MMKV/MMKV.h>

@interface KSUserDefaults : NSObject

+ (instancetype)standardUserDefaults;

- (void)installMMKV:(BOOL)enableMMKV identifier:(NSString *)identifier isSingleProcess:(BOOL)isSingleProcess;

- (BOOL)setObject:(nullable NSObject<NSCoding> *)object forKey:(NSString *)key;

- (BOOL)setBool:(BOOL)value forKey:(NSString *)key;

- (BOOL)setInt32:(int32_t)value forKey:(NSString *)key;

- (BOOL)setUInt32:(uint32_t)value forKey:(NSString *)key;

- (BOOL)setInt64:(int64_t)value forKey:(NSString *)key;

- (BOOL)setUInt64:(uint64_t)value forKey:(NSString *)key;

- (BOOL)setFloat:(float)value forKey:(NSString *)key;

- (BOOL)setDouble:(double)value forKey:(NSString *)key;

- (BOOL)setString:(NSString *)value forKey:(NSString *)key;

- (BOOL)setDate:(NSDate *)value forKey:(NSString *)key;

- (BOOL)setData:(NSData *)value forKey:(NSString *)key;

- (BOOL)setInteger:(NSInteger)value forKey:(NSString *)key;

- (BOOL)setUInteger:(NSUInteger)value forKey:(NSString *)key;


- (nullable id)objectOfClass:(Class)cls forKey:(NSString *)key;

- (BOOL)boolForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;

- (int32_t)int32ForKey:(NSString *)key;
- (int32_t)int32ForKey:(NSString *)key defaultValue:(int32_t)defaultValue;

- (uint32_t)uint32ForKey:(NSString *)key;
- (uint32_t)uint32ForKey:(NSString *)key defaultValue:(uint32_t)defaultValue;

- (int64_t)int64ForKey:(NSString *)key;
- (int64_t)int64ForKey:(NSString *)key defaultValue:(int64_t)defaultValue;

- (uint64_t)uint64ForKey:(NSString *)key;
- (uint64_t)uint64ForKey:(NSString *)key defaultValue:(uint64_t)defaultValue;

- (float)floatForKey:(NSString *)key;
- (float)floatForKey:(NSString *)key defaultValue:(float)defaultValue;

- (double)doubleForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key defaultValue:(double)defaultValue;

- (NSInteger)integerForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;

- (NSUInteger)uintegerForKey:(NSString *)key;
- (NSUInteger)uintegerForKey:(NSString *)key defaultValue:(NSUInteger)defaultValue;


- (nullable NSString *)stringForKey:(NSString *)key;
- (nullable NSString *)stringForKey:(NSString *)key defaultValue:(nullable NSString *)defaultValue;

- (nullable NSDate *)dateForKey:(NSString *)key;
- (nullable NSDate *)dateForKey:(NSString *)key defaultValue:(nullable NSDate *)defaultValue;

- (nullable NSData *)dataForKey:(NSString *)key;
- (nullable NSData *)dataForKey:(NSString *)key defaultValue:(nullable NSData *)defaultValue;

- (void)removeValueForKey:(NSString *)key;

- (void)removeValuesForKeys:(NSArray<NSString *> *)arrKeys;

- (BOOL)containsKey:(NSString *)key;

- (void)clearAll;

- (BOOL)synchronize;

@end
