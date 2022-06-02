//
//  ImageUtil.h
//  ImageProcessing
//
//  Created by Evangel on 10-11-23.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>

#define AHFloat double

@interface ImageUtil : NSObject

/**
 * 让图片盖满viewsize区域。多余的部分居中切掉
 */
+ (UIImage *)image:(UIImage *)image fitInSize:(CGSize)viewsize;

/*
 * AspectFit 填充效果
 */
+ (UIImage *)image:(UIImage *)image scaledToFitSize:(CGSize)size;

+ (UIImage *)rotateImage:(UIImage *)aImage toOrient:(UIImageOrientation)orient;

+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 atRect:(CGRect) rect;
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 andAlpha:(CGFloat) alpha;
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 andAlpha:(CGFloat) alpha atRect:(CGRect) rect;

@end

