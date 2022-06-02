//
//  KSPasswordValidator.h
//  WeakPassword
//
//  Created by Hale Chan on 16/7/22.
//  Copyright © 2016年 Tips4app. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSPasswordValidator : NSObject

+ (instancetype)validatorWithRules:(NSArray *)rules;

- (BOOL)validatePassword:(NSString *)password;

+ (instancetype)weakPasswordValidator;

@end
