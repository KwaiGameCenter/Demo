//
//  KSKeyValues.h
//  gif
//
//  Created by 薛辉 on 3/9/16.
//  Copyright © 2016 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSLock (KSBlock)
- (void)synchronized:(void(^)())block;
@end

@interface KSKeyValues <__covariant KeyType, __covariant ObjectType> : NSObject
- (void)setValue:(ObjectType)value forKey:(KeyType)key;
- (id)valueForKey:(KeyType)key;
- (void)removeAllValues;
@end
