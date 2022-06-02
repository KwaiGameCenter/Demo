//
//  KSColdBFTask.h
//  gif
//
//  Created by LiSi on 10/01/2018.
//  Copyright © 2018 kuaishou. All rights reserved.
//

#import <Bolts/Bolts.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define KSColdBFTaskAvailable 0 // 暂时用不到

#if KSColdBFTaskAvailable
@interface KSColdBFTask <__covariant ObjectType> : BFTask

@property (nonatomic, readonly, getter=isHot) BOOL hot;
@property (nonatomic, readonly, nullable) BFTask <ObjectType> *runningTask;

@end
#endif

@interface KSColdBFTaskBag <__covariant ObjectType> : NSObject

typedef BFTask <ObjectType> *_Nonnull(^KSColdBFTaskCreator)();
+ (instancetype)coldTaskWithCreator:(KSColdBFTaskCreator)creator;

- (BFTask <ObjectType> *)createHotTask;
#if KSColdBFTaskAvailable
- (KSColdBFTask <ObjectType> *)createColdTask;
#endif

@end

// ---- Retry ----
@protocol KSColdBFTaskRetryConfiguration <NSObject>
@property (nonatomic) NSInteger maxRetryCount;
@property (nonatomic) NSTimeInterval retryInterval;
@property (nonatomic) BOOL (^shouldRetry)(BFTask *previousTask);
@end

@interface KSColdBFTaskRetryConfiguration: NSObject <KSColdBFTaskRetryConfiguration>
@end

@interface KSColdBFTaskBag <__covariant ObjectType> (Retry)

- (BFTask <ObjectType> *)retriableTaskWithConfiguration:(id <KSColdBFTaskRetryConfiguration>)configuration
                                               executor:(BFExecutor *)executor
                                       cancelationToken:(BFCancellationToken * _Nullable)token;

@end

NS_ASSUME_NONNULL_END
