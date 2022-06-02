//
//  KSLRUCache.h
//  gif
//
//  Created by 薛辉 on 1/4/17.
//  Copyright © 2017 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KSCommon/KSCommonLogLevel.h>

@class KSLRUCache;

@protocol KSLRUCacheDelegate <NSObject>
@optional
- (void)cache:(KSLRUCache *)cache didEvictKeyObjects:(NSDictionary *)keyObjects;
@end

@interface KSLRUCache <KeyType, ObjectType> : NSObject

@property (nonatomic, weak) id <KSLRUCacheDelegate> delegate;

@property (copy) NSString *name;

- (ObjectType)objectForKey:(KeyType)key;
- (void)setObject:(ObjectType)obj forKey:(KeyType)key; // 0 cost
- (void)setObject:(ObjectType)obj forKey:(KeyType)key cost:(NSUInteger)g;
- (void)removeObjectForKey:(KeyType)key;

- (void)removeAllObjects;

@property NSUInteger totalCostLimit;	// limits are imprecise/not strict
@property NSUInteger countLimit;	// limits are imprecise/not strict

@property (nonatomic, strong, readonly) NSSet *cachedKeySet;

- (NSMapTable *)mapTable;
- (void)setMapTable:(NSMapTable *)mapTable;

@end
