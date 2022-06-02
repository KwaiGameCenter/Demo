//
//  NSFileManager+KSMerge.h
//  gif
//
//  Created by 曾令男 on 22/01/2017.
//  Copyright © 2017 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (KSMerge)

- (BOOL)mergeContentOfPath:(NSString *)srcDir intoPath:(NSString *)dstDir error:(NSError **)error;

@end
