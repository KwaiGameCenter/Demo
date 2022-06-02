//
//  KSAVAudioSessionSetting.h
//  gif
//
//  Created by bjzhao on 2/7/17.
//  Copyright © 2017 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface KSAVAudioSessionSetting : NSObject

+ (instancetype)sharedInstance;

// return: index
- (NSInteger)setCategory:(NSString *)category error:(NSError *__autoreleasing *)outError;
- (NSInteger)setCategory:(NSString *)category error:(NSError *__autoreleasing *)outError dryRun:(BOOL)dryRun;

- (NSInteger)setCategory:(NSString *)category withOptions:(AVAudioSessionCategoryOptions)options error:(NSError *__autoreleasing *)outError NS_AVAILABLE_IOS(6_0);
- (NSInteger)setCategory:(NSString *)category withOptions:(AVAudioSessionCategoryOptions)options error:(NSError *__autoreleasing *)outError dryRun:(BOOL)dryRun NS_AVAILABLE_IOS(6_0);

- (NSInteger)setMode:(NSString *)mode error:(NSError *__autoreleasing *)outError NS_AVAILABLE_IOS(5_0);
- (NSInteger)setMode:(NSString *)mode error:(NSError *__autoreleasing *)outError dryRun:(BOOL)dryRun NS_AVAILABLE_IOS(5_0);

- (NSInteger)setPreferredSampleRate:(double)sampleRate error:(NSError *__autoreleasing *)outError NS_AVAILABLE_IOS(6_0) __WATCHOS_PROHIBITED;
- (NSInteger)setPreferredSampleRate:(double)sampleRate error:(NSError *__autoreleasing *)outError dryRun:(BOOL)dryRun NS_AVAILABLE_IOS(6_0) __WATCHOS_PROHIBITED;

- (void)restoreCategoryWithIndex:(NSInteger)index error:(NSError *__autoreleasing *)outError;
- (void)restoreModeWithIndex:(NSInteger)index error:(NSError *__autoreleasing *)outError;
- (void)restoreSampleRateWithIndex:(NSInteger)index error:(NSError *__autoreleasing *)outError;

- (void)setPreferredIOBufferDuration:(NSTimeInterval)duration error:(NSError *__autoreleasing *)outError __WATCHOS_PROHIBITED;
- (BOOL)usbAudioDevicePluggedIn;

@end
