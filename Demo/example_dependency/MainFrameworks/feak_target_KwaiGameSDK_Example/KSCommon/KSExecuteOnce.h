//
//  KSExecuteOnce.h
//  gif
//
//  Created by LiSi on 11/04/2017.
//  Copyright © 2017 kuaishou. All rights reserved.
//

#ifndef KSExecuteOnce_h
#define KSExecuteOnce_h

#define execute_once(keyStr, block,...) \
try {} @finally {} \
do { \
if (![[KSUserDefaults standardUserDefaults] boolForKey:@"" keyStr]) { \
block(__VA_ARGS__); \
[[KSUserDefaults standardUserDefaults] setBool:YES forKey:@"" keyStr]; \
[[KSUserDefaults standardUserDefaults] synchronize];\
} \
}while(0)


/**
 same as above, except you can use variables as the key
 */
#define execute_once_using_variable_key(key, block,...) \
try {} @finally {} \
do { \
NSString *keyStr = [NSString stringWithFormat:@"%@", key];\
if (![[KSUserDefaults standardUserDefaults] boolForKey:keyStr]) { \
block(__VA_ARGS__); \
[[KSUserDefaults standardUserDefaults] setBool:YES forKey:keyStr]; \
[[KSUserDefaults standardUserDefaults] synchronize];\
} \
}while(0)


#endif /* KSExecuteOnce_h */
