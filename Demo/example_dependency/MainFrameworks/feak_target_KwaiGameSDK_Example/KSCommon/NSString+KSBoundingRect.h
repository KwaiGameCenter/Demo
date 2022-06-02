//
//  NSString+KSBoundingRect.h
//  gif
//
//  Created by LiSi on 7/4/16.
//  Copyright © 2016 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

// 根据条件(字体,最大尺寸,换行方式等)来返回对应文字的size
@interface NSString (KSBoundingRect)

- (CGSize)ks_sizeWithFont:(UIFont *)font;

- (CGSize)ks_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

- (CGSize)ks_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)ks_sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end
