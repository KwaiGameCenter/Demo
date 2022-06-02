//
//  KSSpreadLabel.h
//  gif
//
//  Created by zhongchao.han on 16/8/25.
//  Copyright © 2016年 kuaishou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSSpreadLabel : UIView

/** 文字的对其方式 */
@property (nonatomic, assign) NSTextAlignment textAlignment;
/** 根据这个来绘制 */
@property (nonatomic, strong) NSMutableAttributedString *attributedText;
/** 点击link对应的anchor */
@property (nonatomic, copy) NSString*(^linkAnchorBlock)(NSDictionary *userInfo);
/** 点击at的anchor */
@property (nonatomic, copy) NSString*(^atAnchorBlock)(NSDictionary *userInfo);
/** 高度变化的回调 */
@property (nonatomic, copy) void(^didHeightChanged)(CGFloat height);
/** 是否已经展开 */
@property (nonatomic, assign) BOOL spreaded;

/**
 * 重组attributed string。让attributedString的行数在指定范围内。并支持动态添加尾巴
 */
+ (NSAttributedString *)attributedString:(NSAttributedString *)contentString
                            maxLineCount:(int)maxLineCount
                              labelWidth:(CGFloat)labelWidth
                             spreadIndex:(NSUInteger)spreadIndex
                             spreadTitle:(NSAttributedString *)spreadTitle;

@end
