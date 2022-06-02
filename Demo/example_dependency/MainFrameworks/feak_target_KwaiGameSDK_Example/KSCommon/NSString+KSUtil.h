//
//  NSString+KSUtil.h
//  gif
//
//  Created by tanbing on 2017/2/22.
//  Copyright © 2017年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KSUtil)
- (NSString *)ks_stringByTrimmingWhitespace;
- (BOOL)ks_isNotNullAndEmpty;

/**
 是否超出一定展示宽度，一个中文字符占用2个单位，一个emoji占用2个单位，其它字符占用一个单位

 @return 是否超出一定展示宽度
 */
- (BOOL)ks_hasLongerDisplayUnitsThan:(NSInteger)count;

- (NSString *)ks_substringToDisplayUnitIndex:(NSInteger)index;

// 返回截断的位置
- (NSInteger)ks_subLocationToDisplayUnitIndex:(NSInteger)index;

- (BOOL)ks_containCJKOrEmoji;

- (BOOL)ks_containEmoji;

- (NSString *)substringFromTextCheckingResult:(NSTextCheckingResult *)result atCapturedGroupIndex:(NSUInteger)index;


/**
 格式化电话号码,部分字符用*替换

 @return 格式化后的电话号码
 */
- (NSString *)ks_secretPhone;

// 截断字符串，保留尾部完整的快手基础表情
- (NSString *)ks_trimmingBasicEmotionUnitIndex:(NSInteger)index;

- (NSString *)ks_removeSpaceAndEnter;

/// 全角转半角
- (NSString *)ks_transformFullwidthWithHalfwidth;

/// 使用 NSURLComponents 实现的参数拼接方法 （会默认进行 decode 操作，慎用）
- (NSString *)urlStringAddParameterString:(NSString *)parameter;

/// 使用字符检索方式实现的 url 参数拼接方法
- (NSString *)decodingURLStringAddParameterString:(NSString *)parameterString;

/// url拼接，为url追加params参数
/// @param paramsStr 形如  "A=a&B=b"
- (NSString *)urlStrWithAdParamsStr:(NSString *)paramsStr;

- (NSUInteger)ks_charLength;

- (NSString *)ks_subCharToIndex:(NSUInteger)to;

@end

@interface NSString (KSTags)

/// Return all tag's names in string
- (NSArray<NSString *> *)ks_tags;

/// Remove all tags and return a pure string
- (NSString *)ks_stringByRemoveAllTags;

@end

/**
 *  `hashtag` 就是我们在微博或朋友圈等发送文本信息时附加的带有 `#` 开头标记的词汇
 *
 *  这家餐厅味道太赞了！ #打卡 #美食
 *
 *  #打卡 #美食 即为hashtag
 */
@interface NSString (KSHashtag)

/**
 *  返回不带#号的纯文字hashtag
 */
- (NSArray<NSString *> *)ks_hashtags;

/**
 *  移除所有hashtag并删除空格
 */
- (NSString *)ks_stringByRemoveAllHashtags;

@end
