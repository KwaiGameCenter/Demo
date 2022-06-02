//
//  KSDebugHeaderInProject.h
//  gif
//
//  Created by fover0 on 2018/3/26.
//  Copyright © 2018年 kuaishou. All rights reserved.
//


#define PRINTLOG 1

#ifndef NS_BLOCK_ASSERTIONS
    #define NSLog(...) NSLog(__VA_ARGS__)
#elif defined(_KS_LIVE_PODS_) && defined(BETA)
    #define NSLog(...) NSLog(__VA_ARGS__)
#else
    #define NSLog(...) {}
#endif

#ifndef KSIsDebugging
    #if defined(BETA) || defined(DEBUG)
        #define KSIsDebugging 1
    #endif
#endif

