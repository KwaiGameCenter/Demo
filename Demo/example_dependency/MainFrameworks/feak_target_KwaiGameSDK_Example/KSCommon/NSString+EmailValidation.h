//
//  NSString+EmailValidation.h
//  gif
//
//  Created by Hale Chan on 10/15/15.
//  Copyright © 2015 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EmailValidation)
// 利用正则表达式来校验一个字符串是否是email
-(BOOL)isValidEmail;

@end
