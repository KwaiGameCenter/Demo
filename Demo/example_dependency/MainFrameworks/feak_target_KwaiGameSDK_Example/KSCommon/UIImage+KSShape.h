//
//  UIImage+KSShape.h
//  gifHomeModule
//
//  Created by Ruiqing Wan on 2018/6/20.
//

/**
 * 提供一些特定形状的Image获取方式
 */

#import <UIKit/UIKit.h>

@interface UIImage (KSShape)

/**
 * 生成水平方向一个特定大小的矩形颜色渐变的image，如果不指定颜色或者大小不对，将返回nil
 * @param size 大小
 * @param startColor 渐变的开始颜色
 * @param endColor 渐变的最终颜色
 * @return 返回生成的image
 */
+ (UIImage *)ks_horizontalGradientImageWithSize:(CGSize)size startColor:(UIColor *)startColor endColor:(UIColor *)endColor;

/**
 * 生成垂直方向一个特定大小的矩形颜色渐变的image，如果不指定颜色或者大小不对，将返回nil
 * @param size 大小
 * @param startColor 渐变的开始颜色
 * @param endColor 渐变的最终颜色
 * @return 返回生成的image
 */
+ (UIImage *)ks_verticalGradientImageWithSize:(CGSize)size startColor:(UIColor *)startColor endColor:(UIColor *)endColor;

/**
 根据起始/终止点生成一个特定大小的矩形颜色渐变的image，如果不指定颜色或者大小不对，将返回nil

 * @param size 大小
 * @param scale 缩放，0 代表用屏幕 scale
 * @param startPoint 起始点，坐标取值范围 0-1
 * @param endPoint 终止，坐标取值范围 0-1
 * @param startColor 渐变的开始颜色
 * @param endColor 渐变的最终颜色
 * @return 返回生成的image
 */
+ (UIImage *)ks_gradientImageWithSize:(CGSize)size
                                scale:(CGFloat)scale
                           startPoint:(CGPoint)startPoint
                             endPoint:(CGPoint)endPoint
                           startColor:(UIColor *)startColor
                             endColor:(UIColor *)endColor;

/**
 * 生成一个圆形的空心圆UIImage,如果不指定颜色或者大小不对，将返回nil
 * @param radius 整个园的半径
 * @param borderWidth 外圈的宽度
 * @param borderColor 外圈的颜色
 * @return 返回生成的UIImage
 */
+(UIImage *)ks_borderCircleImageWithRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 * 生成一个正方形边角的圆角掩盖式UIImage，如果不指定颜色或者大小不对，将返回nil
 * @param radius 圆角大小
 * @param color 颜色
 * @return 返回生成的UIImage
 */
+(UIImage *)ks_roundedCornerMaskImageWithRadius:(CGFloat)radius color:(UIColor *)color;

@end
