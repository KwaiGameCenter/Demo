//
//  KSSafeImageUtil.h
//  gif
//
//  Created by hanshaopeng on 08/01/2018.
//  Copyright © 2018 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSSafeImageUtil : NSObject

- (nullable UIImage *)imageNamed:(NSString *_Nonnull)imageName;
- (void)setMaxCount:(NSUInteger)maxCount;

+ (nullable UIImage *)imageNamed:(NSString *_Nonnull)imageName;

@end
