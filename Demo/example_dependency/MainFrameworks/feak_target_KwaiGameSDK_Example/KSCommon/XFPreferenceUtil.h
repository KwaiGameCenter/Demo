//
//  XFPreferenceUtil.h
//  KwaiBase
//
//  Created by 刘玮 on 15/1/12.
//  Copyright © 2017年 Kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XFPreferenceUtil : NSObject

+ (void)copyPrefenenceFromAppContainer: (NSString *)appGroupKey;

+ (void)setAppGroupKey: (NSString *)appGroupKey;

+ (void)clearPrefenence;

/**
 *  Add key and value as user default.
 *
 *  @param key       key
 *  @param value     value
 *  @param syncWrite synchronize or not
 */
+ (void)setGlobalKey:(NSString *)key
               value:(NSString*)value
           syncWrite:(BOOL)syncWrite;

/**
 *  Get global value with key from user default.
 *
 *  @param key key
 *
 *  @return value
 */
+ (NSString *)getGlobalKey:(NSString *)key;

/**
 *  Add key and bool variable as user default.
 *
 *  @param key       key
 *  @param value     value
 *  @param syncWrite synchronize flag
 */
+ (void)setGlobalBoolKey:(NSString *)key
                   value:(BOOL)value
               syncWrite:(BOOL)syncWrite;

/**
 *  Get global BOOL variable with key from user default.
 *
 *  @param key key
 *
 *  @return BOOL variable
 */
+ (BOOL)getGlobalBoolKey:(NSString *)key;

/**
 *  Add key and NSInteger variable as user default.
 *
 *  @param key       key
 *  @param value     value
 *  @param syncWrite synchronize flag
 */
+ (void)setGlobalIntegerKey:(NSString *)key
                      value:(NSInteger)value
                  syncWrite:(BOOL)syncWrite;

/**
 *  Get global NSInteger object with key from user default.
 *
 *  @param key key
 *
 *  @return NSInteger object
 */
+ (NSInteger)getGlobalIntegerKey:(NSString *)key;

/**
 *  Add key and double variable as user default.
 *
 *  @param key       key
 *  @param value     value
 *  @param syncWrite synchronize flag
 */
+ (void)setGlobalDoubleKey:(NSString *)key
                     value:(double)value
                 syncWrite:(BOOL)syncWrite;

/**
 *  Get global double variable with key from user default.
 *
 *  @param key key
 *
 *  @return double variable
 */
+ (double)getGlobalDoubleKey:(NSString *)key;

/**
 *  Add key and dictionary as user default.
 *
 *  @param key       key
 *  @param value     value
 *  @param syncWrite synchronize flag
 */
+ (void)setGlobalDictKey:(NSString*)key
                   value:(NSDictionary*)value
               syncWrite:(BOOL)syncWrite;

/**
 *  Get global dictionary with key from user default.
 *
 *  @param key key
 *
 *  @return dictionary
 */
+ (NSDictionary*)getGlobalDictKey:(NSString *)key;

/**
 *  Add key and NSArray variable as user default.
 *
 *  @param key       key
 *  @param value     value
 *  @param syncWrite synchronize flag
 */
+ (void)setGlobalArrayKey:(NSString*)key
                    value:(NSArray*)value
                syncWrite:(BOOL)syncWrite;

/**
 *  Get global array with key from user default.
 *
 *  @param key key
 *
 *  @return NSArray object
 */
+ (NSArray*)getGlobalArrayKey:(NSString*)key;

/**
 *  Remove object according to key from user default.
 *
 *  @param key key
 */
+ (void)removeGlobalKey:(NSString*)key;

/**
 *  Add |value| to a dictionary with |userId| and save the dictionary to user default with |key|.
 *
 *  @param key       key
 *  @param value     value
 *  @param userId    userId
 *  @param syncWrite synchronize flag
 */
+ (void)setKey:(NSString *)key
         value:(NSString*)value
        userId:(NSString *)userId
     syncWrite:(BOOL)syncWrite;

/**
 *  Get NSString object from a dictionary with |userId|. The dictionary is got from user default with |key|.
 *
 *  @param key    key
 *  @param userId userId
 *
 *  @return NSString object
 */
+ (NSString*)getKey:(NSString *)key
             userId:(NSString *)userId;

