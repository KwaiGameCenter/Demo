//
//  AVAudioSessionRouteDescription+KSUtil.h
//  gif
//
//  Created by 薛辉 on 5/23/16.
//  Copyright © 2016 kuaishou. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAudioSessionRouteDescription (KSUtil)
- (BOOL)ks_hasHeadset;
- (BOOL)ks_hasHeadsetExcludeBluetooth;
- (BOOL)ks_hasBluetoothHeadset;
@end
