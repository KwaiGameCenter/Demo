//
//  UIImage+Adaptive.h
//  KSCommon
//
//  Created by UJOY on 2020/9/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// FYI: dynamic为高风险敏感词，所以替换为别的词

@interface UIColor(Adaptive)

/// 是否动态色
- (BOOL)isAdaptiveColor;

@end

@interface UIImage(Adaptive)

///是否动态图片
- (BOOL)isAdaptiveImage;

///traitCollection 默认[UITraitCollection currentCollection]
- (UIImage *)resolveImageWithTraitCollection:(UITraitCollection * _Nullable)traitCollection;

/// 指定资源light图片
+ (UIImage *)lightImageWithImageNamed:(NSString *)imageName;

/// 指定资源light图片
+ (UIImage *)lightImageWithImage:(UIImage *)image;

/// 指定资源dark图片
+ (UIImage *)darkImageWithImageNamed:(NSString *)imageName;

/// 指定资源dark图片
+ (UIImage *)darkImageWithImage:(UIImage *)image;

/// 动态图片 支持light dark切换
+ (UIImage *)imageWithLightImage:(UIImage *)lightImage dark:(UIImage *)darkImage;

/// 动态图片 支持light dark切换
+ (UIImage *)imageWithLightImageNamed:(NSString *)lightImageName dark:(NSString *)darkImageName;

@end

NS_ASSUME_NONNULL_END
