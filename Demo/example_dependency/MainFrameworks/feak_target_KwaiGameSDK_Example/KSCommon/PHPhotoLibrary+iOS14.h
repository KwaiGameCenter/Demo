//
//  PHPhotoLibrary+iOS14.h
//  KSAssetPicker
//
//  Created by lilu07 on 2020/8/13.
//

#import <Photos/Photos.h>

/// 没有全面升级xcode12，兼容Xcode11编译

static const NSInteger kPHAuthorizationStatusLimited = 4;

API_AVAILABLE_BEGIN(ios(14))

@interface PHPhotoLibrary (iOS14)

+ (PHAuthorizationStatus)ks_authorizationStatusForAccessLevelReadWrite;

+ (PHAuthorizationStatus)ks_authorizationStatusForAccessLevel:(NSInteger)accessLevel;

- (void)ks_presentLimitedLibraryPickerFromViewController:(UIViewController *)controller;

@end

API_AVAILABLE_END
