//
//  KSDatabaseUpgradeProtocol.h
//  gifIMModule
//
//  Created by LiuXuan on 2018/11/12.
//

#import <Foundation/Foundation.h>

/**
 数据库升级接口
 */
@protocol KSDatabaseUpgradeProtocol <NSObject>

/**
 检查数据库版本并更新
 */
+ (void)upgradeDatabaseIfNeeded;

@optional

/**
 获取当前数据库版本
 @return 当前数据库版本
 */
+ (NSInteger)databaseVersion;

/**
 存储数据库版本
 @param version 数据库版本
 @return 存储完成
 */
+ (BOOL)setDatabaseVersion:(NSInteger)version;

@end
