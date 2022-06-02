//
//  AVAsset+KSImageFrames.h
//  gif
//
//  Created by 薛辉 on 10/14/15.
//  Copyright (c) 2015 kuaishou. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAsset (KSImageFrames)

- (UIImageOrientation)ks_preferredOrientation;
- (CGAffineTransform )ks_preferredTransform;
- (NSArray *)ks_images;
- (void)ks_enumSampleBuffersWithBlock:(void(^)(CMSampleBufferRef sampleBuffer, NSUInteger idx, BOOL *stop))block;

/**
 * 
 * 遍历出指定时间段的CMSampleBufferRef
 * @param timeRange 遍历的区间，如果要遍历整个区间，就传kCMTimeRangeInvalid
 * @param block 遍历的block
 */
- (void)ks_enumSampleBuffersWithTimeRange:(CMTimeRange)timeRange block:(void(^)(CMSampleBufferRef sampleBuffer, NSUInteger idx, BOOL *stop))block;

- (CMTime)ks_availableSamplesDuration;
@end


@interface AVAssetTrack (KSImageFrames)
- (UIImageOrientation)ks_preferredOrientation;
@end
