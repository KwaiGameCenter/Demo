//
//  HLImageAttribute.h
//  gif
//
//  Created by Hale Chan on 16/7/27.
//  Copyright © 2016年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HLStringAttributeInterface.h"

@interface HLImageAttribute : NSObject <HLStringAttributeInterface>

@property (atomic,strong)NSMutableArray *runRect;
@property (nonatomic,assign)BOOL isHightLight;

- (void)drawInRect:(CGRect)rect in:(HLRichLabel*)richLabel;

- (void)touchesBegan:(HLRichLabel*)richLabel;
- (void)touchesEnded:(HLRichLabel*)richLabel;

@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;
@property (nonatomic, strong) UIFont *baseFont;
@property (nonatomic, strong) UIImage *image;

@end
