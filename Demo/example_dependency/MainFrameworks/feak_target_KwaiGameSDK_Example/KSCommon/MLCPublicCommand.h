//
//  MLCPublicCommand.h
//  Pods
//
//  Created by 刘玮 on 2017/4/6.
//
//

#ifndef MLCPublicCommand_h
#define MLCPublicCommand_h

#import "MLCCommand.h"

#define dispatch_begin_obj_write(obj)      RUN_IN_SINGLETON_THREAD_START_WRITE(DISPATCH_CHECK_IMP(obj) ? obj : [obj class])
#define dispatch_begin_obj_read(obj)       RUN_IN_SINGLETON_THREAD_START_READ(DISPATCH_CHECK_IMP(obj) ? obj : [obj class])
#define dispatch_begin_write               RUN_IN_SINGLETON_THREAD_START_WRITE(DISPATCH_CHECK_IMP(self) ? self : [self class])
#define dispatch_begin_read                RUN_IN_SINGLETON_THREAD_START_READ(DISPATCH_CHECK_IMP(self) ? self : [self class])
#define dispatch_end_async                 RUN_IN_SINGLETON_THREAD_END
#define dispatch_end_sync                  RUN_IN_SINGLETON_THREAD_END_SYNC
#define dispatch_end_sync_nil              RUN_IN_SINGLETON_THREAD_END_SYNC_NIL
#define dispatch_end_auto(retValue)        RUN_IN_SINGLETON_THREAD_END_AUTO(retValue)
#define dispatch_end_auto_nil              RUN_IN_SINGLETON_THREAD_END_AUTO(nil)

#define dispatch_cuncurrent_begin          RUN_IN_THREAD_CONCURRENT_START(DISPATCH_CHECK_IMP(self) ? self : [self class])
#define dispatch_cuncurrent_end            RUN_IN_THREAD_CONCURRENT_END

#define dispatch_global_async              RUN_IN_BACKGROUND_THREAD_START
#define dispatch_global_end                RUN_IN_BACKGROUND_THREAD_END

#define dispatch_weakify(obj)              KEYWORDIFY  __weak __typeof(&*obj)weak##Obj = obj;
#define dispatch_strongify(obj)            KEYWORDIFY  __strong __typeof(&*obj)obj = weak##Obj;

#endif /* MLCPublicCommand_h */
