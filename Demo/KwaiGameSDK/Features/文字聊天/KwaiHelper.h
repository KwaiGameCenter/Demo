//
//  KwaiHelper.h
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/12/6.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KwaiEmotion, KwaiIMEmotionMessage, KwaiIMConversation;

@interface KwaiHelper : NSObject

+ (NSString *)timeAgoStringForDate:(NSDate *)date isFromList:(BOOL)isFromList;

+ (void)showInputAlertWithPlaceholder:(NSString *)placeholder text:(NSString *)text handler:(UIViewController *)handlerVC completion:(void (^) (NSString *textString))completion cancelBlock:(void(^)(NSString *textString))cancelBlock;

+ (void)showActionSheetWithTitles:(NSArray<NSString *> *)titles handler:(UIViewController *)handlerVC completion:(void (^) (NSInteger index))completion cancelBlock:(void(^)(void))cancelBlock;

#pragma mark - Convert

+ (KwaiEmotion *)emotionFromMessage:(KwaiIMEmotionMessage *)message;
+ (KwaiIMEmotionMessage *)messageFromEmotion:(KwaiEmotion *)emotion conversation:(KwaiIMConversation *)conversation;

#pragma mark - draw
+ (UIImage *)drawIconSize:(CGSize)size text:(NSString *)text backgroundColor:(UIColor *)col;

#pragma mark - RPC API

+ (void)sendText:(NSString *)text
            from:(long long)fromUid
              to:(long long)toUid
         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end


