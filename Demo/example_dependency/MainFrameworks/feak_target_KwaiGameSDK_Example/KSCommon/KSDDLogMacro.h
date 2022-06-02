//
//  KSDDLogMacro.h
//  
//
//  Created by 舒祯 on 2019/1/4.
//

#import <KSTLog/KSTLogDefines.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

extern DDLogLevel ddLogLevel;

#define KSLogMethodEntryInfo(params) KSTLogAMDebug(@"KSDDLogMacro", @"%@", (params) ?: @"")
