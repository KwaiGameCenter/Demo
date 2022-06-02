//
//  BFTask+KSArrayReduce.h
//  gif
//
//  Created by 杨鑫磊 on 2018/3/7.
//  Copyright © 2018年 kuaishou. All rights reserved.
//

#import <Bolts/Bolts.h>
#import <Foundation/Foundation.h>

@interface BFTask<ObjectType> (KSArrayReduce)
// 在每个元素上线性执行异步操作
+ (BFTask *)ks_arrayReduce:(NSArray<ObjectType> *)array withBlock:(BFTask *(^ __nonnull)(ObjectType obj, NSUInteger idx))block;
@end

