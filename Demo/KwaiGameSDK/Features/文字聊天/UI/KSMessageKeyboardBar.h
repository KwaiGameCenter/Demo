//
//  KSMessageKeyboardBar.h
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/12/7.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSMessageKeyboardBar, KwaiEmotion;

@protocol KSMessageKeyboardBarActionDelegate <NSObject>

@optional
- (void)keyboardWillShow:(KSMessageKeyboardBar *)keyboardBar duration:(NSTimeInterval)duration keyboardFrame:(CGRect)keyboardFrame;
- (void)keyboardWillHide:(KSMessageKeyboardBar *)keyboardBar duration:(NSTimeInterval)duration;
- (void)keyboardBarDidClickImageButton:(KSMessageKeyboardBar *)keyboardBar;
- (void)keyboardBar:(KSMessageKeyboardBar *)keyboardBar didPressEmotion:(KwaiEmotion *)emotion;

@end

@interface KSMessageKeyboardBar : UIView

@property (nonatomic, weak) id<UITextFieldDelegate> textFieldDelegate;
@property (nonatomic, weak) id<KSMessageKeyboardBarActionDelegate> actionDelegate;

- (instancetype)initWithViewController:(UIViewController *)viewcontroller;

@end

