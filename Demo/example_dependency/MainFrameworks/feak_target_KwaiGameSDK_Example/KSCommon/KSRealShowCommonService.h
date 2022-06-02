//
//  KSRealShowCommonService.h
//  gifCommonsModule
//
//  Created by neeeo on 2019/1/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * 通用的列表 cell realshow 埋点逻辑。
 */
@interface KSRealShowCommonService<__covariant KeyType, __covariant ObjectType, __covariant LogType> : NSObject
/*
 * 实际埋点构造的 block。调用 uploadRealShowLogIfNeeded 时实际会调用此 block。
 */
@property (nonatomic, copy, nonnull) void (^sendRealShowLogBlock)(NSArray<LogType> *objects);
/*
 * 创建一个 object 对应的 log package。
 */
@property (nonatomic, copy, nonnull) LogType (^createObjectPackageBlock)(ObjectType object, KeyType key);
/*
 * 将列表 scrollView 赋值给此属性，将会尝试在列表滑动停止的时候发送 realshow 埋点。
 */
@property (nonatomic, weak) UIScrollView *scrollView;
/**
 * 记录 object 的 realshow 曝光。注意还没记录到埋点。uniqueKey 唯一标示一个 object，用于 realshow 去重。
 */
- (void)setObjectRealShow:(ObjectType)anObject forKey:(KeyType)uniqueKey;
/*
 * 记录一条曝光埋点
 */
- (void)uploadRealShowLogIfNeeded;
/**
 * 清空曝光记录，曝光记录是为了避免重复记录曝光。这个是为了下拉刷新准备，下拉刷新后算新曝光
 */
- (void)clearExposedHistory;

@end

NS_ASSUME_NONNULL_END
