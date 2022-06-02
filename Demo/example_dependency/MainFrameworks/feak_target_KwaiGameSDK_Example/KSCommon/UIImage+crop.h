//
//  UIImage+crop.h
//  Kwai
//
//  Created by zhongchao.han on 15/4/28.
//
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    KSImageCuttingTypeCenter = 0,
    KSImageCuttingTypeTop = 1,
    KSImageCuttingTypeBottom = 2,
    KSImageCuttingTypeLeft = 3,
    KSImageCuttingTypeRight = 4,
} KSImageCuttingType;

@interface UIImage (crop)

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize enableScreenScale:(BOOL)enableScreenScale;

/**
 裁剪图片，跟系统 `CGImageCreateWithImageInRect` 的行为一致。

 @param rect 针对完整尺寸的图片
 @return 截取的图片，超出范围截取两个矩形交集部分，范围无效返回空。
 */
- (UIImage *)imageByCroppingToRect:(CGRect)rect;
- (UIImage *)imageByCroppingToRect:(CGRect)rect scale:(CGFloat)scale;

/**
 按照需要尺寸剪裁图片

 @param targetRect 目的image的rect
 @return targetRect的iamge 若targetRect超出原图范围，将不会剪裁，返回原图
 */
- (UIImage *)imageCropByRect:(CGRect)targetRect;

/**
 按照服务器上原始尺寸按比例剪裁图片 强制按照1：1剪裁成正方形，优先使用较大边进行裁剪，超出图片范围则使用小边，还超出范围则不剪裁

 @param targetRect 原始图片的rect
 @param cropScaleX x的缩放比例 0<x<=1
 @param cropScaleY y的缩放比列 0<y<=1
 @return targetRect按比例剪裁后的iamge 若超出原图范围，将不会剪裁，返回原图
 */
- (UIImage *)profileSquareCoverCropByRect:(CGRect)originalRect originalImageWidth:(CGFloat)originalImageWidth originalImageHeight:(CGFloat)originalImageHeight; //处理profile页作品封面剪裁，按照正方形剪裁


/// 按照服务端下发的数据对图片进行裁切
/// @param type 裁切的方向
/// @param originalSize 画布的大小
/// @param targetSize 裁切的大小
- (UIImage *)cutImageByCuttingType:(KSImageCuttingType)type
                      originalSize:(CGSize)originalSize
                        targetSize:(CGSize)targetSize;

@end
