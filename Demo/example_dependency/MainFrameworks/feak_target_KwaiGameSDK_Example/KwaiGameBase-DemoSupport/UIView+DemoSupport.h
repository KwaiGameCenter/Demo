//
//  UIView+DemoSupport.h
//  KSAdSDK
//
//  Created by 刘玮 on 2020/5/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDemoCommandView: UIView

@property (nonatomic, strong) UITextView *textView;

@end

@interface UIViewDemoSupportParam: NSObject

@property (nonatomic, assign) BOOL demoDisableMargin;
@property (nonatomic, assign) BOOL demoIsLandscape;
@property (nonatomic, assign) CGFloat demoCellDistance;
@property (nonatomic, weak) id demoTargetProxy;

@end

@interface UIView (DemoSupport)

@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, weak) id demoTargetProxy;
@property (nonatomic, readonly, strong) UIViewDemoSupportParam *demoParams;
@property (nonatomic, readonly, assign) UIEdgeInsets demoSafeAreaInsets;
@property (nonatomic, readonly, assign) CGSize demoContentSize;

- (UILabel *)addSubLabel:(NSString *)title frame:(CGRect)frame;

- (UIButton *)addSubButton:(NSString *)title frame:(CGRect)frame selector:(_Nullable SEL)selector;

- (UISwitch *)addSubSwitch:(NSString *)title frame:(CGRect)frame selector:(_Nullable SEL)selector;

- (UISegmentedControl *)addSubSegmentedControl:(NSArray<NSString *> *)segmentedArray frame:(CGRect)frame selector:(_Nullable SEL)selector;

- (UITextView *)addCommandView:(CGRect)frame editable:(BOOL)editable selector:(_Nullable SEL)selector;

- (UIDemoCommandView *)addCommandView:(CGRect)frame buttonTitleList:(NSArray *)buttonTitleList buttonSelectorNameList:(NSArray *)buttonSelectorList;

- (UIView *)addSpliteLine:(NSString *)title frame:(CGRect)frame;

- (UIView *)addSubView:(UIView *)view frame:(CGRect)frame;

- (void)toast:(NSString *)format, ...;

- (void)showProgressToast;

- (void)hiddenProgressToast;

@end

NS_ASSUME_NONNULL_END
