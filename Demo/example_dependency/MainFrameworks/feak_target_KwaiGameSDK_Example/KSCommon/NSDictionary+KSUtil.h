//
//  NSDictionary+KSUtil.h
//  gif
//
//  Created by 张颂 on 2017/3/24.
//  Copyright © 2017年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (KSUtil)

/* Create a dictionary with a special formatted string like: "appv=10.1.0; token= ijw87dh294r09werj; did=92873982344"
 * Seperate a string with separator, then resolve key=value to dictionary. 
 * Keys and values will be trimmed by trimCharacterSet if there exists.
 */
+ (NSDictionary<NSString *, NSString *> * _Nonnull)ks_dictionarySeparatedByString:(NSString * _Nonnull)string withSeparator:(NSString * _Nonnull)separator trimmingCharactorSet:(NSCharacterSet * _Nullable)trimCharacterSet;

/* Automatically trim keys and values with white space.
 */
+ (NSDictionary<NSString *, NSString *> * _Nonnull)ks_dictionarySeparatedByString:(NSString * _Nonnull)string withSeparator:(NSString * _Nonnull)separator;

@end


@interface NSMutableDictionary (KSUtil)

/* Set value for kayPath like: Kwai.system.deviceInfo;
 * Usually used for create an EQUAL PATH LENGTH Dictionary.
 * warning: value alone the path will be replaced by a NSMutableDictionary if there's no one.
 * And the end of the path will be setted by value evenif there's an exist NSMutableDictionary that may cost lost of Data.
 */
- (void)ks_mutableSetValue:(id _Nullable)value forKeyPath:(NSString * _Nonnull)keyPath;

@end
