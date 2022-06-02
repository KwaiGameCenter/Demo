//
//  KGShareViewController.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2018/11/23.
//  Copyright © 2018 mookhf. All rights reserved.
//

#import "KGShareViewController.h"
#import <KwaiGameSDK-OpenPlatform/KwaiGameShareObject.h>
#import <KwaiGameSDK-OpenPlatform/KwaiGameSDK+OpenPlatform.h>
#import <KwaiGameSDK/KwaiGameSDK.h>
#import "UIViewController+DemoSupport.h"
#import "MBProgressHUD.h"
#import <KwaiGameSDK-Relation/KwaiGameRelation.h>
#import <KwaiGameSDK-Relation/KSApiObject.h>

@interface KGShareViewController ()<KwaiGameRelationDelegate>

@property (nonatomic, strong) UISegmentedControl *typeCtl;

@end

@implementation KGShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.typeCtl = [self addSubSegmentedControl:[[NSArray alloc]initWithObjects:@"本地图片",@"网络图片",@"链接",nil] frame:CGRectMake(20.0, 70.0, 250.0, 50.0) selector:nil];
    [self addSubButton:@"分享到微博" frame:CGRectMake(0, 140, 200, 40) selector:@selector(shareToWeibo)];
    [self addSubButton:@"分享到QQ" frame:CGRectMake(0, 190, 200, 40) selector:@selector(shareToQQ)];
    [self addSubButton:@"分享到QQ空间" frame:CGRectMake(0, 240, 200, 40) selector:@selector(shareToQzone)];
    [self addSubButton:@"分享到微信好友" frame:CGRectMake(0, 290, 200, 40) selector:@selector(shareToWechat)];
    [self addSubButton:@"分享到朋友圈" frame:CGRectMake(0, 340, 200, 40) selector:@selector(shareToFriend)];
    [self addSubButton:@"分享到快手私信" frame:CGRectMake(0, 390, 200, 40) selector:@selector(shareToKwaiMessage)];
    [KwaiGameRelation relation].delegate = self;
}

- (void)shareToWeibo {
    [self shareToPlatform:KwaiGameOpenPlatform_SinaWeibo];
}

- (void)shareToQQ {
    [self shareToPlatform:KwaiGameOpenPlatform_QQSession];
}

- (void)shareToQzone {
    [self shareToPlatform:KwaiGameOpenPlatform_QZone];
}

- (void)shareToWechat {
    [self shareToPlatform:KwaiGameOpenPlatform_WechatSession];
}

- (void)shareToFriend {
    [self shareToPlatform:KwaiGameOpenPlatform_WechatTimeline];
}

- (void)shareToKwaiMessage {
    [[KwaiGameRelation relation] transformGameIds: @[[KwaiGameSDK sharedSDK].account.uid]
                                       completion: ^(NSError * error, NSDictionary<NSString *,NSString *> * openIdsMap) {
                                           
                                           KSShareMessageRequest* req = [[KSShareMessageRequest alloc] init];
                                           req.openID = openIdsMap[[KwaiGameSDK sharedSDK].account.uid];
                                           
                                           KSShareWebPageObject* shareObj = [KSShareWebPageObject new] ;
                                           shareObj.title = [NSString stringWithUTF8String:"title"];
                                           shareObj.desc = [NSString stringWithUTF8String:"des"];
                                           shareObj.linkURL = [NSString stringWithUTF8String:"https://www.baidu.com"];
                                           
                                           NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
                                           NSString *path = [resourcePath stringByAppendingPathComponent:[NSString stringWithUTF8String:"Data/Raw/shareIcon/dish.png"]];
                                           shareObj.thumbImage = [NSData dataWithContentsOfFile:path];
                                           
                                           NSLog(@"imge data %@", shareObj.thumbImage);
                                           
                                           req.shareObject = shareObj;
                                           [[KwaiGameRelation relation] sendRequest: req];
                                       }];
}

- (KwaiGameShareObject *)shareObject {
    if (self.typeCtl.selectedSegmentIndex == 0) {
        KwaiGameImageShareObject *object = [KwaiGameImageShareObject new];
        object.image = [UIImage imageNamed:@"aaa"];
        return object;
    }
    if (self.typeCtl.selectedSegmentIndex == 1) {
        KwaiGameImageShareObject *object = [KwaiGameImageShareObject new];
        object.imageUrl = @"http://b.hiphotos.baidu.com/image/pic/item/0ff41bd5ad6eddc4802878ba34dbb6fd536633a0.jpg";
        return object;
    }
    if (self.typeCtl.selectedSegmentIndex == 2) {
        KwaiGameWebpageShareObject *object = [KwaiGameWebpageShareObject new];
        object.title = @"分享试试";
        object.desc = @"分罚恶风违法为我为购物个围观而过而过热过额尔个人而热赫然赫然赫然好而赫然和";
        object.thumbImageUrl = @"http://b.hiphotos.baidu.com/image/pic/item/0ff41bd5ad6eddc4802878ba34dbb6fd536633a0.jpg";
        object.webpageUrl = @"www.kuaishou.com";
        return object;
    }
    return nil;
}

- (void)shareToPlatform:(KwaiGameOpenPlatformType)platform {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabelText = @"网络图片加载中";
    [[[KwaiGameSDK sharedSDK] sharer] shareToPlatform:platform shareObject:[self shareObject] download:^{
        [hud hide:YES];
    } completion:^(NSError *error) {
        if (error) {
            [self toast:error.localizedDescription];
        } else {
            [self toast:@"分享成功"];
        }
    }];
}

- (void)didReceiveResponse:(__kindof KSBaseResponse *)response {
    if (response.error.code == 1) {
        [self toast:@"分享成功"];
    } else {
        [self toast:@"分享失败"];
    }
}


@end
