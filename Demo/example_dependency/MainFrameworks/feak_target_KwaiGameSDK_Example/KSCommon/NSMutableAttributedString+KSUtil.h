//
//  NSMutableAttributedString+KSUtil.h
//  gif
//
//  Created by 薛辉 on 12/29/15.
//  Copyright © 2015 kuaishou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (KSUtil)

- (void)ks_addShadowColor:(UIColor *)shadowColor offset:(CGSize )offset blurRadius:(CGFloat)blurRadius;
- (void)ks_addShadowColor:(UIColor *)shadowColor offset:(CGSize )offset blurRadius:(CGFloat)blurRadius range:(NSRange)range;

@end
