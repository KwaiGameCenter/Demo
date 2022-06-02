//
//  NSString+KSURLParameter.h
//  gif
//
//  Created by 薛辉 on 9/1/15.
//  Copyright (c) 2015 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KSURLParameter)
- (NSString *)ks_stringByAppendURLParameter:(NSDictionary *)parameter;
@end
