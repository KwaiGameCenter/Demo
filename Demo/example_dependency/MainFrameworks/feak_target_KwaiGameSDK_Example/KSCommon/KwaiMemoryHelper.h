//
//  KwaiMemoryHelper.h
//  gif
//
//  Created by fover0 on 2018/3/22.
//  Copyright © 2018年 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef CFSafeRelease
    #define CFSafeRelease(CFObjectPointer)          \
                if (CFObjectPointer)                \
                {                                   \
                    CFRelease(CFObjectPointer);     \
                    CFObjectPointer = NULL;         \
                }
#endif

