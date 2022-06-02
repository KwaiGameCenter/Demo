//
//  KGPayHelper.h
//  KwaiGameSDK_Example
//
//  Created by 刘玮 on 2019/5/18.
//  Copyright © 2019 mookhf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KwaiPayMode) {
    KwaiPayMode_Normal          = 0,
    KwaiPayMode_GameCoin        = 1,    // 游戏币或者道具
};

@interface KGProductItem: NSObject

@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, assign) int productValue;
@property (nonatomic, copy) NSString *productCurrency;
@property (nonatomic, assign) KwaiPayMode payMode;
@property (nonatomic, assign) BOOL isSubscribe;
@property (nonatomic, assign) int subscribeFirstPrice;
@property (nonatomic, assign) int subscribePrice;
@property (nonatomic, assign) int subscribeDays;
@property (nonatomic, assign) BOOL isSubGameProduct;

@end

typedef NS_ENUM(NSInteger, KwaiPayHumanErrorType) {
    KwaiPayHumanErrorType_Normal,
    KwaiPayHumanErrorType_Loss,
    KwaiPayHumanErrorType_Wrong,
    KwaiPayHumanErrorType_MissCallback,
    KwaiPayHumanErrorType_125,
    KwaiPayHumanErrorType_DelayFinishOrder,
    KwaiPayHumanErrorType_LoseExtension
};

@interface KGPayHelper : NSObject

@property (nonatomic, assign) KwaiPayHumanErrorType humanErrorType;

+ (instancetype)help;

- (void)setup;  // call when login success!

- (NSArray<KGProductItem *> *)fetchProductList: (void (^)(NSError *error, NSArray<KGProductItem *> *products))complete;

- (void)querySubscribe: (void (^)(NSError *error, NSDictionary *params))completion;

- (void)cancelSubscribe;

@end

NS_ASSUME_NONNULL_END
