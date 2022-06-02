//
//  CommonMacro.h
//  QWeiboSDK4iOSDemo
//
//  Created by han_zc on 14/8/1.
//
//
#import <KSTLog/KSTLogDefines.h>
#import <UIKit/UIKit.h>
/**
 * 解决“performSelector may cause a leak because its selector is unknown”警告
 */
#import <Foundation/Foundation.h>
#import <KSUserDefaults/KSUserDefaults.h>

#define kAppDelegate \
([[UIApplication sharedApplication] delegate])

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define SuppressDeprecatedDeclarationsWarning(Stuff) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wdeprecated-declarations\"") \
Stuff; \
_Pragma("clang diagnostic pop")

#define SuppressUndeclaredSelectorWarning(Stuff) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wundeclared-selector\"") \
Stuff; \
_Pragma("clang diagnostic pop")

/**
 * 主线程执行代码
 */
#define ASYNC_MAIN(...) dispatch_async(dispatch_get_main_queue(), ^{ __VA_ARGS__ })

#define ASYNC_ON_MAIN_QUEUE(block) dispatch_async(dispatch_get_main_queue(), block)

/**
 * ARC 点击接口
 */
#define SINGLE_INTERFACE_WITH_CLASSNAME(className) + (instancetype) shared##className;

/**
 * ARC 单例实现
 */
#define SINGLE_IMPLEMENT_WITH_CLASSNAME(className)\
+ (instancetype)shared##className\
{\
    static className *obj = nil;\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        obj = [[self alloc]init];\
    });\
    return obj;\
}

// 判空
#define KWAI_IS_STR_NIL(objStr) (![objStr isKindOfClass:[NSString class]] || objStr == nil || [objStr length] <= 0)
#define KWAI_IS_DICT_NIL(objDict) (![objDict isKindOfClass:[NSDictionary class]] || objDict == nil || [objDict count] <= 0)
#define KWAI_IS_ARRAY_NIL(objArray) (![objArray isKindOfClass:[NSArray class]] || objArray == nil || [objArray count] <= 0)
#define KWAI_IS_NUM_NIL(objNum) (![objNum isKindOfClass:[NSNumber class]] || objNum == nil)
#define KWAI_IS_DATA_NIL(objData) (![objData isKindOfClass:[NSData class]] || objData == nil || [objData length] <= 0)

/**
 * 安全删除属性监听,当当前没有监听而去删除监听的时候会引起crash，这里做安全处理
 * 为保证代码稳定，预防不必要的错误重复发生。所有删除监听操作都应该使用这个宏！！
 */
#define REMOVE_OBSERVER_SAFELY(observed,observer,keyPath) \
@try{\
    [observed removeObserver:observer forKeyPath:keyPath];\
}@catch(id anException){\
    NSLog(@"***removeObserver:%@",anException);\
}

#define ADD_OBSERVER_SAFELY(observed,observer,keyPath) \
@try{\
[observed addObserver:observer forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];\
}@catch(id anException){\
NSLog(@"***addObserver:%@",anException);\
}
//弱引用和强引用
#define WEAK_OBJ_REF(obj) __weak __typeof__(obj) weak_##obj = obj
#define STRONG_OBJ_REF(obj) __strong __typeof__(obj) strong_##obj = obj

/*
 更好看的强弱引用转换
 
 ```objc
 ...
 WEAK_REF(item);
 item.someBlock = ^() {
    STRONG_REF(item);
    [item foo];
    ...
 };
 ```
 */
#define WEAK_REF(obj) __weak __typeof__(obj) weak_##obj = obj
#define STRONG_REF(obj) __strong __typeof__(weak_##obj) obj = weak_##obj

#define WS WEAK_OBJ_REF(self);
//#define SS __strong __typeof__(weak_self) self = weak_self;
#define SS \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
__strong __typeof__(weak_self) self = weak_self; \
_Pragma("clang diagnostic pop")

