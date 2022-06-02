//
//  KSJSONUtil.h
//  gif
//
//  Created by 薛辉 on 7/27/16.
//  Copyright © 2016 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KSCommon/KSCommonLogLevel.h>

@interface NSObject (KSJSONUtil)
- (instancetype)ks_validJsonObject;
@end

@interface NSNumber (KSJSONUtil)
- (instancetype)ks_validJsonObject;
@end

@interface NSString (KSJSONUtil)
- (instancetype)ks_validJsonObject;
@end

@interface NSDictionary (KSJSONUtil)
- (instancetype)ks_validJsonObject;
@end

@interface NSArray (KSJSONUtil)
- (instancetype)ks_validJsonObject;
@end
