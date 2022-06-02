//
//  KGSessionListCell.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/12/6.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "KGSessionListCell.h"
#import <KwaiGameSDK-IM/KwaiIMConversation.h>
#import "KwaiHelper.h"
#import <KwaiGameSDK-IM/KwaiIMMessage.h>

@implementation KGSessionListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.lastMessageLabel];
        [self.contentView addSubview:self.avatarLabel];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.unreadLabel];
    }
    return self;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:15];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = [UIColor grayColor];
    }
    return _timeLabel;
}

- (UILabel *)lastMessageLabel {
    if (!_lastMessageLabel) {
        _lastMessageLabel = [[UILabel alloc] init];
        _lastMessageLabel.font = [UIFont systemFontOfSize:15];
        _lastMessageLabel.textColor = [UIColor grayColor];
    }
    return _lastMessageLabel;
}

- (UILabel *)avatarLabel {
    if (!_avatarLabel) {
        _avatarLabel = [[UILabel alloc] init];
        _avatarLabel.font = [UIFont boldSystemFontOfSize:30];
        _avatarLabel.textColor = [UIColor whiteColor];
        _avatarLabel.textAlignment = NSTextAlignmentCenter;
        _avatarLabel.backgroundColor = [UIColor grayColor];
    }
    return _avatarLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:17];
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}

- (UILabel *)unreadLabel {
    if (!_unreadLabel) {
        _unreadLabel = [[UILabel alloc] init];
        _unreadLabel.font = [UIFont systemFontOfSize:15];
        _unreadLabel.textColor = [UIColor whiteColor];
        _unreadLabel.backgroundColor = [UIColor redColor];
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _unreadLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.timeLabel.height = 20;
    self.lastMessageLabel.height = 20;
    self.avatarLabel.height = 50;
    self.avatarLabel.width = 50;
    self.nameLabel.height = 20;
    self.unreadLabel.height = 18;
    
    self.avatarLabel.top = 10;
    self.avatarLabel.left = 10;
    self.nameLabel.left = self.avatarLabel.right + 10;
    self.nameLabel.top = 15;
    self.nameLabel.width = 100;
    self.lastMessageLabel.left = self.avatarLabel.right + 10;
    self.lastMessageLabel.top = self.nameLabel.bottom + 5;
    self.lastMessageLabel.width = self.bounds.size.width - self.lastMessageLabel.left - 50;
    self.timeLabel.top = 15;
    self.timeLabel.left = self.nameLabel.right;
    self.timeLabel.width = self.bounds.size.width - self.timeLabel.left - 10;
    self.unreadLabel.right = self.contentView.right - 10;
    self.unreadLabel.bottom = self.contentView.bottom - 10;
}

- (void)setConversation:(KwaiIMConversation *)conversation {
    _conversation = conversation;
    self.avatarLabel.text = [self titleWithConversation:conversation];
    self.nameLabel.text = [NSString stringWithFormat:@"ID: %@", conversation.conversationID];
    self.timeLabel.text = [KwaiHelper timeAgoStringForDate:[NSDate dateWithTimeIntervalSince1970:conversation.updatedTime] isFromList:true];
    self.lastMessageLabel.text = [self contentWithConversation:conversation];
    self.unreadLabel.hidden = conversation.unreadCount == 0;
    self.unreadLabel.text = @(conversation.unreadCount).stringValue;
}

- (NSString *)titleWithConversation:(KwaiIMConversation *)conversation {
    switch (conversation.type) {
        case KwaiIMConversationTypeSingle:
            return @"S";
            break;
        case KwaiIMConversationTypeGroup:
            return @"G";
        case KwaiIMConversationTypeChannel:
            return @"C";
        default:
            return @"U";
            break;
    }
}

- (NSString *)contentWithConversation:(KwaiIMConversation *)conversation {
    if (conversation.draft.length > 0) {
        return [NSString stringWithFormat:@"草稿: %@", conversation.draft];
    }
    if (conversation.lastMessage == nil) {
        return @"";
    }
    KwaiIMMessage *message = conversation.lastMessage;
    if (message.text.length > 0) {
        return message.text;
    } else {
        return @"[其他消息类型]";
    }
    return @"";
}

@end
