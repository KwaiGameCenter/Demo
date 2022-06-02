//
//  UIImage+KSBlur.h
//  gif
//
//  Created by 张颂 on 16/6/24.
//  Copyright © 2016年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (KSBlur)

- (UIImage *)ksBlurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;
- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;
@end
