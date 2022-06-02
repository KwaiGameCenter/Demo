//
//  UIImage+LiveWebP.h
//  gifLiveBaseModule
//
//  Created by chenxiao on 2019/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (LiveWebP)
+ (UIImage *)liveWebpImageWithBundle:(NSBundle *)bundle imageName:(NSString *)name inDirectory:(nullable NSString *)directory;

@end

NS_ASSUME_NONNULL_END
