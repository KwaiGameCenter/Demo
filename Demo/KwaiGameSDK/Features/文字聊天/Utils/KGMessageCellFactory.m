//
//  KGMessageCellFactory.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/12/7.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "KGMessageCellFactory.h"
#import <KwaiGameSDK-IM/KwaiIMMessage.h>
#import "KGMessageTextCell.h"
#import "KGMessageImageCell.h"

@implementation KGMessageCellFactory
+ (KGMessageBaseCell *)messageCellWithTableView:(UITableView *)tableView message:(KwaiIMMessage *)message {
    KGMessageBaseCell *cell;
    switch (message.type) {
        case KwaiIMMessageTypeText:
            cell = [KGMessageTextCell cellWithTableView:tableView];
            break;
        case KwaiIMMessageTypeImage:
            cell = [KGMessageImageCell cellWithTableView:tableView];
            break;
        default:
            cell = [KGMessageTextCell cellWithTableView:tableView];
            break;
    }
    return cell;
}

@end