/**
 *  Remove object in a dictionary according to |userId|. The dictionary is got from user default with |key|.
 *
 *  @param key       key
 *  @param userId    userId
 *  @param syncWrite synchronize flag
 */
+ (void)removeUserKey:(NSString *)key
               userId:(NSString *)userId
            syncWrite:(BOOL)syncWrite;

/**
 *  Add |value| to a dictionary with |userId| and save the dictionary to user default with |key|.
 *
 *  @param key       key
 *  @param value     value
 *  @param userId    userId
 *  @param syncWrite synchronize flag
 */
+ (void)setBoolKey:(NSString *)key
             value:(BOOL)value
            userId:(NSString *)userId
         syncWrite:(BOOL)syncWrite;

/**
 *  Get bool variable from a dictionary with |userId|. The dictionary is got from user default with |key|.
 *
 *  @param key    key
 *  @param userId userId
 *
 *  @return bool variable
 */
+ (BOOL)getBoolKey:(NSString *)key
            userId:(NSString *)userId;

/**
 *  Add |value| to a dictionary with |userId| and save the dictionary to user default with |key|.
 *
 *  @param key       key
 *  @param value     value
 *  @param userId    userId
 *  @param syncWrite synchronize flag
 */
+ (void)setDoubleKey:(NSString *)key
               value:(double)value
              userId:(NSString *)userId
           syncWrite:(BOOL)syncWrite;

/**
 *  Get double variable from a dictionary with |userId|. The dictionary is got from user default with |key|.
 *
 *  @param key    key
 *  @param userId userId
 *
 *  @return double variable
 */
+ (double)getDoubleKey:(NSString *)key
                userId:(NSString *)userId;

/**
 *  Add |value| to a dictionary with |userId| and save the dictionary to user default with |key|.
 *
 *  @param key       key
 *  @param value     value
 *  @param userId    userId
 *  @param syncWrite synchronize flag
 */
+ (void)setIntegerKey:(NSString *)key
                value:(NSInteger)value
               userId:(NSString *)userId
            syncWrite:(BOOL)syncWrite;

/**
 *  Get NSInteger object from a dictionary with |userId|. The dictionary is got from user default with |key|.
 *
 *  @param key    key
 *  @param userId userId
 *
 *  @return NSInteger object
 */
+ (NSInteger)getIntegerKey:(NSString *)key
                    userId:(NSString *)userId;

/**
 *  Add |value| to a dictionary with |userId| and save the dictionary to user default with |key|.
 *
 *  @param key       key
 *  @param value     value
 *  @param userId    userId
 *  @param syncWrite synchronize flag
 */
+ (void)setLongLongKey:(NSString *)key
                 value:(long long)value
                userId:(NSString *)userId
             syncWrite:(BOOL)syncWrite;

/**
 *  Get long long variable from a dictionary with |userId|. The dictionary is got from user default with |key|.
 *
 *  @param key    key
 *  @param userId userId
 *
 *  @return long long variable
 */
+ (long long)getLongLongKey:(NSString *)key
                     userId:(NSString *)userId;

/**
 *  Add |value| to a dictionary with |userId| and save the dictionary to user default with |key|.
 *
 *  @param key       key
 *  @param value     value
 *  @param userId    userId
 *  @param syncWrite synchronize flag
 */
+ (void)setArrayKey:(NSString*)key
              value:(NSArray*)value
             userId:(NSString *)userId
          syncWrite:(BOOL)syncWrite;

/**
 *  Get NSArray object from a dictionary with |userId|. The dictionary is got from user default with |key|.
 *
 *  @param key    key
 *  @param userId userId
 *
 *  @return NSArray object
 */
+ (NSArray*)getArrayKey:(NSString*)key
                 userId:(NSString *)userId;

/**
 *  Add |value| to a dictionary with |userId| and save the dictionary to user default with |key|.
 *
 *  @param key       key
 *  @param value     value
 *  @param userId    userId
 *  @param syncWrite synchronize flag
 */
+ (void)setDictKey:(NSString*)key
             value:(NSDictionary*)value
            userId:(NSString *)userId
         syncWrite:(BOOL)syncWrite;

/**
 *  Get NSDictionary object from a dictionary with |userId|. The dictionary is got from user default with |key|.
 *
 *  @param key    key
 *  @param userId userId
 *
 *  @return NSDictionary object
 */
+ (NSDictionary*)getDictKey:(NSString *)key
                     userId:(NSString *)userId;

@end
