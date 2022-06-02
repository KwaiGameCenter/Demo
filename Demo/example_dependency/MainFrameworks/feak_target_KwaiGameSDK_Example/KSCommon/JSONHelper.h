//
//  NSDictionary+JSON.h
//  KWApp
//
//  Created by wangpeng on 2018/9/5.
//  Copyright © 2018年 wangpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSON)

- (NSString*)jsonStringWithPrettyPrint:(BOOL) prettyPrint;

@end

@interface NSString (JSON)

- (NSDictionary *)convertToDictionary;

@end


@interface NSData (JSON)

- (NSDictionary *)convertToDictionary;

@end
