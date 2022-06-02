//
//  CategoryMan.h
//  Pods
//
//  Created by 刘玮 on 2016/12/6.
//  Copyright © 2016年 Kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryMan : NSObject

@property (nonatomic, readonly, strong) id core;
@property (nonatomic, assign) BOOL readonly;

- (id)initWithCore: (id)core;

@end