// retain 的associated getter setter 方法
#define OBJC_GETTER_SETTER_RETAIN_METHOD(type,getterName,setterName) \
static void const *kKS##getterName##Key = #getterName ; \
- (type) getterName \
{ \
@synchronized(self){ \
return objc_getAssociatedObject(self, kKS##getterName##Key); \
} \
} \
- (void) setterName :(type)getterName \
{ \
@synchronized(self){ \
objc_setAssociatedObject(self, kKS##getterName##Key, getterName , OBJC_ASSOCIATION_RETAIN); \
} \
} \

/// 带缓存的getter/setter宏
#define KS_OBJECT_PERSISTENCE_GSETTER(objecType, getterName, setterName, perssstenceKey, defaultObject) \
- (objecType *) getterName \
{ \
return [[NSUserDefaults standardUserDefaults] objectForKey:perssstenceKey] ?: defaultObject; \
} \
- (void) setterName :(objecType *)value \
{ \
[[NSUserDefaults standardUserDefaults] setObject:value forKey:perssstenceKey]; \
}

#define KS_NSNUMBER_PERSISTENCE_GSETTER(getterName, setterName, perssstenceKey, defaultObject) \
KS_OBJECT_PERSISTENCE_GSETTER(NSNumber, getterName, setterName, perssstenceKey, defaultObject)

#define KS_NSSTRING_PERSISTENCE_GSETTER(getterName, setterName, perssstenceKey, defaultObject) \
KS_OBJECT_PERSISTENCE_GSETTER(NSString, getterName, setterName, perssstenceKey, defaultObject)

#if defined(BETA) || defined(DEBUG)
    #define KSIsDebugging 1
#endif

static inline BOOL _Float_Equal(CGFloat f1, CGFloat f2)
{
    CGFloat epsilon = 0.0000001;
    return fabs(f1 - f2) <= epsilon;
}

#define KSFloatEqual(f1, f2) _Float_Equal((f1), (f2))
#define KSFloatEqualZero(f) _Float_Equal((f), 0)
#define KSFloatLess(f1, f2) !(KSFloatEqual(f1, f2)) && f1 < f2
#define KSFloatLessOrEqual(f1, f2) !(KSFloatLess(f2, f1))

/* */

#define _NOW_S          (NSDate.date.timeIntervalSince1970)             // 自1970以来的秒数
#define _NOW_MS         (_NOW_S * 1000.)     // ms数，服务器传时间绝对值
#define _TICK_S         CACurrentMediaTime()                            // 用于内部计数
#define _TICK_MS        (_TICK_S * 1000.)    // ms毫秒，内部计数用

//#import "CocoaLumberjack.h"

#if DEBUG

#define LOG(fmt, ...)           NSLog((@"%p,%0.4f,%s,%d#" fmt), NSThread.currentThread, _TICK_S - (long)(_TICK_S / 60) * 60, __FUNCTION__, __LINE__, ## __VA_ARGS__);
#define ASSERT(condition)       NSCAssert((condition), @"ASSERT failed!" # condition);
//#define ASSERT(condition)       {NSCAssert((condition), @"ASSERT failed!" # condition); if (!(condition)) {LOG_MACRO(NO, KSTLogLevelError, KSTLogLevelError, 0, nil, __PRETTY_FUNCTION__, @"ASSERT failed! " # condition);}}

#else

#define LOG(fmt, ...)           {}
#define ASSERT(condition)             {}
//#define ASSERT(condition)       {if (!(condition)) {LOG_MACRO(NO, KSTLogLevelError, KSTLogLevelError, 0, nil, __PRETTY_FUNCTION__, @"ASSERT failed! " # condition);}}

#endif

#define TICK_Start()            double _time_start_tick_ = _TICK_S;
#define TICK_End()              LOG(@"Time-Cost %f", _TICK_S - _time_start_tick_);

#define isKindOf(x, cls)                [(x) isKindOfClass:[cls class]]         // 判断实例类型(含子类)
#define isMemberOf(x, cls)              [(x) isMemberOfClass:[cls class]]       // 判断实例类型(不含子类)

#define ASSERT_Class(x, cls)            ASSERT((x) && isKindOf(x, cls))         // 断言实例有值并且类型
#define ASSERT_ClassOrNil(x, cls)       ASSERT(!(x) || isKindOf(x, cls))        // 断言实例无值或者类型

#define DDCategoryLogDebug(category, msg, ...) KSTLogAMDebug(@"CommonMacro", @"[%@] %@", category, [NSString stringWithFormat:msg, ##__VA_ARGS__])

#if defined(__cplusplus)
#define let auto const
#else
#define let const __auto_type
#endif

#if defined(__cplusplus)
#define var auto
#else
#define var __auto_type
#endif

typedef struct __attribute__((objc_boxable)) CGPoint CGPoint;
typedef struct __attribute__((objc_boxable)) CGSize CGSize;
typedef struct __attribute__((objc_boxable)) CGRect CGRect;
typedef struct __attribute__((objc_boxable)) CGVector CGVector;
typedef struct __attribute__((objc_boxable)) CGAffineTransform CGAffineTransform;
typedef struct __attribute__((objc_boxable)) UIEdgeInsets UIEdgeInsets;
typedef struct __attribute__((objc_boxable)) _NSRange NSRange;


#define KSViewControllerChangeDesignatedInitalizer                              \
    - (nonnull instancetype)init NS_UNAVAILABLE;                                \
    - (nonnull instancetype)initWithNibName:(nullable NSString *)nibNameOrNil   \
                                     bundle:(nullable NSBundle *)nibBundleOrNil \
                                                                NS_UNAVAILABLE; \
    - (nonnull instancetype)initWithCoder:(nonnull NSCoder *)aDecoder           \
                                                             NS_UNAVAILABLE;    \
    + (nonnull instancetype)new NS_UNAVAILABLE                                  \


/**
 用 isKindOfClass 来判断类是否正确，正确返回实例，否则是 nil

 @param OBJ 被检查的实例
 @param CLASS 要匹配的类
 @return 匹配正确的话返回实例，否则是 nil
 */
#define KSSAFE_CAST(OBJ, CLASS)                                            \
        ({                                                                 \
            CLASS* result = nil;                                           \
            if ([OBJ isKindOfClass:[CLASS class]])                         \
            {                                                              \
                result = (CLASS*)OBJ;                                      \
            }                                                              \
            result;                                                        \
        })


/**
 用 object_getClass 来判断类是否正确，正确返回实例，否则是 nil

 @param OBJ 被检查的实例
 @param CLASS 要匹配的类
 @return 匹配正确的话返回实例，否则是 nil
 */
#define KSSAFE_CAST_BY_RUNTIME(OBJ, CLASS)                             \
    ({                                                                 \
        CLASS* result = nil;                                           \
        if (object_getClass(OBJ) == [CLASS class])                     \
        {                                                              \
            result = (CLASS*)OBJ;                                      \
        }                                                              \
        result;                                                        \
    })


#define DescClass(class)                                                \
\
\
@implementation class(Desc)                                         \
\
- (NSString *)description {                                             \
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];       \
    for (NSString *key in [self kc_codableProperties]) {                \
        id value = [self valueForKey: key];                             \
        if (value != nil) {                                             \
            [dict setValue: value forKey: key];                         \
        }                                                               \
    }                                                                   \
    return [dict description];                                          \
}                                                                       \
    \
@end

// 判断delegate是否反应某个selector
#define KWAI_IS_DELEGATE_RSP_SEL(iDel, iSel) (iDel != nil && [iDel respondsToSelector:@selector(iSel)])
#define KWAI_IS_DELEGATE_RSP_ASEL(iDel, iSel) (iDel != nil && [iDel respondsToSelector:iSel])
#define KWAI_IS_DELEGATE_CFM_PROTOCOL(iDel, iProtocol) (iDel != nil && [iDel conformsToProtocol:@protocol(iProtocol)])

// 常用GCD命令
#define KWAI_RUN_IN_MAIN_THREAD_START dispatch_async(dispatch_get_main_queue(), ^{
#define KWAI_RUN_IN_MAIN_THREAD_END });
#define KWAI_RUN_IN_BACKGROUND_THREAD_START dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
#define KWAI_RUN_IN_BACKGROUND_THREAD_END });

// 日志

// 颜色
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
                 blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
                alpha:1.0]

