//
//  UIImage+FilePath.h
//  KwaiDesignTool
//
//  Created by UJOY on 2020/8/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage(Resource)

/// 本地资源icon名称
@property (nonatomic, copy) NSString *resourceName;

@end

@interface UIImageView(Resource)

/// 本地资源icon名称
@property (nonatomic, copy) NSString *resourceName;

@end

NS_ASSUME_NONNULL_END
