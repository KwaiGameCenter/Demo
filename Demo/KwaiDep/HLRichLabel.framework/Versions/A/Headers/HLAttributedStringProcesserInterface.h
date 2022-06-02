//
//  HLAttributedStringProcesser.h
//  HLRichLabel
//
//  Created by han_zc on 14-5-15.
//  Copyright (c) 2014年 hanzc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AttributedStringAddtionProcessBlock)(NSMutableAttributedString* attributedString);

/**
 * 根据不同的正则表达式处理NSAttributedString
 * 注：这类的数据处理涉及到数据解析，所以比较耗时，不论是主线程还是非
 * 主线程，都应该针对单个数据处理，不应该做批量数据处理。
 */
@protocol HLAttributedStringProcesserInterface <NSObject>
@required
/**
 * 根据不同的正则表达式配置NSAttributedString
 */
- (void)configAttributedString:(NSMutableAttributedString*)attributedString;
@end
