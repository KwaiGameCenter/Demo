//
//  UIImage+KSHighlight.h
//  gif
//
//  Created by 薛辉 on 3/17/16.
//  Copyright © 2016 kuaishou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (KSHighlight)
- (void)ks_customHighlightImageWithScale:(CGFloat)scale completion:(void(^)(UIImage *highlightImage, NSError *error))completion;
@end
