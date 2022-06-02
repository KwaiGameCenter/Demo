//
//  KGMessageBaseCell.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/12/7.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "KGMessageBaseCell.h"
#import <KwaiGameSDK-IM/KwaiIMMessage.h>
#import "KGUtil.h"

@interface KGMessageBaseCell()

@property (strong, nonatomic) UIButton *errorButton;

@end

@implementation KGMessageBaseCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    [tableView registerClass:[self class] forCellReuseIdentifier:NSStringFromClass([self class])];
    return [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self.contentView addGestureRecognizer:lp];
        lp.minimumPressDuration = 0.3f;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    BOOL isOwner = [self.message.from isEqualToString:[KGUtil util].uid];
    self.avatarLabel.frame = CGRectMake(0.0, 0, 50.0, 50.0);
    CGSize size = [self.class contentSizeWithMessage:self.message];
    self.bgContentView.frame = CGRectMake(0, 0, size.width, size.height);
    if (isOwner) {
        self.avatarLabel.right = self.width - 10.0;
        self.bgContentView.right = self.avatarLabel.left - 8.0;
        self.errorButton.right = self.bgContentView.left - 22.0;
    } else {
        self.avatarLabel.left = 10.0;
        self.bgContentView.left = self.avatarLabel.right + 8.0;
        self.errorButton.left = self.bgContentView.right;
    }
    self.errorButton.centerY = self.bgContentView.centerY;
    self.bgContentImageView.frame = self.bgContentView.frame;
    self.bgContentImageView.top += 8.0;
    self.bgContentImageView.height -= 16.0;
    self.bgContentImageView.image = self.bubbleImage;
}

- (UIImage *)bubbleImage {
    UIImage *bubbleImage;
    BOOL isOwner = [self.message.from isEqualToString:[KGUtil util].uid];
    if (isOwner) {
        bubbleImage = [[UIImage imageNamed:@"chat_img_bladderr_normal"] stretchableImageWithLeftCapWidth:28. topCapHeight:20];
    } else {
        bubbleImage = [[UIImage imageNamed:@"chat_img_bladderl_normal"] stretchableImageWithLeftCapWidth:25. topCapHeight:20];
    }
    return bubbleImage;
}

- (void)setMessage:(KwaiIMMessage *)message {
    _message = message;
    BOOL isOwner = [message.from isEqualToString:[KGUtil util].uid];
    if (isOwner) {
        self.avatarLabel.text = @"U";
        self.avatarLabel.backgroundColor = [UIColor colorWithRed:0.00 green:0.60 blue:0.78 alpha:1.00];
    } else {
        self.avatarLabel.text = @"O";
        self.avatarLabel.backgroundColor = [UIColor colorWithRed:0.00 green:0.76 blue:0.40 alpha:1.00];
    }
    switch (message.state) {
        case KwaiIMMessageStateSendFailed:
            self.errorButton.hidden = false;
            break;
        case KwaiIMMessageStateCreate:
        case KwaiIMMessageStateSending:
        case KwaiIMMessageStateReceived:
        case KwaiIMMessageStateSendSuccess:
        default:
            self.errorButton.hidden = true;
            break;
    }
}

+ (CGSize)contentSizeWithMessage:(KwaiIMMessage *)message {
    return CGSizeZero;
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if(action == @selector(removeMessage:)){
        return YES;
    }
    return NO;
}


- (void)longPress:(UIGestureRecognizer *)gesture{
    
    if(gesture.state == UIGestureRecognizerStateBegan){
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        menu.arrowDirection = UIMenuControllerArrowDown;
        [menu setTargetRect:CGRectMake(CGRectGetWidth(self.frame)/2,
                                       CGRectGetHeight(self.frame)/2,
                                       200,
                                       20)
                     inView:self];
        UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"remove" action:@selector(removeMessage:)];
        menu.menuItems = @[item];
        [menu update];
        menu.menuVisible = YES;
    }
}

- (void)removeMessage:(id)sender{
    if(self.cellDelegate){
        [self.cellDelegate longPressForDeleteMessage:self];
    }
}

#pragma mark - getters

- (UILabel *)avatarLabel {
    if (_avatarLabel == nil) {
        _avatarLabel = [UILabel new];
        _avatarLabel.layer.cornerRadius = 25.0;
        _avatarLabel.numberOfLines = 2;
        _avatarLabel.textAlignment = NSTextAlignmentCenter;
        _avatarLabel.font = [UIFont fontWithName:@"Chalkduster" size:30];
        _avatarLabel.textColor = [UIColor whiteColor];
        
        _avatarLabel.clipsToBounds = true;
        [self.contentView addSubview:_avatarLabel];
    }
    return _avatarLabel;
}

- (UIView *)bgContentView {
    if (_bgContentView == nil) {
        _bgContentView = [UIView new];
        [self.contentView addSubview:_bgContentView];
    }
    return _bgContentView;
}

- (UIImageView *)bgContentImageView {
    if (_bgContentImageView == nil) {
        _bgContentImageView = [UIImageView new];
        _bgContentImageView.userInteractionEnabled = true;
        [self.contentView insertSubview:_bgContentImageView belowSubview:self.bgContentView];
    }
    return _bgContentImageView;
}

- (UIButton *)errorButton {
    if (!_errorButton) {
        _errorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"mail_btn_waring_normal"];
        [_errorButton setImage:image forState:UIControlStateNormal];
        [_errorButton setImage:image forState:UIControlStateHighlighted];
        _errorButton.size = CGSizeMake(22, 22);
        _errorButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_errorButton];
    }
    return _errorButton;
}

@end

