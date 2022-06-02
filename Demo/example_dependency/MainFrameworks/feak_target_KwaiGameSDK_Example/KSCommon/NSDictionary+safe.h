//
//  NSDictionary+safe.h
//  QWeiboSDK4iOSDemo
//
//  Created by zhongchao.han on 15/3/30.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (safe)

- (id)safe_objectForKey:(id)aKey;

@end
