//
//  WeakCategoryMan.h
//  KwaiBase
//
//  Created by 刘玮 on 2017/10/26.
//

#import <Foundation/Foundation.h>

@interface WeakCategoryMan : NSObject

@property (nonatomic, readonly, weak) id core;
@property (nonatomic, assign) BOOL readonly;

- (id)initWithCore: (id)core;

@end
