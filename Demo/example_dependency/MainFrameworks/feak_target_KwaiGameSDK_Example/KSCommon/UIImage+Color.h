//
//  UIImage+Color.h
//  gif
//
//  Created by Hale Chan on 8/25/15.
//  Copyright (c) 2015 kuaishou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageRenderInfo:NSObject{
@public
    struct {
        int image_with_size_color_corners_radius:1;
        int image_with_size_color_corners_cornerRadii:1;
        int image_with_size_color_radius_border:1;
        int image_with_color_radius_border_resize:1;
        int image_with_color_radius_border_hresize:1;
    } selContext;
}
@property(nonatomic,assign) CGSize size;
@property(nonatomic,strong) UIColor * color;

@property(nonatomic,assign) UIRectCorner corners;
@property(nonatomic,assign) CGSize cornerRadii;

@property(nonatomic,assign) CGFloat borderWidth;
@property(nonatomic,strong) UIColor * borderColor;

@property(nonatomic,assign) CGFloat innerBorderWidth;
@property(nonatomic,strong) UIColor * innerBorderColor;

@end

@interface UIImage (Color)

@property(nonatomic,strong) UIImageRenderInfo * renderInfo;

+ (instancetype)imageWithSize:(CGSize)size color:(UIColor *)color corners:(UIRectCorner)corners cornerRadius:(CGFloat)radius;

+ (instancetype)imageWithSize:(CGSize)size color:(UIColor *)color cornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

+ (instancetype)imageWithSize:(CGSize)size color:(UIColor *)color cornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor innerBorderWidth:(CGFloat)innerBorderWidth innerBorderColor:(UIColor *)innerBorderColor;

// 方法生成的边框有毛边的问题, 不建议使用, 可以使用下面的 + (UIImage *)ks_imageWithSize:color:corners:cornerRadii:borderWidth:borderColor
+ (instancetype)imageWithSize:(CGSize)size color:(UIColor *)color corners:(UIRectCorner)corners cornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

//这个方法在iOS8 会有crash， badcase :[UIImage resizableImageWithColor:normalColor cornerRadius:2 borderWidth:10 borderColor:[UIColor redColor]];
+ (instancetype)resizableImageWithColor:(UIColor *)color cornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

+ (instancetype)horizontalResizableImageWithHeight:(CGFloat)height fillColor:(UIColor *)fillColor cornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

+ (instancetype)setWaterMark:(UIImage *)waterMark atBackgroundImage:(UIImage *)backgroundImage atPosition:(CGPoint)position withDesignedSize:(CGSize)waterMarkSize;

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                              corners:(UIRectCorner)corners
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor
                       borderLineJoin:(CGLineJoin)borderLineJoin;

@end


@interface UIImage (KSShapeBorder)


/// 生产图片
/// @param size 图片尺寸
/// @param drawBlock 实际绘制图片的方法
+ (UIImage *)ks_imageWithSize:(CGSize)size
                    drawBlock:(void (^)(CGContextRef context))drawBlock;

/// 生产带有圆角和边框的图片
/// @param size 图片尺寸
/// @param color 背景颜色
/// @param corners 圆角
/// @param cornerRadii 圆角大小
/// @param borderWidth 边框大小
/// @param borderColor 边框颜色
+ (UIImage *)ks_imageWithSize:(CGSize)size
                        color:(UIColor *)color
                      corners:(UIRectCorner)corners
                  cornerRadii:(CGSize)cornerRadii
                  borderWidth:(CGFloat)borderWidth
                  borderColor:(UIColor *)borderColor;
@end
