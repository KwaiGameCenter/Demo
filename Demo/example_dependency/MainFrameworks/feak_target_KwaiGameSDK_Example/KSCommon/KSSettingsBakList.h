//
//  KSSettingsBakList.h
//  gif
//
//  Created by bjzhao on 2/13/17.
//  Copyright © 2017 kuaishou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSSettingsBakList : NSObject

// return: key
- (NSInteger)pushBack:(id)obj;

// remove an elem and return the last valid elem
- (id)lastObjAfterRemovingKey:(NSInteger)aKey;

@end
