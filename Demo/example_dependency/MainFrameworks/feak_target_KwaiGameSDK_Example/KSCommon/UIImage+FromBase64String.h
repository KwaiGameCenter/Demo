//
//  UIImage+FromBase64String.h
//  KSCommon
//
//  Created by Chang Jing on 2020/4/13.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (FromBase64String)

+ (UIImage *)imageFromBase64String:(NSString *)base64String;

@end

NS_ASSUME_NONNULL_END
