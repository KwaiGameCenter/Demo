//
//  AVAsset+KSMeta.h
//  gif
//
//  Created by 薛辉 on 4/5/17.
//  Copyright © 2017 kuaishou. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <KSCommon/KSAVAssetMetadata.h>

typedef void(^KSAssetMetaPrepareCompletionHandler)(BOOL complete);

@interface AVAsset (KSMeta)

@property (nonatomic, assign, readonly) NSTimeInterval seconds;   // duration in seconds


/**
 ksMetadata 是否已经设置完毕，详见ksMetadata注释↓
 */
@property (nonatomic, assign, readonly, getter=isPrepared) BOOL prepared;

/**
 在prepared之前访问该属性将会触发同步获取
 建议的使用方式是首先执行prepareAsyncWithCompletionHandler并在其回调中访问该属性
 */
@property (nonatomic, strong, readonly) KSAVAssetMetadata *ksMetadata;

/**
 异步设置KSAVAssetMetadata
 */
- (void)prepareAsyncWithCompletionHandler:(KSAssetMetaPrepareCompletionHandler)completionHandler;

- (NSDictionary *)ks_meta;
@end
