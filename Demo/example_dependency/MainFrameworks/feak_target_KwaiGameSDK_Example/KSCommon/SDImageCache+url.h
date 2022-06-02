//
//  SDImageCache+url.h
//  Kwai
//
//  Created by zhongchao.han on 14-9-11.
//
//

#import <SDWebImage/SDImageCache.h>

@interface SDImageCache (url)

/**
 * 通过url从SDImageCache中获取图片。
 */
- (UIImage*)imageFromCacheForURL:(NSString *)imageUrl;

@end
