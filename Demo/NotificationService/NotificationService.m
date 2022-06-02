//
//  NotificationService.m
//  NotificationService
//
//  Created by 邓波 on 2018/10/12.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "NotificationService.h"
#import <KwaiGameSDK-PushReport/KwaiGamePushReport.h>
#import <KwaiGameSDK-PushReport/KGResourceUtil.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    // 处理带附件的推送
    [KGResourceUtil handleNotificationContent:[self.bestAttemptContent mutableCopy] withHandler:contentHandler];
    // push 到达打点
    [[[KwaiGamePushReport alloc] init] reportPushArrivedEventWithUserInfo:request.content.userInfo];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
