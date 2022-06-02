//
//  AVAssetExportSession+KSProgress.h
//  gif
//
//  Created by 曾令男 on 11/04/2017.
//  Copyright © 2017 kuaishou. All rights reserved.
//

#import <Bolts/Bolts.h>
#import <AVFoundation/AVFoundation.h>

@interface AVAssetExportSession (KSProgress)

- (void)exportAsynchronouslyWithCompletionHandler:(void (^)(void))handler progressBlock:(void (^)(float progress))progressBlock;

/**
 Progress回调 + BFTask
 */
- (BFTask<NSURL *> *)exportAsynchronouslyWithCancellationToken:(BFCancellationToken *)token progressBlock:(void (^)(float progress))progressBlock;
@end
