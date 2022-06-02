//
//  NSArray+process.h
//  QWeiboSDK4iOSDemo
//
//  Created by zhongchao.han on 14-8-20.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (process)
- (void)perform:(SEL)selector withObject:(id)p1;
- (void)perform:(SEL)selector withObject:(id)p1 withObject:(id)p2;
@end
