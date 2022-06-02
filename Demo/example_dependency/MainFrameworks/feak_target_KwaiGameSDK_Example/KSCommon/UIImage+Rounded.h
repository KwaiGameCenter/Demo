//
//  UIImage+Rounded.h
//  Kwai
//
//  Created by han_zc on 14/7/19.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Rounded)

/**
 * 替换 UIImage+RoundedCorner.h 这个类别取的是image的info，有个类型ios不支持，导致图片无发
 * 显示。
 */
- (UIImage *)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize;

/**
 *  正圆形的图片
 *
 *  @param borderSize 边框大小
 *
 *  @return 经裁剪形成的正圆形图片
 */
- (UIImage *)perfectlyRoundedImageWithBorderSize:(NSInteger)borderSize;

/**
 将图片裁剪成圆形, 并在外侧增加圆形边框

 @param lineWidth 边框宽度
 @param borderColor 边框颜色
 @return 圆形带边框的图片, 半径为 原图片宽度+边框宽度*2
 */
- (UIImage *)perfectlyRoundedImageWithBorderLineWidth:(NSInteger)lineWidth borderColor:(nullable UIColor *)borderColor;

/**
将图片按照目标尺寸压缩，裁剪成圆形, 可以向内绘制边框

@param borderInsetSize 向内绘制边框
@param lineWidth 边框宽度
@param borderColor 边框颜色
@param targetSize 像素size
 
@return 圆形带边框的图片, 半径为 原图片宽度+边框宽度*2
*/
- (UIImage *)perfectlyRoundedImageWithBorderInset:(NSInteger)borderInsetSize
                                  borderLineWidth:(NSInteger)lineWidth
                                      borderColor:(nullable UIColor *)borderColor
                                       targetSize:(CGSize)targetSize;

@end
