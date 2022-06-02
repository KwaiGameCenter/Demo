//
//  KwaiGameSDK+Demo.h
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2019/1/9.
//  Copyright © 2019 mookhf. All rights reserved.
//

#import <KwaiGameSDK/KwaiGameSDK.h>

@interface KwaiGameSDK (Demo)

- (void)clearOnlineStatus;

- (BOOL)antiAddictEnable;

- (void)uploadFile:(NSString *)filePath
          progress:(void (^)(CGFloat percent))progress
        completion:(void (^)(NSError *, NSString *))completion;

- (void)uploadImage:(UIImage *)image
           progress:(void (^)(CGFloat percent))progress
         completion:(void (^)(NSError *, NSString *))completion;

- (void)downloadFile:(NSString *)url
              toPath:(NSString *)filePath
            progress:(void (^)(CGFloat percent))progress
          completion:(void (^)(NSError *))completion;

- (NSString *)zipFeedback;

@end

