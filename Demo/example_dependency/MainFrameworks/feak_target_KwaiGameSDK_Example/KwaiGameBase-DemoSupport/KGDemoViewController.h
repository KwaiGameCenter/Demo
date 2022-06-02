//
//  KGDemoViewController.h
//  KwaiGameBase
//
//  Created by 刘玮 on 2020/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KGDemoViewController : UIViewController

- (void)adjustContentSize:(CGSize)size;

- (UIView *)addSpliteLine:(NSString *)title frame:(CGRect)frame;

- (UILabel *)addSubLabel:(NSString *)title frame:(CGRect)frame;

- (UIButton *)addSubButton:(NSString *)title frame:(CGRect)frame selector:(_Nullable SEL)selector;

- (UISwitch *)addSubSwitch:(NSString *)title frame:(CGRect)frame selector:(_Nullable SEL)selector;

- (UISegmentedControl *)addSubSegmentedControl:(NSArray<NSString *> *)segmentedArray frame:(CGRect)frame selector:(_Nullable SEL)selector;

- (UIView *)addCommandView:(CGRect)frame editable:(BOOL)editable selector:(_Nullable SEL)selector;

- (UIView *)addCommandView:(CGRect)frame buttonTitleList:(NSArray *)buttonTitleList buttonSelectorNameList:(NSArray *)buttonSelectorList;

- (UIView *)addSubView:(UIView *)view frame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
