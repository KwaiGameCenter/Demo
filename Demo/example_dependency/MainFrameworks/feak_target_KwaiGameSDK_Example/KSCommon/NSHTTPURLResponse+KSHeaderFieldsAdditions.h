//
//  NSHTTPURLResponse+KSHeaderFieldsAdditions.h
//  gif
//
//  Created by 薛辉 on 5/4/16.
//  Copyright © 2016 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSHTTPURLResponse (KSHeaderFieldsAdditions)
- (NSNumber *)ks_maxAge;
- (NSString *)ks_eTag;
- (NSString *)ks_expires;
@end
