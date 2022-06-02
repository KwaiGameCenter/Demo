//
//  NSAttributedString+KSSubstring.h
//  BlocksKit
//
//  Created by tanbing on 2018/1/3.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (KSSubstring)

- (NSAttributedString *)ks_attributedSubstringFromRange:(NSRange)range;

@end
