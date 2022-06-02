//
//  KGVideoInfo.h
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2020/3/6.
//  Copyright © 2020 mookhf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGVideoInfo : NSObject
@property (nonatomic, copy) NSString *photoId;
@property (nonatomic, copy) NSString *coverUrl;
@property (nonatomic, assign) int status;   // 0:未同步 1:同步中 2:已同步
@property (nonatomic, assign) long seqNum;
@end

