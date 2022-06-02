//
//  KGGlobalDelegate+Public.h
//  KwaiGameSDK_Example
//
//  Created by 刘玮 on 2021/8/9.
//  Copyright © 2021 mookhf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KGGlobalDelegate: NSObject

@property (nonatomic, assign) BOOL gaming;

+ (instancetype)delegate;

@end

NS_ASSUME_NONNULL_END
