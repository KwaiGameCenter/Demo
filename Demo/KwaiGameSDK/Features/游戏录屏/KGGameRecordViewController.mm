//
//  KGGameRecordViewController.m
//  GameRecorder
//
//  Created by 刘玮 on 2019/4/20.
//  Copyright © 2019 KwaiGame. All rights reserved.
//

#import "KGGameRecordViewController.h"
#import "UIView+Toast.h"
#import "DataUtil.h"
#import <KwaiGameSDK-VideoShare/KwaiGameRecorderShare.h>
#import <KwaiGameSDK-GameRecord/KwaiGameRecorder.h>
#import <KwaiGameSDK-GameCapture/KwaiGameRecorderAryaEncoder.h>
#import <Lottie/LOTAnimationView.h>

#define GR_RUN_IN_MAIN_THREAD_START dispatch_async(dispatch_get_main_queue(), ^{
#define GR_RUN_IN_MAIN_THREAD_END });

#define TOAST(message) [[UIApplication sharedApplication].keyWindow makeToast: message];
#define TOAST_TOP(message) [[UIApplication sharedApplication].keyWindow makeToast: message duration: [CSToastManager defaultDuration] position: CSToastPositionTop];

@interface RecordViewController: UIViewController

@property (nonatomic, copy) void (^ _Nullable didCloseController)(void (^complete)());
@property (nonatomic, assign) BOOL landscape;
@property (nonatomic, strong) LOTAnimationView *animationView;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: self.animationView];
    self.animationView.frame = self.view.bounds;
    self.animationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.animationView play];
    [self.view addSubview: self.backButton];
    self.backButton.frame = self.view.bounds;
    self.backButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    if (self.landscape) {
        NSNumber *value = [NSNumber numberWithInt: UIDeviceOrientationLandscapeLeft];
        [[UIDevice currentDevice]setValue: value forKey: @"orientation"];
    } else {
        NSNumber *value = [NSNumber numberWithInt: UIDeviceOrientationPortrait];
        [[UIDevice currentDevice]setValue: value forKey: @"orientation"];
    }
    TOAST_TOP(@"点击任意位置结束录制");
}

- (LOTAnimationView *)animationView {
    if (_animationView == nil) {
        _animationView = [LOTAnimationView animationNamed: [DataUtil animationName]];
        _animationView.contentMode = UIViewContentModeScaleAspectFit;
        _animationView.loopAnimation = YES;
    }
    return _animationView;
}

