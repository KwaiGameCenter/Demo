//
//  KGPerformanceReportExpandInfoViewController.h
//  KwaiGameSDK_Example
//
//  Created by yan long on 2022/9/19.
//  Copyright © 2022 mookhf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KGPerformanceReportExpandInfoViewController : UIViewController

@property (nonatomic, copy) void(^reportExpandInfo)(NSString *content);

@end

NS_ASSUME_NONNULL_END
