//
//  HLSpreadLinkAttribute.h
//  Pods
//
//  Created by zhongchao.han on 16/8/29.
//
//

#import <UIKit/UIKit.h>
#import "HLAbstractLinkAttribute.h"

@interface HLSpreadLinkAttribute : HLAbstractLinkAttribute

+ (NSAttributedString *)attributedStringWithTitle:(NSAttributedString *)title originAttrString:(NSAttributedString *)originAttrString;

@property (nonatomic, strong) NSAttributedString *originAttrString;

@end
