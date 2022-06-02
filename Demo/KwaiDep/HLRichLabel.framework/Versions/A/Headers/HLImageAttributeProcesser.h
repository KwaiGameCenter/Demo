//
//  HLImageAttributeProcesser.h
//  gif
//
//  Created by Hale Chan on 16/7/27.
//  Copyright © 2016年 kuaishou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLImageAttributeProcesser : NSObject

+ (void)addImagePrefix:(UIImage *)image rightPadding:(CGFloat)padding toAttributedString:(NSMutableAttributedString *)attributedString baseFont:(UIFont *)font;

@end
