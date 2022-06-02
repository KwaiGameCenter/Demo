//
//  KGMessageCellFactory.h
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/12/7.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KGMessageBaseCell, KwaiIMMessage;

NS_ASSUME_NONNULL_BEGIN

@interface KGMessageCellFactory : NSObject

+ (KGMessageBaseCell *)messageCellWithTableView:(UITableView *)tableView message:(KwaiIMMessage *)message;

@end

NS_ASSUME_NONNULL_END
