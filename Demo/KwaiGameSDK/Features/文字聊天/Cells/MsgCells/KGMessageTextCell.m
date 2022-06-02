//
//  KGMessageTextCell.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/12/7.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "KGMessageTextCell.h"
#import <KwaiGameSDK-IM/KwaiIMTextMessage.h>
#import "KGUtil.h"
#import <HLRichLabel/HLRichLabel.h>

CGFloat const kKwaiCellMaxContentWidht = 200.0;
CGFloat const kKwaiCellContentMargin = 18.0;

@interface KGMessageTextCell()

@property (strong, nonatomic) HLRichLabel *contentLabel;
@property (strong, nonatomic) NSMutableAttributedString *attributed;

@end

@implementation KGMessageTextCell

- (void)setMessage:(KwaiIMMessage *)message {
    self.attributed = nil;
    [super setMessage:message];
    BOOL isOwner = [message.from isEqualToString:[KGUtil util].uid];
    NSString *text;
    if ([message isMemberOfClass:[KwaiIMTextMessage class]]) {
        text = message.text;
    } else {
        text = [NSString stringWithFormat:@"不支持显示的%@", NSStringFromClass(message.class)];
    }
    if (text.length > 0) {
        [self.attributed removeAttribute:(__bridge id)kCTUnderlineStyleAttributeName range:NSMakeRange(0, self.attributed.mutableString.length)];
        [self.attributed removeAttribute:kCustomStringAttribute range:NSMakeRange(0, self.attributed.mutableString.length)];
        [self.attributed replaceCharactersInRange:NSMakeRange(0, self.attributed.mutableString.length) withString:text];
    } else {
        [self.attributed replaceCharactersInRange:NSMakeRange(0, self.attributed.mutableString.length) withString:@"@"];
    }
    
    [HLURLAttributedStringProcesser sharedHLURLAttributedStringProcesser].linkTextColor = [UIColor colorWithRed:0.36 green:0.79 blue:0.96 alpha:1.00];
    if (isOwner) {
        [HLRichLabel setTextColor:[UIColor blackColor] attributeString:self.attributed];
        [HLURLAttributedStringProcesser sharedHLURLAttributedStringProcesser].linkTextColor = [UIColor whiteColor];
    } else {
        [HLRichLabel setTextColor:[UIColor blackColor] attributeString:self.attributed];
    }
    
    [HLRichLabel setTextFont:[UIFont systemFontOfSize:15] attributeString:self.attributed];
    [HLRichLabel setLineSpaceing:6 attributeString:self.attributed];
    [[HLURLAttributedStringProcesser sharedHLURLAttributedStringProcesser] configAttributedString:self.attributed];
    self.contentLabel.size = [HLRichLabel adjustedWidthSizeWithString:self.attributed width:kKwaiCellMaxContentWidht];
    self.contentLabel.attributedText = self.attributed;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    BOOL isOwner = [self.message.from isEqualToString:[KGUtil util].uid];
    if (isOwner) {
        self.contentLabel.right = self.bgContentView.width - kKwaiCellContentMargin;
    } else {
        self.contentLabel.left = kKwaiCellContentMargin;
    }
    self.contentLabel.centerY = self.bgContentView.height / 2.0;
}

+ (CGSize)contentSizeWithMessage:(KwaiIMMessage *)message {
    
    NSString *text;
    if ([message isMemberOfClass:KwaiIMTextMessage.class]) {
        text = message.text;
    } else {
        text = [NSString stringWithFormat:@"不支持显示的%@", NSStringFromClass(message.class)];
    }
    
    CGFloat height = 36;
    CGFloat width = 36;
    CGSize contentSize;
    NSMutableAttributedString *attributed;
    attributed = [[NSMutableAttributedString alloc] initWithString:text];
    
    [[HLURLAttributedStringProcesser sharedHLURLAttributedStringProcesser] configAttributedString:attributed];
    [HLRichLabel setTextFont:[UIFont systemFontOfSize:15] attributeString:attributed];
    [HLRichLabel setLineSpaceing:6.0 attributeString:attributed];
    
    contentSize = [HLRichLabel adjustedWidthSizeWithString:attributed width:kKwaiCellMaxContentWidht];
    if (contentSize.height > 25) {
        contentSize.width = kKwaiCellMaxContentWidht;
    }
    height += contentSize.height;
    width += contentSize.width;
    return CGSizeMake(width, height);
    
}

- (HLRichLabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[HLRichLabel alloc] initWithFrame:CGRectZero];
        _contentLabel.backgroundColor = [UIColor clearColor];
        [self.bgContentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (NSMutableAttributedString *)attributed {
    if (!_attributed) {
        _attributed = [[NSMutableAttributedString alloc] initWithString:@"@"];
    }
    return _attributed;
}

@end
