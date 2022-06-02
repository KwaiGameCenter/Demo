//
//  KGAppDelegate+FloatingView.h
//  KwaiGameSDK_Example
//
//  Created by 刘玮 on 2020/11/24.
//  Copyright © 2020 mookhf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (FloatingView)

@property (nonatomic, strong) UIView *floatingView;
@property (nonatomic, strong) NSMutableArray *logs;
@property (nonatomic, strong) NSMutableArray *actionLogs;
@property (nonatomic, strong) NSMutableAttributedString * _Nullable memoryDisplayString;
@property (nonatomic, assign) int floatingType; // 0: log; 1: actionLog

- (void)setupFloatingBox;

+ (void)updateLogMessage:(NSString *)message level:(int)level type:(int)type memory:(BOOL)memory;

@end

NS_ASSUME_NONNULL_END
