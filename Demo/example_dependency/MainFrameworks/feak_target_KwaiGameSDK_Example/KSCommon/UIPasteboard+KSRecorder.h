//
//  UIPasteboard+KSRecorder.h
//  KSCommon
//
//  Created by 孟宪璞 on 2020/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIPasteboard (KSRecorder)

@property (class, nonatomic, assign) BOOL enableKSRecorder; // default is YES
@property (nonatomic, readonly) NSInteger recorderChangeCount;

@property (nullable, nonatomic, copy) NSString *recorderString;
@property (nullable, nonatomic, copy) NSArray<NSString *> *recorderStrings;

@end

NS_ASSUME_NONNULL_END
