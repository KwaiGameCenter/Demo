//
//  KGScanViewController.m
//  KwaiGameSDK_Example
//
//  Created by xingguo sun on 2021/2/3.
//  Copyright © 2021 mookhf. All rights reserved.
//

#import "KGScanViewController.h"
#import "UIViewController+DemoSupport.h"
#import <KwaiGameSDK-QRScan/KwaiGameSDK+ScanQrcode.h>

@interface KGScanViewController ()
@property (nonatomic, strong) UIButton *scanBtn;
@end

@implementation KGScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.scanBtn = [self addSubButton:@"扫码" frame:CGRectMake(0, 80, 100, 50) selector:@selector(startScan)];
    
    // Do any additional setup after loading the view.
}

- (void)startScan {
    [[KwaiGameSDK sharedSDK] scanQRCode:^(KGScanResult scanResult, NSString *message) {
        switch (scanResult) {
            case KGScanResult_Success:
                [self toast:@"scan success"];
                break;
            case KGScanResult_Cancel:
                [self toast:@"scan cancel"];
                break;
            case KGScanResult_ErrorQRCode:
                [self toast:@"error qrcode"];
                break;
            case KGScanResult_OtherError:
                [self toast:@"other error"];
                break;
            default:
                break;
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
