//
//  KSMessageKeyboardBar.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/12/7.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "KSMessageKeyboardBar.h"

const CGFloat kKSMessageKeyboardBarHeight = 60;

@interface KSMessageKeyboardBar ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@end

@implementation KSMessageKeyboardBar{
    CGFloat _viewControllerBottom;
}

- (instancetype)initWithViewController:(UIViewController *)viewcontroller{
    CGFloat bottomInsets = 0.0;
    if (@available(iOS 11.0, *)) {
        bottomInsets = viewcontroller.view.safeAreaInsets.bottom;
    } else {}
    CGFloat keyboardHeight = kKSMessageKeyboardBarHeight + bottomInsets;
    CGRect rect = CGRectMake(0,
                             CGRectGetHeight(viewcontroller.view.frame) - keyboardHeight,
                             CGRectGetWidth(UIScreen.mainScreen.bounds),
                             keyboardHeight);
    _viewControllerBottom = rect.origin.y;
    self = [super initWithFrame:rect];
    if(self){
        [self _setupSubViews];
        
        [self _setupKeyboardNotifs];
    }
    return self;
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private
- (void)_setupSubViews{
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.97 alpha:1.00];
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 8,
                                                               self.frame.size.width - 10 - 10,
                                                               kKSMessageKeyboardBarHeight - 16)];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.delegate = self;
    _textField.returnKeyType = UIReturnKeySend;
    _textField.font = [UIFont systemFontOfSize:13.f];
    _textField.layer.masksToBounds = YES;
    _textField.layer.cornerRadius = 2.f;
    _textField.clearButtonMode = UITextFieldViewModeNever;
    _textField.textColor = [UIColor blackColor];
    [self addSubview:_textField];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(self.textFieldDelegate &&
       [self.textFieldDelegate respondsToSelector:@selector(textFieldShouldReturn:)]){
        [self.textFieldDelegate textFieldShouldReturn:textField];
    }
    
    return NO;
}

#pragma mark - Keyboard Notifion
- (void)_setupKeyboardNotifs{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillShow:) name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil] ;
}

- (void)_keyboardWillShow:(NSNotification *)notif{
    
    NSTimeInterval duration = [[notif.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSValue *boardBounds = [notif.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    if ([self.actionDelegate respondsToSelector:@selector(keyboardWillShow:duration:keyboardFrame:)]) {
        [self.actionDelegate keyboardWillShow:self duration:duration keyboardFrame:boardBounds.CGRectValue];
    }
}

- (void)_keyboardWillHide:(NSNotification *)notif{
    NSTimeInterval duration = [[notif.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if ([self.actionDelegate respondsToSelector:@selector(keyboardWillHide:duration:)]) {
        [self.actionDelegate keyboardWillHide:self duration:duration];
    }
}

- (BOOL)resignFirstResponder {
    [self.textField resignFirstResponder];
    return [super resignFirstResponder];
}

@end
