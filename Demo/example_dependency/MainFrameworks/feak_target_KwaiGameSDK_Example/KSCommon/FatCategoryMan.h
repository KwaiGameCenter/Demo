//
//  FatCategoryMan.h
//  Pods
//
//  Created by 刘玮 on 2016/12/15.
//  Copyright © 2016年 Kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreNode : NSObject

@property (nonatomic, strong) id core;
@property (nonatomic, assign) BOOL readonly;

@end

@interface FatCategoryMan : NSObject

- (void)addCore: (id)core readonly: (BOOL)readonly;

- (void)delCore: (id)core;

@end
