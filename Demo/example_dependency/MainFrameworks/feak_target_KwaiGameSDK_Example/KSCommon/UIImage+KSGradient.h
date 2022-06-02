//
//  UIImage+KSGradient.h
//  gif
//
//  Created by 曾令男 on 22/11/2017.
//  Copyright © 2017 kuaishou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (KSGradient)

/// @note color1 and color2 must be associated with the same color space
+ (UIImage *)gradientImageWithSize:(CGSize)size fromColor:(UIColor *)color1 toColor:(UIColor *)color2;

+ (UIImage *)radialGradientImageWithRadius:(CGFloat)radius fromColor:(UIColor *)color1 toColor:(UIColor *)color2;

+ (UIImage *)horizontalGradientImageWithSize:(CGSize)size fromColor:(UIColor *)color1 toColor:(UIColor *)color2;

@end
