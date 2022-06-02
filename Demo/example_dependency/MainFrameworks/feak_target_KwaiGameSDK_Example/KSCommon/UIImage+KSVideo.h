//
//  UIImage+KSVideo.h
//  gif
//
//  Created by 薛辉 on 8/3/15.
//  Copyright (c) 2015 kuaishou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (KSVideo)

+ (instancetype)ks_imageWithAssetURL:(NSURL *)assetURL;

+ (instancetype)ks_imageWithAssetURL:(NSURL *)assetURL maximumSize:(CGSize)maximumSize;

+ (instancetype)ks_imageWithAssetURL:(NSURL *)assetURL timestamp:(NSTimeInterval)timestamp maximumSize:(CGSize)maximumSize;

+ (void)ks_loadAnimatedImageWithAssetURL:(NSURL *)assetURL
                             maximumSize:(CGSize)maximumSize
                       completionHandler:(void (^)(UIImage *animatedImage))completionHandler;

+ (void)ks_loadCachedAnimatedImageWithAssetURL:(NSURL *)assetURL
                                      cacheKey:(NSString *)cacheKey
                                   maximumSize:(CGSize)maximumSize
                             completionHandler:(void (^)(UIImage *))completionHandler;

+ (void)ks_loadCachedGifAnimatedImageWithAssetURL:(NSURL *)assetURL
                                         cacheKey:(NSString *)cacheKey
                                completionHandler:(void (^)(UIImage *))completionHandler;

+ (instancetype)ks_firstGifImageWithAssetURL:(NSURL *)assetURL;

@end
