//
//  UIImage+KSCoreMedia.h
//  gif
//
//  Created by 薛辉 on 9/17/15.
//  Copyright (c) 2015 kuaishou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>

@interface UIImage (KSCoreMedia)

+ (instancetype)ks_imageWithSampleBuffer:(CMSampleBufferRef) sampleBuffer;

@end
