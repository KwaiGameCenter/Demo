//
//  KGDownloadViewController.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/11/23.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "KGDownloadViewController.h"
#import "UIViewController+DemoSupport.h"
#import <KwaiGameSDK/KwaiGameSDK.h>
#import <KwaiGameSDK-Downloader/KwaiGameDownloader.h>
#import <KwaiGameSDK/KwaiGameSDK+Tools.h>
#import "KGAssetDownloaderViewController.h"

#define kDemoTestFileName @"test.zip"
#define kDemoUpdateDuration (0.2f)      // 1s

@interface KGDownloadViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *inputDownloadUrl;
@property (nonatomic, strong) UITextView *backupDownloadUrl;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, strong) UISegmentedControl *policyControl;

@property (nonatomic, strong) KwaiGameDownloader *downloader;
@property (nonatomic, strong) NSTimer *updateTimer;

@end

@implementation KGDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"asset" style:UIBarButtonItemStyleDone target:self action:@selector(assetDownload)];
    
    [self addSpliteLine:@"资源下载" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];
    
    self.inputDownloadUrl = [[UITextView alloc] init];
    self.inputDownloadUrl.backgroundColor = [UIColor lightGrayColor];
    self.inputDownloadUrl.text = @"https://static.yximgs.com/udata/pkg/GameSource-CDN/70MB.zip";
    self.inputDownloadUrl.returnKeyType = UIReturnKeyDone;
    self.inputDownloadUrl.delegate = self;
    [self addSubView:self.inputDownloadUrl frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 50)];
    [self addSubButton:@"开始下载" frame:CGRectMake(15, 400,  200, 30) selector:@selector(startDownload)];
    [self addSubButton:@"获取文件" frame:CGRectMake(15, 400,  200, 30) selector:@selector(getDownloadFile)];
    [self addSubButton:@"清除下载缓存" frame:CGRectMake(15, 400,  200, 30) selector:@selector(clearCache)];
    [self addSubButton:@"关闭HttpDns" frame:CGRectMake(15, 400,  200, 30) selector:@selector(turnOffHttpDns)];
    
    [self addSpliteLine:@"更多设置" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];
    [self addSubLabel:@"设置备用下载地址" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];
    self.backupDownloadUrl = [[UITextView alloc] init];
    self.backupDownloadUrl.backgroundColor = [UIColor lightGrayColor];
    self.backupDownloadUrl.text = @"https://tx-cdn-allin.game.kuaishou.com/s1/game-allin/CDNFolder/70MB.zip;https://static.yximgs.com/udata/pkg/GameSource-CDN/70MB-backup.zip";
    self.backupDownloadUrl.returnKeyType = UIReturnKeyDone;
    self.backupDownloadUrl.delegate = self;
    [self addSubView:self.backupDownloadUrl frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 50)];
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"默认",@"只在Wifi下下载",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(20.0, 70.0, 350.0, 30.0);
    segmentedControl.selectedSegmentIndex = 0;
    self.policyControl = segmentedControl;
    [self addSubView:self.policyControl frame:CGRectMake(20.0, 70.0, 350.0, 30.0)];
    
    self.textView = [[UITextView alloc] init];
    self.textView.backgroundColor = [UIColor blackColor];
    self.textView.textColor = [UIColor greenColor];
    self.textView.font = [UIFont boldSystemFontOfSize:15.0f];
    self.textView.editable = NO;
    [self addSubView:self.textView frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 400)];
    
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:kDemoUpdateDuration
                                                        target:self
                                                      selector:@selector(timeUpdate)
                                                      userInfo:nil
                                                       repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.updateTimer invalidate];
}

- (void)assetDownload{
    [self.navigationController pushViewController:[KGAssetDownloaderViewController new] animated:YES];
}

