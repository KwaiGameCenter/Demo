//
//  KSURLQueryItem.h
//  gif
//
//  Created by Hale Chan on 2016/11/28.
//  Copyright © 2016年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A stand-in for `NSURLQueryItem` that can be used on iOS 7.
 */
@interface KSURLQueryItem : NSObject

/**
 *  @see `NSURLQueryItem`
 */
@property (nonatomic, readonly) NSString *name;

/**
 *  @see `NSURLQueryItem`
 */
@property (nonatomic, readonly) NSString *value;

/**
 *  @see `NSURLQueryItem`
 */
+ (instancetype)queryItemWithName:(NSString *)name value:(NSString *)value;

/**
 *  @see `NSURLQueryItem`
 */
- (instancetype)initWithName:(NSString *)name value:(NSString *)value;

@end
