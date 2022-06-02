//
//  AVCaptureDevice+KSHelpers.h
//  gif
//
//  Created by 曾令男 on 2016/12/8.
//  Copyright © 2016年 kuaishou. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVCaptureDevice (KSHelpers)

- (Float64)mostFittingFrameRateOfCurrentFormatForFrameRate:(Float64)frameRate;

- (BOOL)ks_supportResolution:(CGSize)resolution;
//NSVaue CGSize
- (NSArray <NSValue *> *)ks_supportedCaptureResolutions;
+ (AVCaptureDevice *)ks_backVideoDevice;
+ (AVCaptureDevice *)ks_frontVideoDevice;

@end
