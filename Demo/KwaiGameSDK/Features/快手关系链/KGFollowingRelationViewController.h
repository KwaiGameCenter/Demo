//
//  KGFollowingRelationViewController.h
//  KwaiGameSDK_Example
//
//  Created by 刘玮 on 2019/8/13.
//  Copyright © 2019 mookhf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class KwaiGameAccount;
@interface KGFollowingRelationViewController : UIViewController

- (void)setAppId:(NSString *)appId account:(KwaiGameAccount *)account;

@end

NS_ASSUME_NONNULL_END
