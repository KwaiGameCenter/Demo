//
//  KGTokenHelper.h
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/12/6.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KwaiGameLiveListResolutionURL : NSObject
@property (nonatomic, strong) NSString *resolution;
@property (nonatomic, strong) NSString *playUrl;
@end

@interface KwaiGameLiveListItem : NSObject
@property (nonatomic, strong) NSString *liveStreamId;
@property (nonatomic, strong) NSString *anchorId;
@property (nonatomic, strong) NSString *playUrl;
@property (nonatomic, strong) NSString *anchorGameId;
@property (nonatomic, strong) NSArray<KwaiGameLiveListResolutionURL *> *multiPlayUrls;
@end


@interface KGTokenHelper : NSObject


+ (void)requestAccessToken:(void (^)(NSError *error, NSString *accessToken))completion;

+ (void)requestIMToken:(NSString *)accessToken uid:(NSString *)uid completion:(void (^)(NSError *error,  NSString *token))completion;

+ (void)requestRoomId:(NSString *)accessToken completion:(void (^)(NSError *error,  NSString *roomId))completion;

+ (void)requestWWPAccessToken:(void (^)(NSError *error, NSString *accessToken))completion;

+ (void)requestWWPList:(void (^)(NSError *error, NSArray<KwaiGameLiveListItem *> *liveList))completion;

+ (void)sendGiftWithId:(NSUInteger)gid senderId:(NSString *)senderId anchorId:(NSString *)anchorId liveStreamId:(NSString *)liveId accessToken:(NSString *)token batchSize:(NSUInteger)batchSize comboKey:(NSString *)comboKey;

+ (void)vertifyCDKey:(NSDictionary *)cdkey completion:(void (^)(NSError *error, NSDictionary *result))completion;

+ (void)requestFollowingRelation:(NSString *)appId
                          gameId:(NSString *)gameId
                       gameToken:(NSString *)gameToken
                      completion:(void (^)(NSError *error,  NSDictionary *dictionary))completion;

+ (void)requestKsPhotos:(NSString *)appId
                 gameId:(NSString *)gameId
              gameToken:(NSString *)gameToken
                 seqNum:(long)seqNum
             completion:(void (^)(NSError *error,  NSDictionary *dictionary))completion;

+ (void)syncKsPhotos:(NSArray *)photos
              gameId:(NSString *)gameId
           gameToken:(NSString *)gameToken
               appId:(NSString *)appId
          completion:(void (^)(NSError *error))completion;

+ (void)fetchPhotosCount:(NSString *)appId
                  gameId:(NSString *)gameId
               gameToken:(NSString *)gameToken
              completion:(void (^)(NSError *error,  NSDictionary *dictionary))completion;

+ (void)querySubscribe:(NSString *)appId
                gameId:(NSString *)gameId
             gameToken:(NSString *)gameToken
              serverId:(NSString *)serverId
                roleId:(NSString *)roleId
            completion:(void (^)(NSError *error, NSDictionary *params))completion;

+ (void)cancelSubscribe;

@end

