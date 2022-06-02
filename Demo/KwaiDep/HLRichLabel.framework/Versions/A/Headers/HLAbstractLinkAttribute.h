//
//  HLAbstractLinkAttribute.h
//  Pods
//
//  Created by zhongchao.han on 16/8/29.
//
//

#import <Foundation/Foundation.h>
#import "HLStringAttributeInterface.h"

@interface HLAbstractLinkAttribute : NSObject<HLStringAttributeInterface>

@property (nonatomic,assign) BOOL isHightLight;
@property (atomic,strong) NSMutableArray *runRect;
@property (nonatomic,strong) NSString *urlString;

/**
 * abstract method
 */
- (void)didTapLinkWithLabel:(HLRichLabel *)richLabel url:(NSURL *)url;

@end
