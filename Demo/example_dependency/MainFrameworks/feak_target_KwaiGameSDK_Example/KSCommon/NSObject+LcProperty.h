//
//  NSObject+LcProperty.h
//  LcCategoryPropertySample
//
//  Created by 刘玮 on 2016/12/6.
//  Copyright © 2016年 Kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

extern NSString *LcAddPropertyException;

typedef OBJC_ENUM(uintptr_t, AssociationPolicy) {
    AssociationPolicy_Assign = OBJC_ASSOCIATION_ASSIGN,
    AssociationPolicy_Retain = OBJC_ASSOCIATION_RETAIN,
    AssociationPolicy_Copy = OBJC_ASSOCIATION_COPY,
    AssociationPolicy_RetainNonatomic = OBJC_ASSOCIATION_RETAIN_NONATOMIC,
    AssociationPolicy_CopyNonatomic = OBJC_ASSOCIATION_COPY_NONATOMIC,
    AssociationPolicy_Weak = 14403
};

@interface NSObject (LcProperty)
/**
 *  为类添加id类型的属性，objc_AssociationPolicy类型为OBJC_ASSOCIATION_RETAIN_NONATOMIC
 *  @param name 属性的name
 */
+ (void)addObjectProperty:(NSString *)name;

/**
 *  为类添加id类型的属性
 *  @param name   属性的name
 *  @param policy 属性的policy
 */
+ (void)addObjectProperty:(NSString *)name associationPolicy:(AssociationPolicy)policy;

/**
 *  为类添加基础类型的属性，如：int,float,CGPoint,CGRect等
 *  @param name 属性的name
 *  @param type 属性的encodingType，如int类型的属性，type为@encode(int)
 */
+ (void)addBasicProperty:(NSString *)name encodingType:(const char *)type;

@end