- (UIButton *)backButton {
    if (_backButton == nil) {
        _backButton = [[UIButton alloc] init];
        [_backButton addTarget: self action: @selector(touchBackButton:) forControlEvents: UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (void)touchBackButton: (id)sender {
    if (self.didCloseController) {
        self.didCloseController(^{
            [self dismissViewControllerAnimated: YES completion: nil];
        });
    } else {
        [self dismissViewControllerAnimated: YES completion: nil];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([KGUtil checkLandscape]) {
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)dealloc {
    
}

@end

@interface KGGameRecordViewController ()

@property (nonatomic, weak) IBOutlet UILabel *supportKwaiShareLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *qualitySegmentedControl;
@property (nonatomic, weak) IBOutlet UISegmentedControl *audioSegmentedControl;
@property (nonatomic, strong) IBOutlet UISwitch *orientationSwitch;
@property (nonatomic, copy) NSString *shareVideoPath;
@property (nonatomic, copy) NSURL *shareVideoAssetURL;

@end

@implementation KGGameRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[KwaiGameRecorderShare defaultShare] checkShare: KGShareAction_KwaiPreprocess]) {
        self.supportKwaiShareLabel.textColor = [UIColor greenColor];
        self.supportKwaiShareLabel.text = @"支持";
    } else {
        self.supportKwaiShareLabel.textColor = [UIColor redColor];
        self.supportKwaiShareLabel.text = @"不支持";
    }
    self.shareVideoPath = [DataUtil testVideo];
    self.shareVideoAssetURL = nil;
    [KwaiGameRecorder defaultRecorder].recordException = ^(NSError * _Nonnull error) {
        GR_RUN_IN_MAIN_THREAD_START
        TOAST(([NSString stringWithFormat: @"录制失败: %@", error]));
        GR_RUN_IN_MAIN_THREAD_END
    };
}

- (IBAction)startRecord: (id)sender {
    [self startAnimation: self.orientationSwitch.isOn completion: ^(UIViewController *controller) {
        KwaiGameRecorderOption *option = [[KwaiGameRecorderOption alloc] init];
        option.encodeClass = KwaiGameRecorderAryaEncoder.class;
        if (self.qualitySegmentedControl.selectedSegmentIndex == 0) {
            option.videoQuality = KGRecorderQuality_Super;
        } else if (self.qualitySegmentedControl.selectedSegmentIndex == 1) {
            option.videoQuality = KGRecorderQuality_High;
        } else {
            option.videoQuality = KGRecorderQuality_Normal;
        }
        option.captureFps = 24;
        option.enableMic = self.audioSegmentedControl.selectedSegmentIndex == 1;
        option.enableExternalAudio = self.audioSegmentedControl.selectedSegmentIndex == 0;
        if (option.enableExternalAudio) {
            option.audioSampleRate = 44100;
            option.audioChannelNums = 1;
        }
        
        NSArray *documentArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [documentArray firstObject];
        NSString *videoPath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/tmp%ld.mp4", (long)[[NSDate date] timeIntervalSince1970]]];
        if ([[NSFileManager defaultManager] fileExistsAtPath: videoPath]) {
            [[NSFileManager defaultManager] removeItemAtPath: videoPath error: nil];
        }
        [[KwaiGameRecorder defaultRecorder] startRecord: videoPath
                                            captureView: controller.view
                                                 option: option
                                             completion: ^(NSError * _Nonnull error) {
                                                 GR_RUN_IN_MAIN_THREAD_START
                                                 if (error) {
                                                     if (error.code == KGRecorderError_NeedRecordAuthority) {
                                                         TOAST(@"您需要开启录音权限");
                                                     } else {
                                                         TOAST(([NSString stringWithFormat: @"录制失败: %@", error]));
                                                     }
                                                     return;
                                                 }
                                                 TOAST(@"开始录制");
                                                 if (option.enableExternalAudio) {
                                                     // 无法播放
                                                 }
                                                 GR_RUN_IN_MAIN_THREAD_END
                                             }];
    }];
}

- (UIViewController *)startAnimation: (BOOL)landscape completion: (void (^ __nullable)(UIViewController *controller))completion {
    RecordViewController *controller = [[RecordViewController alloc] init];
    controller.landscape = landscape;
    controller.didCloseController = ^(void (^complete)(void)) {
        [[KwaiGameRecorder defaultRecorder] stopRecord: ^(NSError *error, NSString *path) {
            // 收到这个回调，且success == true，意味着可以分享
            if (error == nil) {
                self.shareVideoPath = path;
                self.shareVideoAssetURL = nil;
                GR_RUN_IN_MAIN_THREAD_START
                TOAST(@"录制成功，点击分享");
                if (complete) complete();
                GR_RUN_IN_MAIN_THREAD_END
            } else {
                GR_RUN_IN_MAIN_THREAD_START
                TOAST(@"录制失败");
                if (complete) complete();
                GR_RUN_IN_MAIN_THREAD_END
            }
        }];
    };
    controller.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController: controller animated: YES completion: ^{
        if (completion) {
            completion(controller);
        }
    }];
    return controller;
}

#pragma mark - EZAudioFileDelegate

- (uint8_t *)getSamplesWaveData: (float *)samples samplesCount: (int)samplesCount numberOfChannels: (int)numberOfChannels {
    uint8_t *pcm = new uint8_t[samplesCount * 2];
    int sampleIndex = 0,
    pcmIndex = 0;
    
    while (sampleIndex < samplesCount)
    {
#define SATURATION16(i32) ((short)((i32 > 32767)? 32767 : (i32 < -32768)? -32768 : i32))
        short outsample = SATURATION16((int)(samples[sampleIndex] * 32768));
        pcm[pcmIndex] = (uint8_t)(outsample & 0xff);
        pcm[pcmIndex + 1] = (uint8_t)((outsample >> 8) & 0xff);
        
        sampleIndex += 1;
        pcmIndex += 2;
    }
    
    return pcm;
}

extern void OutputRawPCM(void *floatBuffer, int size, int sampleSize, NSString *filename) {
    NSArray *documentArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [documentArray firstObject];
    NSString *pcmPath = [documentPath stringByAppendingString:filename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:pcmPath]) {
        [[NSFileManager defaultManager] createFileAtPath: pcmPath contents: nil attributes: nil];
    }
    NSData *data = [NSData dataWithBytes: floatBuffer length: size * sampleSize];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath: pcmPath];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData: data];
    [fileHandle closeFile];
}

