//
//  BFTask+ErrorAggregation.h
//  gif
//
//  Created by 曾令男 on 28/09/2017.
//  Copyright © 2017 kuaishou. All rights reserved.
//

#import <Bolts/Bolts.h>

@interface BFTask (ErrorAggregation)

+ (instancetype)taskForCompletionOfAllTasks:(NSArray<BFTask *> *)tasks
                                  errorKeys:(NSArray<NSString *> *)errorKeys
                                errorDomain:(NSString *)errorDomain
                                  errorCode:(NSInteger)errorCode;

@end
