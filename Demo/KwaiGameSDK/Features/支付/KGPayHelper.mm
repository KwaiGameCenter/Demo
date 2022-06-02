//
//  KGPayHelper.m
//  KwaiGameSDK_Example
//
//  Created by 刘玮 on 2019/5/18.
//  Copyright © 2019 mookhf. All rights reserved.
//

#import "KGPayHelper.h"
#import "KwaiBase.h"
#import "NSError+KwaiBase.h"
#import <KwaiGameSDK-Pay/KwaiGamePay+Queue.h>
#import <KwaiGameSDK/KwaiGameSDK.h>
#import <KwaiGameSDK-Oversea/KwaiGameSDK+Oversea.h>
#import <StoreKit/StoreKit.h>
#import "KGRSAWithSha512.h"
#import "KGUtil.h"
#import "XFPreferenceHeader.h"
#import "KGTokenHelper.h"

#define kHumanErrorType @"humanErrorType"

@interface KwaiGameIAPQueue: NSObject

@end

@implementation KwaiGameIAPQueue(Feak)

- (void)finishTransaction:(SKPaymentTransaction *)transaction {
    if ([KGPayHelper help].humanErrorType == KwaiPayHumanErrorType_DelayFinishOrder
        || [KGPayHelper help].humanErrorType == KwaiPayHumanErrorType_LoseExtension) {
        return;
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (NSString *)searchOrderDetail:(SKPaymentTransaction *)transaction {
    if ([KGPayHelper help].humanErrorType == KwaiPayHumanErrorType_DelayFinishOrder) {
        [[UIApplication sharedApplication].keyWindow toast:@"将会正常完成支付(使用历史存储的订单信息完成验证)"];
        return nil;
    }
    if ([KGPayHelper help].humanErrorType == KwaiPayHumanErrorType_DelayFinishOrder) {
        return nil;
    }
    return transaction.payment.applicationUsername;
}

@end

@interface KwaiGameIAP: NSObject

@end

@implementation KwaiGameIAP(Feak)

- (BOOL)checkOrderDetail: (NSString *)orderDetail {
    if ([KGPayHelper help].humanErrorType == KwaiPayHumanErrorType_Loss) {
        exit(-1);
    }
    if ([KGPayHelper help].humanErrorType == KwaiPayHumanErrorType_LoseExtension) {
        return NO;
    }
    return !KWAI_IS_STR_NIL(orderDetail);
}

- (NSError *)feakError: (NSError *)error canCheckDeep: (BOOL)canCheckDeep needCheckRefresh: (BOOL)needCheckRefresh {
    if ([KGPayHelper help].humanErrorType == KwaiPayHumanErrorType_125) {
        if (canCheckDeep) {
            error = [NSError kc_errorWithCode: 125 msg: @"in app in empty"];
        } else {
            if (!needCheckRefresh) {
                error = [NSError kc_errorWithCode: 110 msg: @"generate one error"];
            }
        }
    }
    return error;
}

- (void)testBrokenRequest:(KwaiGamePayment *)payRequest {
    if ([KGPayHelper help].humanErrorType == KwaiPayHumanErrorType_LoseExtension) {    payRequest.extension = nil;
        payRequest.currencyType = nil;
    }
}

@end

@implementation KGProductItem

@end

@interface KGPayHelper()<KwaiGamePayQueueDelegate>

@property (nonatomic, strong) NSArray<KGProductItem *> *allProducts;

@end

@implementation KGPayHelper

SINGLETON_IMPLEMENTS(KGPayHelper, {
    NSMutableArray *products = [NSMutableArray array];
    KGProductItem *item = [[KGProductItem alloc] init];
    item.productId = @"TestGameItem2";
    item.productName = @"一级货币商品";
    item.productValue = 600;
    item.productCurrency = @"CNY";
    item.payMode = KwaiPayMode_GameCoin;
    item.isSubscribe = NO;
    item.isSubGameProduct = YES;
    [products addObject:item];
    
    item = [[KGProductItem alloc] init];
    item.productId = @"TestGameItem3";
    item.productName = @"普通商品";
    item.productValue = 600;
    item.productCurrency = @"CNY";
    item.payMode = KwaiPayMode_Normal;
    item.isSubscribe = NO;
    [products addObject:item];
    
    item = [[KGProductItem alloc] init];
    item.productId = @"test1234";
    item.productName = @"非消耗商品";
    item.productValue = 600;
    item.productCurrency = @"CNY";
    item.payMode = KwaiPayMode_Normal;
    item.isSubscribe = NO;
    [products addObject:item];
    
    item = [[KGProductItem alloc] init];
    item.productId = @"test1234_1";
    item.productName = @"非消耗商品2";
    item.productValue = 600;
    item.productCurrency = @"CNY";
    item.payMode = KwaiPayMode_Normal;
    item.isSubscribe = NO;
    [products addObject:item];

    if ([KwaiGameSDK sharedSDK].currentEnv == KwaiGameEnv_Staging) {
        item = [[KGProductItem alloc] init];
        item.productId = @"OneWeekForStaging";
        item.productName = @"StagingEnv周礼包";
        item.productValue = 100;
        item.productCurrency = @"CNY";
        item.payMode = KwaiPayMode_Normal;
        item.isSubscribe = YES;
        item.subscribeFirstPrice = 0;
        item.subscribePrice = 100;
        item.subscribeDays = 7;
        [products addObject:item];
    } else {
        if ([KwaiGameSDK sharedSDK].isOversea) {
            item = [[KGProductItem alloc] init];
            item.productId = @"OneWeekForOversea";
            item.productName = @"OverseaEnv周礼包";
            item.productValue = 100;
            item.productCurrency = @"CNY";
            item.payMode = KwaiPayMode_Normal;
            item.isSubscribe = YES;
            item.subscribeFirstPrice = 0;
            item.subscribePrice = 100;
            item.subscribeDays = 7;
            [products addObject:item];
        } else {
            item = [[KGProductItem alloc] init];
            item.productId = @"OneWeekForRelease";
            item.productName = @"ReleaseEnv周礼包";
            item.productValue = 100;
            item.productCurrency = @"CNY";
            item.payMode = KwaiPayMode_Normal;
            item.isSubscribe = YES;
            item.subscribeFirstPrice = 0;
            item.subscribePrice = 100;
            item.subscribeDays = 7;
            [products addObject:item];
        }
    }

    self.allProducts = products;
    
    _humanErrorType = (KwaiPayHumanErrorType) [XFPreferenceUtil getGlobalIntegerKey: kHumanErrorType];
});

+ (instancetype)help {
    return [KGPayHelper sharedInstance];
}

- (void)setup {
    [[KwaiGamePay pay] setupWithDelegate: self];
}

- (void)setHumanErrorType: (KwaiPayHumanErrorType)humanErrorType {
    _humanErrorType = humanErrorType;
    if (_humanErrorType != KwaiPayHumanErrorType_Loss) {
        [XFPreferenceUtil setGlobalIntegerKey: kHumanErrorType value: humanErrorType syncWrite: YES];
    }
}

- (NSArray<KGProductItem *> *)fetchProductList: (void (^)(NSError *error, NSArray<KGProductItem *> *products))complete {
    return [NSArray arrayWithArray:self.allProducts];
}

- (void)querySubscribe: (void (^)(NSError *error, NSDictionary *params))completion {
    [KGTokenHelper querySubscribe:[KwaiGameSDK sharedSDK].appId
                           gameId:[KwaiGameSDK sharedSDK].account.uid
                        gameToken:[KwaiGameSDK sharedSDK].account.serviceToken
                         serverId:@"127.0.0.1"
                           roleId:[KGUtil util].uid
                       completion:^(NSError *error, NSDictionary *params) {
        if (completion) {
            completion(error, params);
        }
    }];
}

- (void)cancelSubscribe {
    [KGTokenHelper cancelSubscribe];
}

#pragma mark - KwaiGamePayQueueDelegate

- (void)extendRequestPaymentDetail: (KwaiGamePayment *)payment taskId: (NSString *)taskId {
    // 实际接入时，这里需要请求业务服务器并获取商品订单信息
    [[UIApplication sharedApplication].keyWindow toast:[NSString stringWithFormat: @"同游戏服务请求订单信息:\n%@", [payment toDictionary]]];
    KwaiGamePayParams *params = [self gamePayParams: payment];
    NSError *error;
    if (params == nil) {
        error = [NSError kc_errorWithCode: 101 msg: @"没有此产品"];
    }
    [[KwaiGamePay pay] responsePaymentDetail: taskId error: error params: params];
}

- (KwaiGamePayParams *)gamePayParams: (KwaiGamePayment *)payment {
    NSArray *allProductIdArray = [self.allProducts valueForKey:@"productId"];
    NSInteger index = [allProductIdArray indexOfObject:payment.productId];
    KGProductItem *product = nil;
    if (index != NSNotFound) {
        product = self.allProducts[index];
    }
    if (product == nil) {
        return nil;
    }
    KwaiGamePayParams *params = [[KwaiGamePayParams alloc] init];
    params.appId = [KwaiGameSDK sharedSDK].appId;
    params.gameId = [KwaiGameSDK sharedSDK].account.uid;
    params.gameToken = [KwaiGameSDK sharedSDK].account.serviceToken;
    params.channelId = @"ks";
    params.roleId = [KGUtil util].uid;
    params.roleName = [KGUtil util].uid;
    params.roleLevel = @"1";
    params.serverId = @"127.0.0.1";
    params.serverName = @"国服1区";
    params.productId = product.productId;
    params.productName = product.productName;
    params.productDesc = product.productName;
    // 处理极异常case，对应补单时候缺失有效的payment信息
    params.money = payment.monery > 0 ? payment.monery : product.productValue;
    params.currencyType = payment.currencyType.length > 0 ? payment.currencyType : product.productCurrency;
    if (product.isSubscribe) {
        NSDictionary *subscribeInfo = @{
            @"ks_order_type": @"subscribe",
            @"ks_subscribe_product_info": @{
                @"product_id": product.productId,
                @"product_name": product.productName,
                @"first_price": @(product.subscribeFirstPrice),
                @"price": @(product.subscribePrice),
                @"days": @(product.subscribeDays),
                @"notify_url": @"https://c.kuaishoupay.com/rest/n/pay/notify/allin"
            },
        };
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subscribeInfo options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        params.extension = jsonString;
    } else if (product.isSubGameProduct) {
        NSDictionary *extension = @{@"game_origin": @"allin_demo"};
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:extension options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        params.extension = jsonString;
    }
    if ([KGPayHelper help].humanErrorType == KwaiPayHumanErrorType_MissCallback) {
        params.notifyUrl = @"http://xxxxx.com";
    } else {
        params.notifyUrl = @"https://c.kuaishoupay.com/rest/n/pay/notify/allin";
    }
    params.userIp = @"0.0.0.0";
    params.thirdPartyTradeNo = [NSString stringWithFormat: @"%lld", (long long)([[NSDate date] timeIntervalSince1970] * 1000)];
    params.sign = [self sign: params];
    // 制造错误数据
    if (self.humanErrorType == KwaiPayHumanErrorType_Wrong) {
        params.money = 1;
    }
    return params;
}

- (NSString *)sign: (KwaiGamePayParams *)params {
    NSString *privateKey = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"app_private_key" ofType: @"pem"]
                                                     encoding: NSUTF8StringEncoding
                                                        error: nil];
    NSDictionary *dict = [params toDictionary];
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *key in dict.allKeys) {
        if (![key isEqualToString: @"gameToken"] && ![key isEqualToString: @"sign"]) {
            [valueArray addObject: [NSString stringWithFormat: @"%@=%@", [self translateToInsertName: key], dict[key]]];
        }
    }
    NSArray *sortArray = [valueArray sortedArrayUsingComparator: ^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *value1 = ( NSString *)obj1;
        NSString *value2 = ( NSString *)obj2;
        return [value1 compare: value2];
    }];
    NSString *strValue = [sortArray componentsJoinedByString: @"&"];
    return [KGRSAWithSha512 encryptString: strValue privateKey: privateKey];
}

- (NSString *)translateToInsertName: (NSString *)name {
    NSMutableString *appendName = [NSMutableString stringWithCapacity: name.length];
    
    for(int i = 0; i < name.length; i++)
    {
        char c = [name characterAtIndex: i];
        if(c > 64 && c < 91)
        {
            [appendName appendString: [NSString stringWithFormat: @"_%@", [[NSString stringWithFormat: @"%c",c] lowercaseString]]];
        } else {
            [appendName appendString: [NSString stringWithFormat: @"%c", c]];
        }
    }
    return appendName;
}


@end

