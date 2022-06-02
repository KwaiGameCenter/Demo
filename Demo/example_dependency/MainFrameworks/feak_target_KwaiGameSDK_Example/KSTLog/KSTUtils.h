//
//  KSTUtils.h
//  KSTLog
//
//  Created by liushengxiang on 2020/6/17.
//

#ifndef KSTUtils_h
#define KSTUtils_h

/**
 *  参数枚举结束符标记，配合 KSTArray 和 KSTDict 使用
 */

static NSString * const KSTStart = @"KSTSTART";
static NSString * const KSTEnd = @"KSTEND";


/**
 *  @brief  数组安全构造函数
 *  @param  combine  是否合并数组。若为YES，obj中的NSArray类型会被拆分，将其元素加入结果集。
 *  @param  obj0  obj0, obj1, ... 数组元素，支持识别空指针，参数以 KSTStart 起始（可选）、KSTEnd 结束。
 *  @return 填充了obj的可变数组，无obj时返回nil。
 */

static inline NSMutableArray * _KSTArray(BOOL combine, id obj0, ...)
{
    if (obj0 == KSTEnd) {
        return nil;
    }
    
    va_list args;
    va_start(args, obj0);
    
    id obj = obj0;
    if (obj == KSTStart) { // 起始标记
        obj = va_arg(args, id);
        
        if (obj == KSTEnd) {
            va_end(args);
            return nil;
        }
    }
    
    NSMutableArray *array = [NSMutableArray array];
    while (obj != KSTEnd) {
        if (obj != nil) {
            if (combine && [obj isKindOfClass:[NSArray class]]) { // 加入数组元素，取代数组对象
                [array addObjectsFromArray:obj];
            } else {
                [array addObject:obj];
            }
        }
        obj = va_arg(args, id);
    }
    
    va_end(args);
    
    return array;
}

#define KSTArray(...) _KSTArray(NO, KSTStart, ##__VA_ARGS__, KSTEnd)
#define KSTCombineArray(...) _KSTArray(YES, KSTStart, ##__VA_ARGS__, KSTEnd)


/**
 *  @brief  字典安全构造函数
 *  @param  key0  key0, value0, key1, value1, ... 字典元素，支持识别空指针，KV必须配对，参数以 KSTStart 起始（可选）、KSTEnd 结束。
 *  @return 填充了obj的可变字典，无KV时返回nil。
 *  @todo   obj类型动态识别，支持int、double等传参，填充相应默认值。
 */

static inline NSMutableDictionary * _KSTDict(NSString *key0, ...)
{
    if (key0 == KSTEnd) {
        return nil;
    }
    
    va_list args;
    va_start(args, key0);
    
    NSString *key = key0;
    if (key == KSTStart) { // 起始标记
        key = va_arg(args, NSString *);
        
        if (key == KSTEnd) {
            va_end(args);
            return nil;
        }
    }
    
    id obj = va_arg(args, id);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    while (key != KSTEnd && obj != KSTEnd) {
        if (key != nil) {
            [dict setValue:obj ?: [NSNull null] forKey:key];
        }
        
        key = va_arg(args, NSString *);
        if (key != KSTEnd) {
            obj = va_arg(args, id);
        }
    }
    
    NSCAssert(obj != KSTEnd, @"[KST] KV未配对：key = %@", key);
    
    va_end(args);
    
    return dict;
}

#define KSTDict(...) _KSTDict(KSTStart, ##__VA_ARGS__, KSTEnd)


/**
 *  常量定义
 */

#define KSTConst extern NSString * const


#endif /* KSTUtils_h */
