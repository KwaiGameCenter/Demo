//
//  HLRichLabel.h
//  HLRichLabel
//
//  Created by han_zc on 14-5-15.
//  Copyright (c) 2014年 hanzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLStringAttributeInterface.h"
#import "HLURLAttributedStringProcesser.h"
#import <CoreText/CoreText.h>

extern NSString *kCTCustomHightLight;
extern CGMutablePathRef createRoundedRectForRect(CGRect rect, CGFloat radius);
/**
 * 可拓展的富文本label。
 * 这里将attributedString的组装和HLRichLabel分离的目的是让attributedString的拼装在非主线程操作
 * 注意：size 的设置必须要在最后设置，引起带标签的字符串会被缩短
 */
@interface HLRichLabel : UIView {
    @protected
    NSMutableArray *_stringAttributes;
    NSMutableDictionary *_runRectToAttributes;
}

@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) NSLineBreakMode lineTruncationMode;
@property (nonatomic, assign) CGFloat preferredMaxLayoutWidth;

/**
 * 根据这个来绘制
 */
@property (nonatomic, strong) NSMutableAttributedString *attributedText;

/**
 * 点击link对应的anchor TODO: 统一到子类处理
 */
@property (nonatomic, copy) NSString*(^linkAnchorBlock)(NSDictionary *userInfo);

/**
 * 点击at的anchor TODO: 统一到子类处理
 */
@property (nonatomic, copy) NSString*(^atAnchorBlock)(NSDictionary *userInfo);

@property (nonatomic, copy) void(^didTapAttribute)(id<HLStringAttributeInterface> attribute);

@property (nonatomic, assign) CGFloat lineSpaceing;

@property (nonatomic, assign) NSInteger numberOfLines;

/**
 * override methods
 */
- (void)didTapAttribute:(id<HLStringAttributeInterface>) attribute;

/**
 * 计算需要的大小,宽度固定
 */
+ (CGSize)sizeWithString:(NSMutableAttributedString*)string width:(CGFloat)width;

/**
 * 计算需要的大小,宽度不固定
 */
+ (CGSize)adjustedWidthSizeWithString:(NSMutableAttributedString*)string width:(CGFloat)width;

/**
 * 计算需要的高度,这里要多出5个point，因为表情有时会出界
 */
+ (CGFloat)heightWithString:(NSMutableAttributedString*)string width:(CGFloat)width;

/**
 *  计算需要的高度，并把计算过程中的CTLineRef数组暴露出来
 */
+ (CGFloat)heightWithString:(NSMutableAttributedString*)string width:(CGFloat)width linesQuery:(void(^)(CFArrayRef lines))action;

/**
 *  计算需要的高度，可以控制显示文字的最大行数
 */
+ (CGFloat)heightWithString:(NSMutableAttributedString*)string width:(CGFloat)width numberOfLines:(NSInteger)numberOfLines linesQuery:(void(^)(CFArrayRef lines))action;

+ (CTFrameRef)createFrameWithSize:(CGSize)size attributedText:(NSAttributedString*)attributedText;
/**
 * 行间距，最小为6.
 */
+(void)setLineSpaceing:(CGFloat)lineSpaceing attributeString:(NSMutableAttributedString*)attributeString;
/**
 * 用户自定义的行间距
 */
+ (void)setUserDefinedLineSpacing:(CGFloat)userDefinedLineSpacing forAttributeString:(NSMutableAttributedString*)attributeString;

/**
 * 获取用户自定义的行间距
 */
+ (CGFloat)userDefinedLineSpacingForAttributeString:(NSMutableAttributedString*)attributeString;

/**
 * 字间距
 */
+(void)setKern:(CGFloat)kern attributeString:(NSMutableAttributedString*)attributeString;

/**
 * 字体颜色
 */
+(void)setTextColor:(UIColor *)textColor attributeString:(NSMutableAttributedString*)attributeString;

/**
 * 字体大小，默认为14.
 */
+(void)setTextSize:(CGFloat)textSize isBold:(BOOL)isBold attributeString:(NSMutableAttributedString*)attributeString;

+ (void)setTextFont:(UIFont *)font attributeString:(NSMutableAttributedString*)attributeString;

+ (CGFloat)obtainFontSize:(NSAttributedString*)attributeString;

+ (CGFloat)obtainLineSpacing:(NSAttributedString*)attributeString;
/**
 * 判断是否点击到热区
 */
- (void)didTouchDown:(CGPoint)positon hitResultBlock:(void(^)(BOOL hit, id stringAttribute))hitResultBlock;

@end
