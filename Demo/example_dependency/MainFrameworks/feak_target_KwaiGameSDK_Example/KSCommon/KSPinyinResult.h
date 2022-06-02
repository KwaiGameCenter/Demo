//
//  KSPinyinResult.h
//  gifIMBaseModule
//
//  Created by lihuan05 on 2020/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KSPinyinResult : NSObject

@property (nonatomic, copy) NSString *pinyinString;
@property (nonatomic, copy) NSArray<NSString *> *pinyinArray;
@property (nonatomic, copy) NSString *abbr;

@end

NS_ASSUME_NONNULL_END
