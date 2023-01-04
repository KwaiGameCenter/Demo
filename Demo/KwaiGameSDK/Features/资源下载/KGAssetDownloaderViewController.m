//
//  KGAssetDownloaderViewController.m
//  KwaiGameSDK_Example
//
//  Created by yan long on 2022/11/1.
//  Copyright © 2022 mookhf. All rights reserved.
//

#import "KGAssetDownloaderViewController.h"
#import "KwaiGameSDK+AssetsBundleDownloader+Public.h"

@interface KGAssetDownloaderViewController ()

@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation KGAssetDownloaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_DEFAULT, -1);
    self.queue = dispatch_queue_create("com.kwai.gamesdk.assetDownload", attr);
    
    [self addSubButton:@"开始下载" frame:CGRectMake(15, 400,  200, 30) selector:@selector(startDownload)];
    [self addSubButton:@"全部暂停" frame:CGRectMake(15, 400,  200, 30) selector:@selector(pauseAll)];
    [self addSubButton:@"同步获取资源" frame:CGRectMake(15, 400,  200, 30) selector:@selector(getAsset)];
    [self addSubButton:@"同步获取资源1" frame:CGRectMake(15, 400,  200, 30) selector:@selector(getAsset1)];
    [self addSubButton:@"同步获取资源2" frame:CGRectMake(15, 400,  200, 30) selector:@selector(getAsset2)];
    
    
    [self addSubButton:@"异步获取资源" frame:CGRectMake(15, 400,  200, 30) selector:@selector(getAssetAsync)];
    [self addSubButton:@"异步获取资源3" frame:CGRectMake(15, 400,  200, 30) selector:@selector(getAssetAsync3)];
    [self addSubButton:@"异步获取资源4" frame:CGRectMake(15, 400,  200, 30) selector:@selector(getAssetAsync4)];
    
    
}

- (void)startDownload{
    
}

- (void)pauseAll{
    
}

- (void)getAsset{
    NSString *path = @"var/mobile/xxx/xxxx/test.mp4";
    dispatch_async(self.queue, ^{
        NSString *targetPath = [KwaiGameSDK getDownloadAssetPath:path];
        NSLog(@"😀😀😀😀😀😀:%@",targetPath);
    });
}
- (void)getAsset1{
    NSString *path = @"var/mobile/xxx/xxxx/test1.mp4";
    dispatch_async(self.queue, ^{
        NSString *targetPath = [KwaiGameSDK getDownloadAssetPath:path];
        NSLog(@"😀😀😀😀😀😀:%@",targetPath);
    });
}
- (void)getAsset2{
    NSString *path = @"var/mobile/xxx/xxxx/scene/test2.mp4";
    dispatch_async(self.queue, ^{
        NSString *targetPath = [KwaiGameSDK getDownloadAssetPath:path];
        NSLog(@"😀😀😀😀😀😀:%@",targetPath);
    });
}

- (void)getAssetAsync{
    NSString *path = @"var/mobile/xxx/xxxx/test.mp4";
    [KwaiGameSDK getDownloadAssetPathAsync:path complete:^(NSString * _Nonnull path, NSError * _Nonnull error) {
        NSLog(@"😀😀😀😀😀😀:%@,error:%@",path,error);
    }];
}
- (void)getAssetAsync3{
    NSString *path = @"var/mobile/xxx/xxxx/sub/test3.mp4";
    [KwaiGameSDK getDownloadAssetPathAsync:path complete:^(NSString * _Nonnull path, NSError * _Nonnull error) {
        NSLog(@"😀😀😀😀😀😀:%@,error:%@",path,error);
    }];
}
- (void)getAssetAsync4{
    NSString *path = @"var/mobile/xxx/xxxx/sub/test4.mp4";
    [KwaiGameSDK getDownloadAssetPathAsync:path complete:^(NSString * _Nonnull path, NSError * _Nonnull error) {
        NSLog(@"😀😀😀😀😀😀:%@,error:%@",path,error);
    }];
}


@end
