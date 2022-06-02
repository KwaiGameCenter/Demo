//
//  UIImage+KSGIF.h
//  gif
//
//  Created by 薛辉 on 7/30/15.
//  Copyright (c) 2015 kuaishou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

@interface UIImage (KSGIF)

+ (UIImage *)ks_disAnimatedGIFWithData:(NSData *)data;

+ (UIImage *)ks_animatedGIFWithData:(NSData *)data;

+ (float)ks_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source;

@end
