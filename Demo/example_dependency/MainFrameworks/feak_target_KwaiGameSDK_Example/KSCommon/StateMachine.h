//
//  StateMachine.h
//  Pods
//
//  Created by 刘玮 on 2016/12/6.
//  Copyright © 2016年 Kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FatCategoryMan.h"
#import "CoreContext.h"

@interface StateMachine : FatCategoryMan

- (void)setupContext: (CoreContext *)context;

- (void)setdownContext;

- (id)currentSession;

- (id)currentContext;

@end
