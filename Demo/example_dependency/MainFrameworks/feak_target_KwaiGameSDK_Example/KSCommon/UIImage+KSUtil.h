//
//  UIImage+KSUtil.h
//  gif
//
//  Created by tanbing on 2017/4/1.
//  Copyright © 2017年 kuaishou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (KSUtil)

///是否延迟着色
@property(nonatomic,assign) BOOL needDelayTinted;

///图片tintColor
@property (nonatomic, strong) UIColor* tintColor;

/**
 获取图片jpeg格式的数据
 @param maxLength 数据的最长长度
 @return 图片的jpeg格式的数据
 */
- (NSData *)ks_jpegDataRestrictToLength:(NSUInteger)maxLength;

/**
 旋转图片

 @param angle 逆时针旋转角度
 @return 旋转后的图片
 */
- (UIImage *)rotatedImageWithAngle:(double)angle;

/**
 * 生成一个带透明度的图片
 *
 * @param alpha 对应透明度
 * @return 返回新生成的图片
 */
- (UIImage *)ks_transparentImageWithAlpha:(CGFloat)alpha;

/**
 * 生成一个带透明度的图片
 *
 * @param alpha 对应透明度
 * @param blendMode 混合模式
 * @return 返回新生成的图片
 */
- (UIImage *)ks_transparentImageWithAlpha:(CGFloat)alpha blendMode:(CGBlendMode)blendMode;

/**
 彩色图片转为黑白图片
 
 不同实现方案的Benchmark如下(iPhone8 Plus 12.3.1):
 
 Size        | Core Image   | vImage
 256 x 256   | 2.2 ms       | 0.4 ms
 512 x 512   | 3.0 ms       | 1.0 ms
 1024 x 1024 | 5.5 ms       | 3.0 ms
 2048 x 2048 | 12.9 ms      | 11.5 ms
 4096 x 4096 | 41.0 ms      | 44.0 ms
 
 基于上面的benchmark，目前采用vImage的实现方式
 
 @return 黑白图片
 */
- (UIImage *)ks_grayScaledImage;

/**
 对于有imageOrientation不是UIImageOrientationUp的图片，旋转一下
 
 @see   原理解释：https://www.impulseadventure.com/photo/exif-orientation.html
 @see   测试用例：https://github.com/recurser/exif-orientation-examples
 
 不同实现方案的Benchmark如下(iPhone8 Plus 12.3.1):
 
 Size        | CoreGraphics | vImage    | CoreImage
 256 x 256   | 0.5 ms       | 1.0 ms    | 2.9 ms
 512 x 512   | 1.2 ms       | 3.1 ms    | 2.9 ms
 1024 x 1024 | 4.7 ms       | 11.1 ms   | 4.5 ms
 2048 x 2048 | 51.2 ms      | 48.2 ms   | 11.8 ms
 4096 x 4096 | 252.3 ms     | 212.2 ms  | 53.8 ms
 
 基于上面的benchmark，对于小图(width * height < 1024 * 1024)采用CoreGraphics来实现，对于大图使用CoreImage来实现
 
 @return 旋转后的图片
 */
- (UIImage *)fixOrientation;

/**
 旧的高亮图
 
 以前是使用GPUImage通过类似于lut的方式实现的颜色转换，实际效果是rgb各通道乘以系数0xb2 / 255.0。
 考虑到一般是图标才会有高亮行为，图标大小不会很大，直接使用vImage实现来提升性能
 
 @return 高亮图
 */
- (UIImage *)ks_legacyHighlightImage;

/**
 在Context中绘制当前图像
 
 @notice    需要调用方保证context的scale(CTM)与image的scale的匹配
 
 @param context Core Graphics Context实例
 */
- (void)ks_drawInCGContext:(CGContextRef)context;

/**
 类似于GPUImageiOSBlurFilter实现的模糊效果

 @param radius 模糊半径，单位是point
 @param saturation 饱和度调整，GPUImageiOSBlurFilter实现的默认是0.8
 @return 模糊图
 */
- (UIImage *)ks_blurredImageWithRadius:(CGFloat)radius saturation:(CGFloat)saturation;


- (BOOL)ks_isEqualToImage:(UIImage *)image;

@end


@interface UIImage (KSTint)

- (UIImage *)ks_imageWithTintColor:(UIColor *)tintColor;

@end
