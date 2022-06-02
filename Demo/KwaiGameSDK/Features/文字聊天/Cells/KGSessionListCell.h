//
//  KGSessionListCell.h
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/12/6.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KwaiIMConversation;

@interface KGSessionListCell : UITableViewCell

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *lastMessageLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *avatarLabel;
@property (strong, nonatomic) UILabel *unreadLabel;

@property (strong, nonatomic) KwaiIMConversation *conversation;

@end

