//
//  AVAsset+KSPreciseVideoTimeRange.h
//  gif
//
//  Created by 曾令男 on 09/02/2017.
//  Copyright © 2017 kuaishou. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAsset (KSPreciseVideoTimeRange)

@property (nonatomic, readonly) CMTimeRange preciseVideoTimeRange;

@end