#define UIColorFromRGBA(rgbValue, alphaValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
                 blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
                alpha:alphaValue]

// 字体
#ifndef Font
#define Font(x)                         [UIFont systemFontOfSize:x]
#endif

#ifndef ItalicFont
#define ItalicFont(x)                   [UIFont italicSystemFontOfSize:x]
#endif

#ifndef BoldFont
#define BoldFont(x)                     [UIFont boldSystemFontOfSize:x]
#endif

#ifndef MediumFont
#define MediumFont(x)                   ({UIFont *font; if(@available(iOS 8.2, *)) {font = [UIFont systemFontOfSize:x weight:UIFontWeightMedium];} else {font = [UIFont systemFontOfSize:x];} font;})
#endif

//block
#define BLOCK_SAFE_RUN(block, ...)                  \
if (block) {                                        \
    block(__VA_ARGS__);                             \
}

// 屏幕尺寸
#define SCREEN_SCALE [UIScreen mainScreen].scale
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SCREEN_4S_WIDTH 320
#define SCREEN_5_WIDTH  320
#define SCREEN_6_WIDTH  375
#define SCREEN_6P_WIDTH 414

#define SCREEN_4S_HEIGHT 480
#define SCREEN_5_HEIGTH  568
#define SCREEN_6_HEIGHT  667
#define SCREEN_6P_HEIGHT 736

// 高宽比
#define KWAI_ASPECT_RATIO (SCREEN_HEIGHT > SCREEN_WIDTH ? SCREEN_HEIGHT/SCREEN_WIDTH : SCREEN_WIDTH/SCREEN_HEIGHT)
// 判断是否是全面屏，iOS屏幕包含两种主流高宽比，全面屏都是2.164，非全面屏为1.778，iPhone 4s为1.5
#define KWAI_IS_ALL_SCREEN_DEVICE ([UIDeviceHardware isALLScreenDevice])

//安全区
#define SYSTEM_SAFE_AREA_INSETS     SAFE_AREA_INSETS(UIApplication.sharedApplication.keyWindow)
#define SAFE_AREA_INSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})

#ifndef ksOnExit
#define ksOnExit \
__strong void(^dispatch_block_t)(void) __attribute__((cleanup(ks_methodCleanupBlock), unused)) = ^
#endif

#if defined(__cplusplus)
extern "C" {
#endif
    void ks_methodCleanupBlock(__strong dispatch_block_t *block);
#if defined(__cplusplus)
}
#endif
