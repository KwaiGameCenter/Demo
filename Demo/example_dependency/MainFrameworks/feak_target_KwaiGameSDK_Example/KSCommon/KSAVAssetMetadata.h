//
//  KSAVAssetMetadata.h
//  gif
//
//  Created by 杨鑫磊 on 2017/9/25.
//  Copyright © 2017年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/**
 从AVAsset的Metadata中解析到的信息，部分字段可能为空
 */
@interface KSAVAssetMetadata : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *albumArtist;
@property (nonatomic, copy) NSString *album;
@property (nonatomic, copy) NSString *grouping;
@property (nonatomic, copy) NSString *composer;
@property (nonatomic, copy) NSString *comments;
@property (nonatomic, strong) UIImage *artwork;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, strong) NSNumber *bpm;
@property (nonatomic, strong) NSNumber *trackNumber;
@property (nonatomic, strong) NSNumber *trackCount;
@property (nonatomic, strong) NSNumber *discNumber;
@property (nonatomic, strong) NSNumber *discCount;
// 注:此属性主App目前未使用到,但是Kwai中MV功能用到了,为了保证模块的可复用性,加了这个属性
@property (nonatomic, copy) NSString *location;

/**
 设置key对应的属性
 */
- (void)addMetadataItem:(AVMetadataItem *)item withKey:(id)key;

@end
