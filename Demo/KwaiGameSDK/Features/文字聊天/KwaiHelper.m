//
//  KwaiHelper.m
//  KwaiIMSDK_Example
//
//  Created by sunyang on 2018/11/13.
//  Copyright © 2018 Rui YOU. All rights reserved.
//

#import "KwaiHelper.h"
#import <KwaiGameSDK-IM/KwaiIMEmotionMessage.h>
#import <KwaiGameSDK-IM/KwaiIMConversation.h>
#import "NSMutableDictionary+safe.h"
#import "KwaiNetworking.h"

static NSString * const kKwaiRPCHost = @"http://middle-test.corp.kuaishou.com";
static NSString * const kKwaiRPCSendMessage = @"api/v1/sendMessage";

@implementation KwaiHelper

+ (NSString *)timeAgoStringForDate:(NSDate *)date isFromList:(BOOL)isFromList
{
    NSDateComponents *dayComponents = [self dateComponentsFromDate:date];
    NSInteger intDay = [dayComponents day];
    NSInteger intMonth = [dayComponents month];
    NSInteger intYear = [dayComponents year];
    NSInteger intHour = [dayComponents hour];
    
    NSDate *crrentDate = [NSDate date];
    NSDateComponents *nowComponents = [self dateComponentsFromDate:crrentDate];
    
    NSInteger intCurrentDay = [nowComponents day];
    NSInteger intCurrentMonth = [nowComponents month];
    NSInteger intCurrentYear = [nowComponents year];
    
    NSString *nsFullTime;
    NSString *nsDay;
    NSString *nsTime;
    
    NSInteger nDayInterval = intCurrentDay - intDay;
    NSInteger nMonthInterval = intCurrentMonth - intMonth;
    NSInteger nYearInterval = intCurrentYear - intYear;
    
    {
        if (nYearInterval >= 1 || nMonthInterval >= 1 || nDayInterval >= 7) {
            nsDay = [[self class] dateYMDFormat:date];
        } else if (nDayInterval == 0) {
            NSInteger intMinute = [dayComponents minute];
            
            NSInteger intCurrentHour = [nowComponents hour];
            NSInteger intCurrentMinute = [nowComponents minute];
            
            NSInteger nHourInterVal = intCurrentHour - intHour;
            NSInteger nMinInterVal = intCurrentMinute - intMinute;
            if (nHourInterVal < 1 && nHourInterVal >= 0) {
                if (nMinInterVal >= 0 && nMinInterVal < 1) {
                    nsDay = @"刚刚";
                } else {
                    nsDay = [NSString stringWithFormat:@"%@分钟前", [@(nMinInterVal) stringValue]];
                }
            } else {
                nsDay = @"";
            }
        } else if (nDayInterval == 1) {
            //yesterday
            nsDay = @"昨天";
        } else if (nDayInterval <= 6 && nDayInterval > 1) {
            nsDay = [NSString stringWithFormat:@"%@天前", [@(nDayInterval) stringValue]];
        } else {
            //年月日
            nsDay = [self dateYMDFormat:date];
        }
    }
    
    nsTime = [self timeFormat:date];
    
    if (nsDay != nil && [nsDay length] > 0) {
        if (isFromList) {
            nsFullTime = nsDay;
        }else {
            nsFullTime = [NSString stringWithFormat:@"%@ %@",nsDay,nsTime];
        }
    } else {
        nsFullTime = [NSString stringWithFormat:@"%@", nsTime];
    }
    
    return [self timeAgoAdjustDateString:nsFullTime inHour:intHour];
}

+ (NSString *)timeAgoAdjustDateString:(NSString *)oldTimeString inHour:(NSInteger)hour
{
    if([oldTimeString rangeOfString:@"上午"].location != NSNotFound)
    {
        if (0 <= hour && hour <= 5) {
            NSString *newTimeString = [oldTimeString stringByReplacingOccurrencesOfString:@"上午" withString:[NSString stringWithFormat:@"%@ ", @"凌晨"]];
            
            if(hour == 0){
                newTimeString = [newTimeString stringByReplacingOccurrencesOfString:@"12:" withString:@"0:"];
            }
            
            return newTimeString;
            
        } else {
            return [oldTimeString stringByReplacingOccurrencesOfString:@"上午" withString:[NSString stringWithFormat:@"%@ ", @"上午"]];
        }
    }
    
    if ([oldTimeString rangeOfString:@"下午"].location != NSNotFound) {
        return [oldTimeString stringByReplacingOccurrencesOfString:@"下午" withString:[NSString stringWithFormat:@"%@ ", @"下午"]];
    }
    
    return oldTimeString;
}

+ (NSString *)dateYMDFormat:(NSDate *)date {
    static dispatch_once_t onceToken;
    static NSDateFormatter* formatter = nil;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd"];
    });
    
    return [formatter stringFromDate:date];
}

+ (NSString*)timeFormat:(NSDate*)date {
    static dispatch_once_t onceToken;
    static NSDateFormatter* formatter = nil;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateStyle:NSDateFormatterNoStyle];
    });
    
    return [formatter stringFromDate:date];
}

+ (NSDateComponents *)dateComponentsFromDate:(NSDate *)date {
    static NSCalendar *gregorian = nil;
    if (!gregorian) {
        gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    NSDateComponents *dayComponents =
    [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday) fromDate:date];
    return dayComponents;
}

+ (void)showInputAlertWithPlaceholder:(NSString *)placeholder text:(NSString *)text handler:(UIViewController *)handlerVC completion:(void (^) (NSString *textString))completion cancelBlock:(void(^)(NSString *textString))cancelBlock {
    UIAlertController *alController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder;
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        textField.text = text;
    }];
    [alController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alController.textFields.firstObject;
        if (completion) {
            completion(textField.text);
        }
        
    }]];
    [alController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alController.textFields.firstObject;
        if (cancelBlock) {
            cancelBlock(textField.text);
        }
    }]];
    [handlerVC presentViewController:alController animated:true completion:nil];
}

+ (void)showActionSheetWithTitles:(NSArray<NSString *> *)titles handler:(UIViewController *)handlerVC completion:(void (^) (NSInteger index))completion cancelBlock:(void(^)(void))cancelBlock {
    UIAlertController *alController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelBlock) {
            cancelBlock();
        }
    }]];
    for (NSString *title in titles) {
        [alController addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (completion) {
                completion([titles indexOfObject:title]);
            }
        }]];
    }
    [handlerVC presentViewController:alController animated:true completion:nil];
}

#pragma mark - RPC API

+ (NSString *)sendMessageURL {
    return [kKwaiRPCHost stringByAppendingPathComponent:kKwaiRPCSendMessage];
}

+ (void)GET:(NSString *)url parameters:(NSDictionary *)parameters success:(nullable void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(nullable void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    [KwaiHTTPSessionManager.manager GET:url parameters:parameters success:success failure:failure];
}

+ (void)sendText:(NSString *)text
            from:(long long)fromUid
              to:(long long)toUid
         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSDictionary *params = @{
                             @"fromUid": @(fromUid),
                             @"toUid": @(toUid),
                             @"type": @(0),
                             @"text": text
                             };
    [self GET:[self sendMessageURL] parameters:params success:success failure:failure];
    
}

@end
