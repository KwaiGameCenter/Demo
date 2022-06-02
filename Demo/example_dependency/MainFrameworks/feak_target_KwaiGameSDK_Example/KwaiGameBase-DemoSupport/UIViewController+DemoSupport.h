//
//  UIViewController+CustomUI.h
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/11/29.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (DemoSupport)

+ (UIViewController *)ds_topMostViewController;

+ (UIViewController *)ds_alwaysTopMostViewController;

- (void)toast:(NSString *)format, ...;

@end

NS_ASSUME_NONNULL_END