- (IBAction)shareToKwaiEditor: (id)sender {
    if (![[KwaiGameRecorderShare defaultShare] checkShare: KGShareAction_KwaiPreprocess]) {
        TOAST(@"未安装快手，或者当前快手版本不支持该功能");
        return;
    }
    [self saveToPhotoLibrary: ^(NSError *error, NSURL *assetURL) {
        if (error) {
            GR_RUN_IN_MAIN_THREAD_START
            TOAST(([NSString stringWithFormat: @"分享失败: %@", error]));
            GR_RUN_IN_MAIN_THREAD_END
            return;
        }
        [[KwaiGameRecorderShare defaultShare] share: assetURL
                                               tags: @[@"KwaiGameSDK", @"Test"]
                                             action: KGShareAction_KwaiPreprocess
                                         completion: ^(NSError * error) {
                                             if (error && error.code != 1) {    // 1 表示分享成功
                                                 if (error.code == KGShareError_VideoNotExists) {
                                                     self.shareVideoAssetURL = nil;
                                                 }
                                                 GR_RUN_IN_MAIN_THREAD_START
                                                 TOAST(([NSString stringWithFormat: @"分享失败: %@", error]));
                                                 GR_RUN_IN_MAIN_THREAD_END
                                                 return;
                                             }
                                             TOAST(@"分享成功");
                                         }];
    }];
}

- (IBAction)shareToKwaiPublish: (id)sender {
    [[KwaiGameRecorder defaultRecorder] postVideo:@"拍摄了精彩游戏视频" completion:^(BOOL success) {
        if (success) {
            TOAST(@"跳转成功");
        } else {
            TOAST(@"请安装快手");
        }
    }];
}

- (IBAction)save :(id)sender {
    [self saveToPhotoLibrary: ^(NSError *error, NSURL *assetURL) {
        if (error) {
            if (error.code == KGShareError_VideoNotExists) {
                self.shareVideoAssetURL = nil;
            }
            GR_RUN_IN_MAIN_THREAD_START
            TOAST(([NSString stringWithFormat: @"保存失败: %@", error]));
            GR_RUN_IN_MAIN_THREAD_END
        } else {
            GR_RUN_IN_MAIN_THREAD_START
            TOAST(@"保存成功");
            GR_RUN_IN_MAIN_THREAD_END
        }
    }];
}

- (void)saveToPhotoLibrary: (void (^)(NSError *error, NSURL *assetURL))completion {
    if (self.shareVideoAssetURL != nil) {
        if (completion) {
            completion(nil, self.shareVideoAssetURL);
        }
        return;
    }
    [[KwaiGameRecorderShare defaultShare] save: self.shareVideoPath
                                    completion: ^(NSError * _Nonnull error, NSURL * _Nonnull assetURL) {
                                        if (error) {
                                            if (completion) {
                                                completion(error, nil);
                                            }
                                            return;
                                        }
                                        self.shareVideoAssetURL = assetURL;
                                        if (completion) {
                                            completion(nil, self.shareVideoAssetURL);
                                        }
                                    }];
}

- (IBAction)shareToAppleEditor: (id)sender {
    [[KwaiGameRecorderShare defaultShare] shareByApple: self.shareVideoPath
                                                  view: self.view
                                            completion: ^(NSError * error) {
                                                if (error) {
                                                    GR_RUN_IN_MAIN_THREAD_START
                                                    TOAST(([NSString stringWithFormat: @"分享失败: %@", error]));
                                                    GR_RUN_IN_MAIN_THREAD_END
                                                    return;
                                                }
                                                TOAST(@"分享成功");
                                            }];
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
