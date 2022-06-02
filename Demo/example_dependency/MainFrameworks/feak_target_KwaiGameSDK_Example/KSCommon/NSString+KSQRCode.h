//
//  NSString+KSQRCode.h
//  gif
//
//  Created by LiSi on 10/11/2016.
//  Copyright © 2016 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KSQRCode)


/**
 根据String内容生成二维码

 @param size        二维码尺寸

 @return 生成的二维码
 */
- (nullable UIImage *)ks_QRCodeImageWithSize:(CGSize)size;

/// 生成带颜色的二维码
- (nullable UIImage *)ks_QRCodeImageWithSize:(CGSize)size color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor;

+ (nullable instancetype)ks_stringFromCIImage:(nonnull CIImage *)image;

@end
