//
//  KSCoreTextUtils.h
//  gif
//
//  Created by coderlih on 2018/3/16.
//  Copyright © 2018年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSCoreTextUtils : NSObject

+ (NSUInteger)linesForText:(NSAttributedString *)content withWidth:(CGFloat)width;

+ (NSString *)subStringForText:(NSAttributedString *)content
              withinLinesCount:(NSUInteger)lineCount
                     withWidth:(CGFloat)width;

+ (NSString *)subStringForText:(NSAttributedString *)content
                    appendText:(NSAttributedString *)appendText
              withinLinesCount:(NSUInteger)lineCount
                    totalWidth:(CGFloat)width;

+ (NSAttributedString *)foldAttrStringForText:(NSString *)content
                                     foldText:(NSString *)foldText
                             normalAttributes:(nullable NSDictionary<NSAttributedStringKey, id> *)normalAttributes
                               foldAttributes:(nullable NSDictionary<NSAttributedStringKey, id> *)foldAttributes
                             withinLinesCount:(NSUInteger)lineCount
                                   totalWidth:(CGFloat)width;
@end
