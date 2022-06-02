//
//  HLURLAttributedStringProcesser.h
//  HLRichLabel
//
//  Created by han_zc on 14-5-16.
//  Copyright (c) 2014年 hanzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLAttributedStringProcesserInterface.h"

@interface HLURLAttributedStringProcesser : NSObject<HLAttributedStringProcesserInterface>

+ (instancetype)sharedHLURLAttributedStringProcesser;

@property (nonatomic, strong) UIColor *linkTextColor;
@property (nonatomic,copy) AttributedStringAddtionProcessBlock addtionProcessBlock;

@end
