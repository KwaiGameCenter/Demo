//
//  KBDeviceData.h
//  Pods
//
//  Created by 刘玮 on 2017/3/30.
//
//

#import <Foundation/Foundation.h>

typedef enum
{
    KBLanguageType_ChineseSimplified = 1,
    KBLanguageType_ChineseTraditional = 2,
    KBLanguageType_English = 3,
    KBLanguageType_Unkown = 4,
} KBLanguageType;

@interface KBDeviceData : NSObject

+ (KBLanguageType)laType;

@end
