//
//  KSURLComponents.h
//  gif
//
//  Created by Hale Chan on 2016/11/28.
//  Copyright © 2016年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KSURLQueryItem;

@interface KSURLComponents : NSObject

+ (instancetype)componentsWithString:(NSString *)URLString;
- (NSArray *)queryItems;
- (void)setQueryItems:(NSArray *)queryItems;
- (NSURL *)URL;

@end
