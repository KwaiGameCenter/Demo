//
//  KBMulticastDelegate.h
//  KwaiBase
//
//  Created by 刘玮 on 2018/4/2.
//

#import <Foundation/Foundation.h>

@interface KBMulticastDelegate : NSObject

@property (nonatomic, assign) BOOL mergeBOOLResultLinkAND;
@property (nonatomic, assign) BOOL mergeBOOLResultLinkOR;   // Default Method

- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

- (void)removeDelegate:(id)delegate;

- (void)removeAllDelegates;

@end
