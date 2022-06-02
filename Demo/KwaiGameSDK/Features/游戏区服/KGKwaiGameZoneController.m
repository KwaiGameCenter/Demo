//
//  KGKwaiGameZoneController.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/11/23.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "KGKwaiGameZoneController.h"
#import "KwaiBase.h"
#import <KwaiGameSDK/KwaiGameSDK+Gateway.h>

@interface KGKwaiGameZoneController ()

@property (nonatomic, strong) UIButton *zoneName;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, copy) NSString *zoneId;
@property (nonatomic, copy) NSMutableDictionary *serverListData;

@end

@implementation KGKwaiGameZoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSpliteLine:@"大区信息" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];
    self.zoneName = [self addSubButton:@"获取大区信息" frame:CGRectMake(0.0f, 0.0f, 250.0f, 30.0f) selector:@selector(getGameZone)];
    [self addSpliteLine:@"获取服务器列表" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];
    [self addSubButton:@"获取服务器列表" frame:CGRectMake(0.0f, 0.0f, 250.0f, 30.0f) selector:@selector(getServerList)];
    [self addSpliteLine:@"信息展示" frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 30)];
    
    self.textView = [[UITextView alloc] init];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.textColor = [UIColor blackColor];
    self.textView.font = [UIFont boldSystemFontOfSize:15.0f];
    self.textView.editable = NO;
    [self addSubView:self.textView frame:CGRectMake(15, 400, DemoUIScreenWidth - 30, 400)];
    
    DemoRunInMainThreadStart
    [self getGameZone];
    DemoRunInMainThreadEnd
}

- (void)getServerList {
    if (KWAI_IS_STR_NIL(self.zoneId)) {
        [self toast:@"请先获取大区后再获取服务器列表"];
        NSLog(@"获取服务器列表失败，请先获取大区后再获取服务器列表");
        return;
    }
    [[KwaiGameSDK sharedSDK] getServerList:self.zoneId completion:^(NSError * _Nonnull error, GatewayServerListData * _Nonnull serverListInfo) {
        if (error) {
            NSString* errorMsg = [NSString stringWithFormat:@"获取服务器列表信息数据错误 errorcode = %ld messge = %@",error.code,error.userInfo?error.userInfo:@"获取服务器列表信息数据错误"];
            [self toast:errorMsg];
            return;
        }
        if (serverListInfo != nil) {
            self.textView.text = serverListInfo.description;
        }
    }];
}

- (void)getGameZone {
    [[KwaiGameSDK sharedSDK] getGameZone:^(NSError * _Nonnull error, NSString * _Nonnull zoneId, NSString * _Nonnull zoneName, ZoneInfo * _Nonnull zoneInfo) {
        if (error) {
            NSString* errorMsg = [NSString stringWithFormat:@"获取大区信息数据错误  errorcode = %ld messge = %@",error.code,error.userInfo?error.userInfo:@"获取大区信息数据错误"];
            [self toast:errorMsg];
            return;
        }
        self.zoneId = zoneId;
        [self.zoneName setTitle:[NSString stringWithFormat:@"%@ %@",zoneName,zoneId] forState:0];
        if (zoneInfo != nil) {
            self.textView.text = zoneInfo.description;
        }
    }];
}

@end
