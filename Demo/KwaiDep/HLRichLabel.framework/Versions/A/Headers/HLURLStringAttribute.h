//
//  HLURLStringAttribute.h
//  HLRichLabel
//
//  Created by han_zc on 14-5-16.
//  Copyright (c) 2014年 hanzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLStringAttributeInterface.h"

#define kKSDidTapURLNotification @"kKSDidTapURLNotification-2015-5-20"
// url 的string形式的key
#define kKSDidTapURLKey @"kKSDidTapURLKey-2015-5-20"

@interface HLURLStringAttribute : NSObject<HLStringAttributeInterface>

@property (atomic,strong)NSMutableArray *runRect;
@property (nonatomic,strong) NSString *urlString;
@property (nonatomic,assign) BOOL isHightLight;

@end
