// UIImage+Resize.h
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.
// Modified by Albert Tong : https://github.com/AlbertTong/UIImageCategoriesTrevorHarmon

// Extends the UIImage class to support resizing/cropping
@interface UIImage (Resize)
- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImageOfMaxSize:(CGFloat)maxSize
     interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImageOfMaxSize:(CGFloat)maxSize
              interpolationQuality:(CGInterpolationQuality)quality
                       forceRotate:(BOOL)forceRotate;

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;
@end
