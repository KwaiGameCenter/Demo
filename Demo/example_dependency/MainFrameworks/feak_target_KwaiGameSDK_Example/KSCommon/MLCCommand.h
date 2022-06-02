//
//  MLCCommand.h
//  DevelopTools
//
//  Created by 刘玮 on 2016/12/6.
//  Copyright © 2016年 Kuaishou. All rights reserved.
//

#ifndef MLCOther_h
#define MLCOther_h

#import "MLCEventsQueueHandler.h"
#import "MLCUniqueEventHandlerHelper.h"
#import "NSObject+KCCoding.h"
#import <objc/runtime.h>

#if DEBUG
#define KEYWORDIFY autoreleasepool {}
#else
#define KEYWORDIFY try {} @catch (...) {}
#endif

#define SINGLETON_INTERFACE(className)                              \
                                                                    \
+ (className *)sharedInstance;                                      \


#define SINGLETON_IMPLEMENTS(className, initBlock)                  \
                                                                    \
+ (className *)sharedInstance {                                     \
                                                                    \
    static className *singleton;                                    \
    static dispatch_once_t token;                                   \
    dispatch_once(&token, ^{                                        \
        singleton = [[className alloc] initSingleton];              \
    });                                                             \
    return singleton;                                               \
}                                                                   \
                                                                    \
- (id) initSingleton {                                              \
                                                                    \
    self = [super init];                                            \
    if(self) {                                                      \
        initBlock                                                   \
    }                                                               \
    return self;                                                    \
}                                                                   \
                                                                    \
- (id) init {                                                       \
    return [className sharedInstance];                              \
}                                                                   \

#define BUILD_IN_SINGLETON_THREAD_INTERFACE(className)                 \
    @interface className (CLS_EVENT_QUEUE)                             \
        + (id<MLCEventQueueInterface>) getEventQueue;                  \
        + (void)changePriority: (int)priority;                         \
    @end                                                               \

#define BUILD_SINGLETON_THREAD_IMPLEMENTS(className, HandlerId)                                                                            \
static const NSString *handlerId = HandlerId;                                                                                              \
                                                                                                                                           \
@implementation className (CLS_EVENT_QUEUE)                                                                                                             \
                                                                                                                                                        \
    + (id<MLCEventQueueInterface>) getEventQueue {                                                                                                      \
        return [MLCUniqueEventHandlerHelper getHandler: (NSString *) handlerId];                                                                        \
    }                                                                                                                                                   \
    + (void)changePriority: (int)priority {                                                                                                             \
        [MLCUniqueEventHandlerHelper getHandler: (NSString *) handlerId priority: (QueuePriority) priority];                                            \
    }                                                                                                                                                  \
@end

#define BUILD_IN_OBJ_SINGLETON_THREAD_INTERFACE(className)             \
    @interface className (OBJ_EVENT_QUEUE)                             \
        @property(nonatomic, readonly, copy) NSString *realHandlerId;  \
        - (id<MLCEventQueueInterface>) getEventQueue;                  \
        - (void)changePriority: (int)priority;                         \
        - (void)releaseEventQueue;                                     \
    @end                                                               \

#define BUILD_OBJ_SINGLETON_THREAD_IMPLEMENTS(className, HandlerId, GlobalQueue)                                                                        \
                                                                                                                                                        \
static const NSString *handlerId = HandlerId;                                                                                                           \
static const BOOL globalQueue = GlobalQueue;                                                                                                            \
static void *handleridKey;                                                                                                                              \
                                                                                                                                                        \
@implementation className (OBJ_EVENT_QUEUE)                                                                                                             \
    - (void) releaseEventQueue {                                                                                                                        \
        if (!globalQueue) {                                                                                                                             \
            [MLCUniqueEventHandlerHelper removeHandler: [self realHandlerId]];                                                                          \
        }                                                                                                                                               \
    }                                                                                                                                                   \
    - (id<MLCEventQueueInterface>) getEventQueue {                                                                                                      \
        return [MLCUniqueEventHandlerHelper getHandler: [self realHandlerId]];                                                                          \
    }                                                                                                                                                   \
    - (void)changePriority: (int)priority {                                                                                                             \
        [MLCUniqueEventHandlerHelper getHandler: [self realHandlerId] priority: (QueuePriority) priority];                                              \
    }                                                                                                                                                   \
    - (NSString *)realHandlerId {                                                                                                                       \
        NSString *realHandlerId_ = objc_getAssociatedObject(self, &handleridKey);                                                                       \
        if (realHandlerId_ == nil)  {                                                                                                                   \
            if (globalQueue) {                                                                                                                          \
                realHandlerId_ = HandlerId;                                                                                                             \
            } else {                                                                                                                                    \
                realHandlerId_ = [NSString stringWithFormat: @"%@_%lld", HandlerId, (long long) ([[NSDate date] timeIntervalSince1970] * 1000)];        \
            }                                                                                                                                           \
            objc_setAssociatedObject(self, &handleridKey, realHandlerId_, OBJC_ASSOCIATION_COPY_NONATOMIC);                                             \
        }                                                                                                                                               \
        return realHandlerId_;                                                                                                                          \
    }                                                                                                                                                   \
@end                                                                                                                                                    \


#define EVENT_QUEUE(objectName)                               [objectName getEventQueue]
#define DISABLE_SET_THREAD_PRIORITY                           [MLCEventsQueueHandler setDisablePriority: YES];
#define ENABLE_SET_THREAD_PRIORITY                            [MLCEventsQueueHandler setDisablePriority: NO];
#define SET_THREAD_PRIORITY(className, priority)              [className changePriority: priority]
#define RELEASE_SINGLETON_THREAD(className)                   [className releaseEventQueue]

#define RUN_IN_SINGLETON_THREAD_START_WRITE(objectName)       [[objectName getEventQueue] postW: ^id {
#define RUN_IN_SINGLETON_THREAD_START_READ(objectName)        [[objectName getEventQueue] postR: ^id {
#define RUN_IN_SINGLETON_THREAD_END                           return nil; } sync: NO];
#define RUN_IN_SINGLETON_THREAD_END_SYNC                      } sync: YES];
#define RUN_IN_SINGLETON_THREAD_END_SYNC_NIL                  return nil; } sync: YES];
#define RUN_IN_SINGLETON_THREAD_END_AUTO(retValue)            return retValue; }];

#define RUN_IN_SINGLETON_THREAD_START_(objectName)       [[objectName getEventQueue] postW: ^id {

#define RUN_IN_MAIN_THREAD_START dispatch_async(dispatch_get_main_queue(), ^{

#define RUN_IN_MAIN_THREAD_END });

#define RUN_IN_MAIN_THREAD_AFTER_BEGIN(sec)                                                                               \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{             \

#define RUN_IN_MAIN_THREAD_AFTER_END                                    \
});

#define RUN_IN_MAIN_THREAD_START_SAFE(block) if (![[NSThread currentThread] isMainThread]) { dispatch_async(dispatch_get_main_queue(), ^{ if (block) block(); }); } else { if (block) block(); }

#define RUN_IN_THREAD_CONCURRENT_START(objectName)            [[objectName getEventQueue] postMultiEvents: @[^id {
#define RUN_IN_THREAD_CONCURRENT_END                          return nil; }] complete: nil];

// more easy syntx

#define DISPATCH_CHECK_IMP(iDel)    (iDel != nil && [iDel respondsToSelector: @selector(getEventQueue)])
#define DISPATCH_EVENT_QUEUE        EVENT_QUEUE(DISPATCH_CHECK_IMP(self) ? self : [self class])

#endif /* MLCOther_h */
