//
//  NSString+KSSubstring.h
//  gif
//
//  Created by 张颂 on 2016/11/7.
//  Copyright © 2016年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>
// 截取字符串
@interface NSString (KSSubstring)

- (NSString *)ks_substringToIndex:(NSUInteger)to keepLastCharacter:(BOOL)keep;

/**
 *  将指定 range 的子字符串裁剪出来
 *
 *  @param range 要裁剪的文字位置
 *  @param lessValue 裁剪时若遇到“character sequences”，是向下取整还是向上取整。
 *  @return 裁剪完的字符
 */
- (NSString *)ks_substringWithRange:(NSRange)range lessValue:(BOOL)lessValue;

/**
*  返回 "××××..."样式的字符串，总长度<=constraintWidth, ...是appendString，可以为nil
*  1. 如果本身长度就不足constraintWidth直接返回自身的copy
*  2. 1不成立的情况下如果appendString长度本身超过了constraintWidth，返回@""
*
*  @param constraintWidth 包括...在内的长度限制，最终返回的字符串是不会超过此长度的最长的字符串
*  @param font 按照font计算，
*  @param appendString 字符串尾接上一串（...表示），并算到constraintWidth里，可以不设置
*  @param finalWidth 返回的字符串的宽度
*  @param finalLength 截断后的字符串取了前finalLength的string长度（不包括appendString的长度）
*  @return "××××..."样式的字符串
*/
- (NSString *)ks_substringConstraintToWidth:(CGFloat)constraintWidth
                                       font:(UIFont *)font
                               appendString:(NSString *)appendString
                                 finalWidth:(CGFloat *)finalWidth
                                finalLength:(NSInteger *)finalLength;

@end
