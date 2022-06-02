//
//  BFExecutor+AsyncMain.h
//  gifCommonsModule
//
//  Created by Lingnan Zeng on 2018/11/22.
//

#import <Bolts/Bolts.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFExecutor (AsyncMain)

+ (instancetype)asyncMainThreadExecutor;

@end

NS_ASSUME_NONNULL_END
