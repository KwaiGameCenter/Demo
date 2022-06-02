//
//  AVCaptureDevice+KSAuthorization.h
//  gif
//
//  Created by 薛辉 on 10/29/15.
//  Copyright (c) 2015 kuaishou. All rights reserved.
//

#import <Bolts/Bolts.h>
#import <AVFoundation/AVFoundation.h>

@interface AVCaptureDevice (KSAuthorization)
/**
 *  @param mediaType         either AVMediaTypeVideo or AVMediaTypeAudio
 *  @param completionHandler callback block
 */
+ (void)ks_processIfNeedForMediaTypes:(NSArray <NSString *>*)mediaTypes completionHandler:(void(^)(void))completionHandler;

+ (BFTask<NSNumber *> *)ks_taskForRequestingAccessForMediaType:(NSString *)mediaType;
+ (BFTask<NSNumber *> *)ks_taskForRequestingAccessForMediaTypes:(NSArray<NSString *> *)mediaTypes;

@end
