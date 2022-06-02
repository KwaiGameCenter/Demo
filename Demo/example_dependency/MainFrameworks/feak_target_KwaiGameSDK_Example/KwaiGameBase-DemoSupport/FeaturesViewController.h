//
//  FeaturesViewController.h
//  KwaiGameSDK
//
//  Created by mookhf on 04/10/2018.
//  Copyright (c) 2018 mookhf. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kgFeatureWithName(name, block) [KGFreatureInfo featureInfo:name buildBlock:block]

@interface KGFreatureInfo: NSObject

@property (nonatomic,copy) NSString *iconName;          // 功能图标
@property (nonatomic,copy) NSString *featureName;       // 功能名称
@property (nonatomic,copy) NSString *controllerName;    // UI名称(用于搜索)
@property (nonatomic,copy) NSString *storyboardName;    // UI布局名称
@property (nonatomic,assign) BOOL needLogind;           // 此功能是否需要登录后再使用
@property (nonatomic,assign) BOOL hidden;               // 不在列表中显示该功能
@property (nonatomic,assign) BOOL splitLine;            // 我是分割线
@property (nonatomic,assign) BOOL onlyQA;               // 只有QA模可见
@property (nonatomic,assign) BOOL supportOversea;       // 支持Oversea(default NO)
@property (nonatomic,assign) BOOL supportInner;         // 支持国内(default YES)

@property (nonatomic,readonly,copy) NSString *displayName;

+ (KGFreatureInfo *)featureInfo:(NSString *)name;

+ (KGFreatureInfo *)featureInfo:(NSString *)name buildBlock:(void(^)(KGFreatureInfo *info))buildBlock;

@end

@interface FeaturesViewController : UITableViewController

- (void)pushFeatureController:(KGFreatureInfo *)info;

@end

@interface FeaturesViewController (Protected)

- (NSString *)titleName;

- (NSDictionary<NSString *, KGFreatureInfo *> *)features;

- (BOOL)hiddenFeature:(KGFreatureInfo *)info;

- (BOOL)supportSetting;

- (void)gotoSettingFeature;

- (BOOL)onFeatureControllerWillPresent:(KGFreatureInfo *)info;

- (void)onCellWillDisplay:(UITableViewCell *)cell info:(KGFreatureInfo *)info;

@end
