//
//  BlocksKitKVO+KSMacros.h
//  gif
//
//  Created by LiSi on 04/07/2017.
//  Copyright © 2017 kuaishou. All rights reserved.
//

#ifndef BlocksKitKVO_KSMacros_h
#define BlocksKitKVO_KSMacros_h

#import <BlocksKit/BlocksKit.h>
#import <BlocksKit/NSObject+BKBlockObservation.h>
#import <KSCommon/KSObjcExtKeyPathCoding.h>

#define KSObserveInitial(target, SEL, task, ... ) [target bk_addObserverForKeyPath:@keypath(target, SEL) \
    options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld \
                                                                                task];

#define KSObserve(target, SEL, task, ... ) [target bk_addObserverForKeyPath:@keypath(target, SEL) \
                                                                                 options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld \
                                                                                task];


#endif /* BlocksKitKVO_KSMacros_h */
