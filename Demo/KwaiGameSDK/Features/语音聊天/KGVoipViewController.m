//
//  KGVoipViewController.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/12/3.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "KGVoipViewController.h"
#import "UIViewController+DemoSupport.h"
#import <KwaiGameSDK-Voip/KwaiGameSDK+Voip.h>
#import <KwaiGameSDK-Voip/KwaiGameVoip.h>
#import <KwaiGameSDK/KwaiGameSDK.h>
#import "KGUtil.h"
#import "KGTokenHelper.h"

@interface KGVoipViewController ()<UITextFieldDelegate, KwaiGameVoipDelegate>
@property (nonatomic, strong) UIButton *muteMicBtn;
@property (nonatomic, strong) UIButton *muteSpeakerBtn;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) UILabel *volumeLabel;
@property (nonatomic, strong) UILabel *speakerLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *activeSpeakersLabel;
@end

@implementation KGVoipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.uid = [KGUtil util].uid;
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"结束" style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    self.navigationItem.leftBarButtonItem = newBackButton;
    
    self.textField = [[UITextField alloc] init];
    self.textField.backgroundColor = [UIColor grayColor];
    self.textField.placeholder = @"不填则自动生成一个room id";
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.delegate = self;
    [self addSubView:self.textField frame:CGRectMake(0, 80, 200, 40)];
    
    [self addSubButton:@"进入房间" frame:CGRectMake(0, 130, 200, 30) selector:@selector(enterroom)];
    [self addSubButton:@"退出房间" frame:CGRectMake(0, 190, 200, 30) selector:@selector(exitroom)];
    self.muteMicBtn = [self addSubButton:@"关麦：YES" frame:CGRectMake(0, 250, 200, 30) selector:@selector(mutemic)];
    self.muteSpeakerBtn = [self addSubButton:@"关喇叭：YES" frame:CGRectMake(0, 310, 200, 30) selector:@selector(mutespeaker)];
    self.activeSpeakersLabel = [self addSubLabel:@"" frame:CGRectMake(0, 370, 200, 30)];
    [self addSubButton:@"在麦的人" frame:CGRectMake(0, 430, 200, 30) selector:@selector(onmicspeaker)];
    self.volumeLabel = [self addSubLabel:@"我的音量" frame:CGRectMake(0, 490, 100, 30)];
    [self addSubButton:@"显示UID" frame:CGRectMake(0, 550, 100, 30) selector:@selector(showuid)];
    self.speakerLabel = [self addSubLabel:@"" frame:CGRectMake(0, 610, 300, 30)];
}

- (void)goback {
    if ([[KwaiGameSDK sharedSDK] voip].calling) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否退出当前语音聊天?"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"关闭并退出"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
            [self exitroom];
            [self toast:@"退出语音聊天室"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:doneAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showuid {
    [self toast:self.uid?:@"空"];
}

- (void)enterroom {
    if ([[KwaiGameSDK sharedSDK] voip].calling) {
        [self toast:@"已经在房间中"];
        return;
    }
    
    if (self.textField.text.length > 0) {
        [self.textField resignFirstResponder];
        [self _enterroom:self.textField.text];
        return;
    }
    
    NSString *roomId = [self return16LetterAndNumber];
    [self _enterroom:roomId];
}

- (NSString *)return16LetterAndNumber{
    NSString * strAll = @"23456789abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ";
    NSMutableString * result = [[NSMutableString alloc] init];
    for (int i = 0; i < 8; i++) {
        NSInteger index = arc4random() % (strAll.length-1);
        char tempStr = [strAll characterAtIndex:index];
        [result appendFormat:@"%c", tempStr];
    }
    return [result copy];
}

- (void)_enterroom:(NSString *)roomid {
    KwaiGameVoipParams *params = [KwaiGameVoipParams new];
    params.mUserId = self.uid;
    params.mRoomId = roomid;
    params.mAutoOpenMic = YES;
    params.mAutoOpenSpeaker = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textField.text = roomid;
    });
    [[[KwaiGameSDK sharedSDK] voip] enterRoom:params delegate:self];
}

- (void)exitroom {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (![[KwaiGameSDK sharedSDK] voip].calling) {
        [self toast:@"不在房间里"];
        return;
    }
    
    [[[KwaiGameSDK sharedSDK] voip] exitRoom];
}

- (void)mutemic {
    if (![[KwaiGameSDK sharedSDK] voip].calling) {
        [self toast:@"不在房间里"];
        return;
    }
    
    [[KwaiGameSDK sharedSDK] voip].muteMic = ![[KwaiGameSDK sharedSDK] voip].muteMic;
    [self.muteMicBtn setTitle:[[KwaiGameSDK sharedSDK] voip].muteMic ? @"关麦：YES" : @"关麦：NO" forState:UIControlStateNormal];
}

- (void)mutespeaker {
    if (![[KwaiGameSDK sharedSDK] voip].calling) {
        [self toast:@"不在房间里"];
        return;
    }
    
    [[KwaiGameSDK sharedSDK] voip].muteSpeaker = ![[KwaiGameSDK sharedSDK] voip].muteSpeaker;
    [self.muteSpeakerBtn setTitle:[[KwaiGameSDK sharedSDK] voip].muteSpeaker ? @"关喇叭：YES" : @"关喇叭：NO" forState:UIControlStateNormal];
}


- (void)onmicspeaker {
    if (![[KwaiGameSDK sharedSDK] voip].calling) {
        [self toast:@"不在房间里"];
        return;
    }
    
    NSArray *speakers = [[[KwaiGameSDK sharedSDK] voip] getActiveSpeaker];
    [self toast:[NSString stringWithFormat:@"%@", speakers?:@"没人"]];
}

- (void)getvolume {
    int volume = (int)([[[KwaiGameSDK sharedSDK] voip] getMicVolume:self.uid]);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.volumeLabel.text = [NSString stringWithFormat:@"%@", @(volume)];
    });
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}

#pragma mark - KwaiGameVoipDelegate
- (void)didRoomDisabled {
    [[[KwaiGameSDK sharedSDK] voip] exitRoom];
}

- (void)didEnterRoom:(NSError *)error {
    if (error) {
        if (error.code == kKwaiGameVoipErrorCodeLinkDisconnect) {
            [self toast:@"需要建立长链接"];
        } else {
            [self toast:error.localizedDescription];
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self toast:@"进入房间成功"];
            [self.muteMicBtn setTitle:[[KwaiGameSDK sharedSDK] voip].muteMic ? @"关麦：YES" : @"关麦：NO" forState:UIControlStateNormal];
            [self.muteSpeakerBtn setTitle:[[KwaiGameSDK sharedSDK] voip].muteSpeaker ? @"关喇叭：YES" : @"关喇叭：NO" forState:UIControlStateNormal];
        });
        
        self.timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(getvolume) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)didExitRoom {
    [self toast:@"已经退出房间"];
}

- (void)didNetworkNotGood {
    [self toast:@"网好像不太好"];
}

- (void)didActiveSpeakerChange {
    NSArray *speakers = [[[KwaiGameSDK sharedSDK] voip] getActiveSpeaker];
    self.activeSpeakersLabel.text = [NSString stringWithFormat:@"%@", speakers?[speakers componentsJoinedByString:@","]:@"null"];
}

@end
