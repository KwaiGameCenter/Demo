//
//  KGMessageBaseCell.h
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/12/7.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KwaiIMMessage;


@class KGMessageBaseCell;
@protocol KwaiMessageCellLongPressDelegate <NSObject>
- (void)longPressForDeleteMessage:(KGMessageBaseCell *)cell;
@end

@interface KGMessageBaseCell : UITableViewCell
@property (nonatomic, weak) id<KwaiMessageCellLongPressDelegate> cellDelegate;
@property (strong, nonatomic) UILabel *avatarLabel;
@property (strong, nonatomic) UIView *bgContentView;
@property (strong, nonatomic) UIImageView *bgContentImageView;

@property (strong, nonatomic) KwaiIMMessage *message;

- (UIImage *)bubbleImage;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGSize)contentSizeWithMessage:(KwaiIMMessage *)message;
@end

