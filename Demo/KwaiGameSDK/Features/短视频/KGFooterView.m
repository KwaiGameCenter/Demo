//
//  KGFooterView.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2020/3/6.
//  Copyright © 2020 mookhf. All rights reserved.
//

#import "KGFooterView.h"

@implementation KGFooterView

+ (KGFooterView *)refreshFooterView {
    KGFooterView *refreshFooterView = [[self alloc] init];
    refreshFooterView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35);
    return refreshFooterView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = YES;
    }
    return self;
}

#pragma mark - 设置子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.text = @"正在加载更多数据";
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    
    // 获取文字宽度
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSFontAttributeName] = label.font;
    CGFloat textWidth = [label.text sizeWithAttributes:attr].width;
    
    [self addSubview:label];
    
    /* 菊花 */
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.frame = CGRectMake((label.frame.size.width + textWidth) * 0.5, 0, label.frame.size.width, label.frame.size.width);
    [activity startAnimating];
    [self addSubview:activity];
}


@end
