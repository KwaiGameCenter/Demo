//
//  KSTLogDefines.h
//  KSTLog
//
//  Created by liushengxiang on 2020/6/1.
//

#ifndef KSTLogDefines_h
#define KSTLogDefines_h

#import <KSTLog/KSTLogger.h>
#import <KSTLog/KSTUtils.h>


/**
 *  基础日志接口
 */

#define KSTLoggerLog(logger, levelEnum, moduleStr, tagArray, descStr, paramDict, extendDict) \
        [logger log: levelEnum              \
             module: moduleStr              \
               tags: tagArray               \
               file: __FILE__               \
           function: __PRETTY_FUNCTION__    \
               line: __LINE__               \
               desc: descStr                \
             params: paramDict              \
             extend: extendDict]


/**
 *  共享单例日志接口
 */

#define KSTLog(levelEnum, moduleStr, tagArray, descStr, paramDict, extendDict) \
        KSTLoggerLog([KSTLogger sharedInstance], levelEnum, moduleStr, tagArray, descStr, paramDict, extendDict)

/**
 *  共享单例，分级多标签接口
 */

#define KSTLogTagsError(moduleStr, tagArray, descStr, paramDict, extendDict) \
        KSTLog(KSTLogLevelError, moduleStr, tagArray, descStr, paramDict, extendDict)

#define KSTLogTagsWarn(moduleStr, tagArray, descStr, paramDict, extendDict) \
        KSTLog(KSTLogLevelWarning, moduleStr, tagArray, descStr, paramDict, extendDict)

#define KSTLogTagsInfo(moduleStr, tagArray, descStr, paramDict, extendDict) \
        KSTLog(KSTLogLevelInfo, moduleStr, tagArray, descStr, paramDict, extendDict)

#define KSTLogTagsDebug(moduleStr, tagArray, descStr, paramDict, extendDict) \
        KSTLog(KSTLogLevelDebug, moduleStr, tagArray, descStr, paramDict, extendDict)


/**
 *  共享单例，分级单标签接口
 */

#define KSTLogError(moduleStr, tagStr, descStr, paramDict, extendDict) \
        KSTLogTagsError(moduleStr, KSTArray(tagStr), descStr, paramDict, extendDict)

#define KSTLogWarn(moduleStr, tagStr, descStr, paramDict, extendDict) \
        KSTLogTagsWarn(moduleStr, KSTArray(tagStr), descStr, paramDict, extendDict)

#define KSTLogInfo(moduleStr, tagStr, descStr, paramDict, extendDict) \
        KSTLogTagsInfo(moduleStr, KSTArray(tagStr), descStr, paramDict, extendDict)

#define KSTLogDebug(moduleStr, tagStr, descStr, paramDict, extendDict) \
        KSTLogTagsDebug(moduleStr, KSTArray(tagStr), descStr, paramDict, extendDict)


/**
 *  共享单例，分级单标签，参数枚举接口（不支持 extend 扩展字段）
 *  params：key和value交替输入，必须是id类型，不支持直接传int、bool、double等类型
 */

#define KSTLogParamsError(moduleStr, tagStr, descStr, ...) \
        KSTLogError(moduleStr, tagStr, descStr, KSTDict(__VA_ARGS__), nil)

#define KSTLogParamsWarn(moduleStr, tagStr, descStr, ...) \
        KSTLogWarn(moduleStr, tagStr, descStr, KSTDict(__VA_ARGS__), nil)

#define KSTLogParamsInfo(moduleStr, tagStr, descStr, ...) \
        KSTLogInfo(moduleStr, tagStr, descStr, KSTDict(__VA_ARGS__), nil)

#define KSTLogParamsDebug(moduleStr, tagStr, descStr, ...) \
        KSTLogDebug(moduleStr, tagStr, descStr, KSTDict(__VA_ARGS__), nil)


#pragma mark - 日志治理定义的新借口和新的宏,以下宏用于脚本自动替换

#define KSTLog_OBJC_MAYBE(levelEnum, moduleStr, tagArray, frmt,...) \
        KSTLog_MAYBE([KSTLogger sharedInstance], levelEnum, moduleStr, tagArray, frmt,##__VA_ARGS__)
#define KSTLog_MAYBE(logger, levelEnum, moduleStr, tagArray, frmt,...) \
        [logger kst_log: levelEnum              \
                 module: moduleStr              \
                   tags: tagArray               \
                   file: __FILE__               \
               function: __PRETTY_FUNCTION__    \
                   line: __LINE__               \
                 format:(frmt), ## __VA_ARGS__]

/// am -> auto module 脚本自动替换的宏,  默认为Info级别,自动填充KSPOD_NAME, 存量日志: tag从代码的日志内容中截取第一个[],如果没有就用文件名填充,AM代表automodule自动填充module
#define KSTLogAMError(tagStr, frmt,...) KSTLog_OBJC_MAYBE(KSTLogLevelError, KSPOD_NAME, KSTArray(tagStr), frmt,##__VA_ARGS__)
#define KSTLogAMWarn(tagStr, frmt,...)  KSTLog_OBJC_MAYBE(KSTLogLevelWarning, KSPOD_NAME, KSTArray(tagStr), frmt,##__VA_ARGS__)
#define KSTLogAMInfo(tagStr, frmt,...)  KSTLog_OBJC_MAYBE(KSTLogLevelInfo, KSPOD_NAME, KSTArray(tagStr), frmt,##__VA_ARGS__)
#define KSTLogAMDebug(tagStr, frmt,...) KSTLog_OBJC_MAYBE(KSTLogLevelDebug, KSPOD_NAME, KSTArray(tagStr), frmt,##__VA_ARGS__)

/// 多tag的标签宏, 频次较少,所以只定义基础宏,业务自己传递levelEnum参数
#define KSTLogAM_Tags(levelEnum,tagsArray,frmt,...) KSTLog_OBJC_MAYBE(levelEnum, KSPOD_NAME, (tagsArray), frmt,##__VA_ARGS__)

#endif /* KSTLogDefines_h */
