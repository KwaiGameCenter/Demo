//
//  UIImage+Collage.h
//  KSCommon
//
//  Created by 尤睿 on 2019-05-6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KSImageCollagePiece : NSObject

@property (nonatomic, strong) UIImage *sourceImage;

// 裁剪（剪切）区域。位于 source image 的坐标系中
@property (nonatomic) CGRect cropRect;

// 绘制（粘贴）区域。位于要粘贴到的 image 坐标系中
@property (nonatomic) CGRect targetRect;

@end

@interface UIImage (Collage)

// 按照所传数组顺序绘制
- (UIImage *)ks_imageByAddingCollagePieces:(NSArray<KSImageCollagePiece *> *)pieces;

@end

NS_ASSUME_NONNULL_END
