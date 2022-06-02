//
//  KGDemoUIDefine.h
//  KSAdSDK
//
//  Created by 刘玮 on 2020/5/6.
//

#import <Foundation/Foundation.h>
#import "UIView+DemoSupport.h"

#define DemoUIScreenWidth [UIScreen mainScreen].bounds.size.width
#define DemoUIScreenHeight [UIScreen mainScreen].bounds.size.height

#define DemoRunInMainThreadStart dispatch_async(dispatch_get_main_queue(), ^{
#define DemoRunInMainThreadEnd   });

#define DemoRunInMainThreadAfterBegin(sec) \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{             \

#define DemoRunInMainThreadAfterEnd                                   \
});
