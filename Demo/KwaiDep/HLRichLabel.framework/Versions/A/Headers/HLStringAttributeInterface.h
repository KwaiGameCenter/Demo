//
//  HLStringAttribute.h
//  HLRichLabel
//
//  Created by han_zc on 14-5-15.
//  Copyright (c) 2014年 hanzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class HLRichLabel;

#define kCustomStringAttribute @"stringAttribute"

@protocol HLStringAttributeInterface <NSObject>
@required
// run的Rect
@property (atomic,strong)NSMutableArray *runRect;
@property (nonatomic,assign)BOOL isHightLight;

//  绘制图像
- (void)drawInRect:(CGRect)rect in:(HLRichLabel*)richLabel;

- (void)touchesBegan:(HLRichLabel*)richLabel;
- (void)touchesEnded:(HLRichLabel*)richLabel;

@optional
- (UIEdgeInsets)touchEventEdgeInsets;
    
/**
 是否忽略在这个Attribute上的点击事件，从而让事件在superview上响应(比如评论里面的表情)
 
 @return 是否忽略点击
 */
- (BOOL)shouldIgnoreTouchEvents;

@end
