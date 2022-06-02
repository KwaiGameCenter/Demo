//
//  HLEmojiAttributeProcesser.h
//  QWeiboSDK4iOSDemo
//
//  Created by zhongchao.han on 14-9-21.
//
//

#import <Foundation/Foundation.h>
#import "HLAttributedStringProcesserInterface.h"

@interface HLEmojiAttributeProcesser : NSObject<HLAttributedStringProcesserInterface>
+(instancetype) sharedProcesser;
@end
