//
//  KSMemoryWarningIgnoreImageCache.h
//  Kwai
//
//  Created by zhongchao.han on 15/2/5.
//
//

#import <Foundation/Foundation.h>

/**
 * 不受内存警告影响的图片缓存。
 * 只缓存正在显示的图片，以解决内存警告造成正在显示的图片闪烁的问题。缓存的图片的数量上线是kKSMaxMemoryWarningIgnoreImageCacheSize,如果超过将不再进行缓存
 * 注意：要在进入页面和退出页面时清理缓存
 */
@interface KSWarningIgnoreImageCache : NSObject

@property (nonatomic, assign) int maxCachedSize; //default 25

- (void)storeImage:(UIImage*)image forKey:(NSString*)key;
- (UIImage*)imageForKey:(NSString*)key;
- (void)removeImageForKey:(NSString*)key;
- (void)clearAllImage;

@end


// 这个类型和UIViewController对应，它会跟随UIViewController的dealloc销毁
typedef NS_OPTIONS(int, kKSWarningIgnoreCacheType){
    kKSWarningIgnoreCacheTypeHome,
    kKSWarningIgnoreCacheTypeUserProfile,
    kKSWarningIgnoreCacheTypeStory,
    kKSWarningIgnoreCacheTypeFollowFeeds,
};

@interface KSWarningIgnoreImageCache (KSCreate)

+ (instancetype)userProfileCache;
+ (instancetype)homeCache;
+ (instancetype)followFeedsCache;
+ (instancetype)warningIgnoreImageCacheWithType:(kKSWarningIgnoreCacheType)type;
//story上头像缓存
+ (instancetype)storyCache;


@end
