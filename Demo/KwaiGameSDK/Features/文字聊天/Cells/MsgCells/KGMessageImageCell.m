//
//  KGMessageImageCell.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/12/7.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "KGMessageImageCell.h"
#import <KwaiGameSDK-IM/KwaiIMImageMessage.h>
#import <KwaiGameSDK-IM/KwaiIMDownloadRuleManager.h>
#import "UIImageView+WebCache.h"

@interface KGMessageImageCell()

@property (strong, nonatomic) UIImageView *contentImageView;

@end

@implementation KGMessageImageCell

- (void)setMessage:(KwaiIMImageMessage *)message {
    [super setMessage:message];
    if (message.attachmentFilePath.length > 0) {
        NSData *data = [NSData dataWithContentsOfFile:message.attachmentFilePath];
        [self setImageWithData:data];
    } else {
        NSString *URLString = [[KwaiIMDownloadRuleManager sharedManagerWithSubBiz:message.subBiz] getURLStringWithURIString:message.uri];
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:nil options:SDWebImageHandleCookies];
    }
    [self setNeedsLayout];
}

- (void)setImageWithData:(NSData *)data {
    UIImage *image = [UIImage imageWithData:data];
    [self.contentImageView setImage:image];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentImageView.frame = self.bgContentImageView.frame;
}

- (UIImage *)bubbleImage {
    return nil;
}

+ (CGSize)contentSizeWithMessage:(KwaiIMMessage *)message {
    return CGSizeMake(150, 150);
}

- (UIImageView *)contentImageView {
    if (_contentImageView == nil) {
        _contentImageView = [UIImageView new];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_contentImageView];
    }
    return _contentImageView;
}

@end