- (void)startDownload {
    NSString* filePath = [self downloadFilePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[KwaiGameSDK sharedSDK] log:@"文件已存在，先删除文件"];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    NSError *error;
    NSString *url = self.inputDownloadUrl.text;
    if (self.backupDownloadUrl.text.length > 0 || self.policyControl.selectedSegmentIndex != 0) {
        KwaiGameDownloadConfig *config = [[KwaiGameDownloadConfig alloc] init];
        config.url = url;
        config.filePath = filePath;
        if (self.backupDownloadUrl.text.length > 0) {
            NSArray *urls = [self.backupDownloadUrl.text componentsSeparatedByString:@";"];
            config.backupUrls = urls;
        }
        config.policy = (KwaiGameDownloadPolicy)self.policyControl.selectedSegmentIndex;
        self.downloader = [KwaiGameDownloader start:config
                                              error:&error];
    } else {
        self.downloader = [KwaiGameDownloader start:url
                                           filePath:filePath
                                              error:&error];
    }
    if (error) {
        [[KwaiGameSDK sharedSDK] log:@"启动下载失败:%@",error];
        [self.view toast:@"启动下载失败:%@",error];
        self.downloader = nil;
    } else {
        [[KwaiGameSDK sharedSDK] log:@"启动下载成功"];
        [self.view toast:@"启动下载成功"];
    }
}

- (void)getDownloadFile {
    if (self.downloader != nil && self.downloader.status != KwaiGameDownloadStatus_Done) {
        [self toast:@"下载未完成"];
    } else {
        NSString* filePath = [self downloadFilePath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [self toast:@"下载未完成"];
        } else {
            static UIDocumentInteractionController *documentController;
            documentController = [UIDocumentInteractionController interactionControllerWithURL: [NSURL fileURLWithPath:filePath]];
            [documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
        }
    }
}

- (void)clearCache {
    [KwaiGameDownloader clearCache];
    [self toast:@"清理成功"];
}

- (void)turnOffHttpDns {
    if ([KwaiGameDownloader respondsToSelector:@selector(turnOffHttpDns)]) {
        [KwaiGameDownloader performSelector:@selector(turnOffHttpDns)];
        [self toast:@"关闭HttpDns"];
    } else {
        [self toast:@"不支持该功能"];
    }
}

- (void)timeUpdate {
    if (!self.downloader) {
        return;
    }
    NSMutableString *temp = [[NSMutableString alloc] init];
    if (self.downloader.status == KwaiGameDownloadStatus_Failed) {
        [temp appendString:@"状态:下载失败"];
        if (self.downloader.error) {
            [temp appendFormat:@"\n错误原因:%@",self.downloader.error];
        }
        if (self.downloader.error.code == -1151 && self.alertController == nil) {
            // 磁盘空间不足时，应及时给出用户提示
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"磁盘空间不足"
                                                                                     message:@"资源下载失败，请确保拥有足够的磁盘空间，您可以打开[设置]->[通用]->[iPhone存储空间]进行相应操作"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.alertController = nil;
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
            self.alertController = alertController;
        }
        self.downloader = nil;
    } else if (self.downloader.status == KwaiGameDownloadStatus_Done) {
        __block NSString *filePath = self.downloader.config.filePath;
        self.downloader = nil;
        [temp appendString:@"状态:下载完成"];
        [temp appendFormat:@"\nMD5计算中..."];
        self.view.userInteractionEnabled = NO;
        [self.view showProgressToast];
        GLOBAL_RUN_IN_BACKGROUND_THREAD_START
        __block NSString *fileMd5 = [[KwaiGameSDK sharedSDK] bigFileMd5:filePath];
        GLOBAL_RUN_IN_MAIN_THREAD_START
        self.textView.text = [NSString stringWithFormat:@"状态:下载完成\n文件MD5:%@", fileMd5];
        [self.view hiddenProgressToast];
        self.view.userInteractionEnabled = YES;
        GLOBAL_RUN_IN_MAIN_THREAD_END
        GLOBAL_RUN_IN_BACKGROUND_THREAD_END
    } else if (self.downloader.status == KwaiGameDownloadStatus_Downloading) {
        [temp appendString:@"状态:下载中"];
        [temp appendFormat:@"\n下载进度:%.2f%%", self.downloader.progress * 100];
        [temp appendFormat:@"\n已经下载:%lldMB/%lldMB", self.downloader.receiveByte / 1024 / 1024, self.downloader.totalByte / 1024 / 1024];
        [temp appendFormat:@"\n下载速度:%.2fKB/s", self.downloader.speed / 1024];

    }
    self.textView.text = temp;
}

- (NSString *)downloadFilePath {
    NSString* cachePath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString* filePath = [[NSString alloc] initWithFormat:@"%@/kwaigamesdk/%@", cachePath, kDemoTestFileName];
    return filePath;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView: (UITextView *)textView shouldChangeTextInRange: (NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString: @"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
