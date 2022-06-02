//
//  AVAssetExportSession+BFTask.h
//  gif
//
//  Created by 曾令男 on 24/04/2017.
//  Copyright © 2017 kuaishou. All rights reserved.
//

#import <Bolts/Bolts.h>
#import <AVFoundation/AVFoundation.h>

@interface AVAssetExportSession (BFTask)

- (BFTask<NSURL *> *)exportAsynchronouslyWithCancellationToken:(BFCancellationToken *)token;

@end
