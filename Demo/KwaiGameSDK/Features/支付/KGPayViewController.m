//
//  KGPayViewController.m
//  KwaiGameSDK_Example
//
//  Created by 刘玮 on 2019/5/14.
//  Copyright © 2019 mookhf. All rights reserved.
//

#import "KGPayViewController.h"
#import "UIView+Toast.h"
#import "KGPayHelper.h"
#import "NSError+KwaiBase.h"
#import <KwaiGameSDK-Pay/KwaiGamePay.h>
#import <KwaiGameSDK-Pay/KwaiGameProductDetail.h>

#define GR_RUN_IN_MAIN_THREAD_START dispatch_async(dispatch_get_main_queue(), ^{
#define GR_RUN_IN_MAIN_THREAD_END });

#define TOAST(message) [self.view makeToast: message];
// bad way
#define SHOW_TOAST(message) [self.view makeToastActivity:CSToastPositionCenter];
#define HIDDEN_TOAST() [self.view hideToastActivity];

@interface KGPayViewController()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray<KGProductItem *> *products;
@property (nonatomic , assign) BOOL showPayT;

@end

@implementation KGPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"续费" style:UIBarButtonItemStylePlain target:self action:@selector(onTouchSubscribeHistory:)];
    
    UIBarButtonItem *anotherButton1 = [[UIBarButtonItem alloc] initWithTitle:@"展示" style:UIBarButtonItemStylePlain target:self action:@selector(showPayToast:)];
    
    UIBarButtonItem *anotherButton2 = [[UIBarButtonItem alloc] initWithTitle:@"查询商品信息" style:UIBarButtonItemStylePlain target:self action:@selector(getProductsInfo)];
    
    self.navigationItem.rightBarButtonItems = @[anotherButton, anotherButton1, anotherButton2];
    
    self.showPayT = YES;
    [[KwaiGamePay pay]payResultToasetShow:YES];
    
    [self.tableView registerClass: UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.segmentedControl.selectedSegmentIndex = (int) [KGPayHelper help].humanErrorType;
    [self.segmentedControl addTarget: self action: @selector(didSegmentedControlChanged) forControlEvents: UIControlEventValueChanged];
    // 手动触发补单
    GR_RUN_IN_MAIN_THREAD_START
    if ([KwaiGamePay pay].hasIncompleteOrders) {
        SHOW_TOAST(@"正在补单");
        [[KwaiGamePay pay] syncIncompleteOrders: ^(NSError * _Nonnull error, KwaiGamePayment * _Nonnull payment) {
            GR_RUN_IN_MAIN_THREAD_START
            if (error) {
                TOAST(([NSString stringWithFormat: @"%@(%ld)", (error.errorMsg ? error.errorMsg : @""), (long)error.code]));
            }
            GR_RUN_IN_MAIN_THREAD_END
        } completion: ^(NSError * _Nonnull error) {
            GR_RUN_IN_MAIN_THREAD_START
            HIDDEN_TOAST();
            if (error.code == KwaiGamePayError_AlreadyCompleteOrders) {
                TOAST(@"正在补单，请稍后重试...");
            } else {
                TOAST(@"补单结束");
            }
            GR_RUN_IN_MAIN_THREAD_END
        }];
    }
    self.products = [[KGPayHelper help] fetchProductList: ^(NSError * _Nonnull error, NSArray<KGProductItem *> * _Nonnull products) {
        self.products = products;
        GR_RUN_IN_MAIN_THREAD_START
        [self.tableView reloadData];
        GR_RUN_IN_MAIN_THREAD_END
    }];
    [self.tableView reloadData];
    GR_RUN_IN_MAIN_THREAD_END
}

- (void)showPayToast:(UIBarButtonItem *)btn {
    if (!self.showPayT) {
        btn.title = @"展示";
    } else {
        btn.title = @"隐藏";
    }
    self.showPayT = !self.showPayT;
    [[KwaiGamePay pay]payResultToasetShow:self.showPayT];
}

- (void)getProductsInfo {
    NSMutableArray *products = [[NSMutableArray alloc] init];
    [self.products enumerateObjectsUsingBlock:^(KGProductItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [products addObject:obj.productId];
    }];
    
    [[KwaiGamePay pay] getDetileOfProducts:products WithExtendJson:@"" completion:^(NSError * _Nonnull error, NSArray<KwaiGameProductDetail *> * _Nonnull productDetails) {
        GR_RUN_IN_MAIN_THREAD_START
        if (!productDetails || productDetails.count==0){
            TOAST(@"没有相关信息");
        } else {
            TOAST(@"收到结果");
            NSMutableArray *details = [[NSMutableArray alloc] init];
            [productDetails enumerateObjectsUsingBlock:^(KwaiGameProductDetail * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [details addObject:[obj toJsonString]];
            }];
            TOAST([[details valueForKey:@"description"] componentsJoinedByString:@", "]);
        }
        GR_RUN_IN_MAIN_THREAD_END
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: NSStringFromClass(UITableViewCell.class)];
    KGProductItem *item = [self.products objectAtIndex: indexPath.row];
    if (item != nil) {
        [cell.textLabel setText: item.productName];
    } else {
        [cell.textLabel setText: @""];
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.products == nil) {
        return 0;
    }
    return self.products.count;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: true];
    KGProductItem *item = [self.products objectAtIndex: indexPath.row];
    if (item.payMode == KwaiPayMode_GameCoin) {
        [self selectGameCoin:item];
    } else if (item != nil) {
        [self selectNormal:item];
    }
}

- (void)didSegmentedControlChanged {
    [KGPayHelper help].humanErrorType = (KwaiPayHumanErrorType) self.segmentedControl.selectedSegmentIndex;
}

- (void)selectNormal:(KGProductItem *)item {
    KwaiGamePayment *payment = [[KwaiGamePayment alloc] init];
    payment.productId = item.productId;
    payment.payType = KwaiGamePayType_IAP;
    payment.monery = item.productValue;
    payment.currencyType = @"CNY";
    payment.extension = @"123123";
    SHOW_TOAST(@"购买物品");
    [[KwaiGamePay pay] pay: payment
                completion: ^(NSError *error) {
                    GR_RUN_IN_MAIN_THREAD_START
                    if (error) {
                        HIDDEN_TOAST();
                        if (error.code == KwaiGamePayError_NeedCert) {
                            TOAST(@"支付失败: 未完成实名认证");
                        } else if (error.code == KwaiGamePayError_UserCancel) {
                            TOAST(@"支付失败: 用户取消");
                        } else {
                            TOAST(([NSString stringWithFormat: @"支付失败: %@(%ld)", (error.errorMsg ? error.errorMsg : @""), (long)error.code]));
                        }
                        NSLog(@"支付失败：%@",error.errorMsg);
                        return;
                    }
                    HIDDEN_TOAST();
                    TOAST(@"支付成功");
                    GR_RUN_IN_MAIN_THREAD_END
    }];
}

- (void)selectGameCoin:(KGProductItem *)item {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"购买游戏币或者道具" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *amountTextField = alertController.textFields.firstObject;
        int amout = [amountTextField.text intValue];
        if (amout <= 0) {
            return ;
        }
        UITextField *typeTextField = alertController.textFields.lastObject;
        int type = [typeTextField.text intValue];
        NSDictionary *extension;
        if (type > 0) {
            NSTimeInterval period = 30 * 24 * 60 * 60;
            NSDictionary *goods = @{@"product_id": item.productId, @"product_num":@(amout), @"product_type":@(type), @"product_start_time":@((long long)([[NSDate date] timeIntervalSince1970] * 1000)), @"product_period":@((long long)(period * 1000)),};
            extension = @{@"ks_order_type":@"goods", @"ks_product_info":@[goods]};
        } else {
            extension = @{@"ks_order_type": @"currency", @"ks_amount": @(amout)};
        }
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:extension options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        KwaiGamePayment *payment = [[KwaiGamePayment alloc] init];
        payment.productId = item.productId;
        payment.payType = KwaiGamePayType_IAP;
        payment.monery = item.productValue;
        payment.currencyType = @"CNY";
        payment.extension = jsonString;
        SHOW_TOAST(@"购买物品");
        [[KwaiGamePay pay] pay: payment
                    completion: ^(NSError *error) {
                        GR_RUN_IN_MAIN_THREAD_START
                        if (error) {
                            HIDDEN_TOAST();
                            if (error.code == KwaiGamePayError_NeedCert) {
                                TOAST(@"支付失败: 未完成实名认证");
                            } else if (error.code == KwaiGamePayError_UserCancel) {
                                TOAST(@"支付失败: 用户取消");
                            } else {
                                TOAST(([NSString stringWithFormat: @"支付失败: %@(%ld)", (error.errorMsg ? error.errorMsg : @""), (long)error.code]));
                            }
                            NSLog(@"支付失败：%@",error.errorMsg);
                            return;
                        }
                        HIDDEN_TOAST();
                        TOAST(@"支付成功");
                        GR_RUN_IN_MAIN_THREAD_END
        }];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"游戏币或者道具数量";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"道具类型:1一次性2有效期3永久";
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)onTouchSubscribeHistory:(id)selector {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"操作" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:@"查询" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[KGPayHelper help] querySubscribe:^(NSError * _Nonnull error, NSDictionary * _Nonnull params) {
            GR_RUN_IN_MAIN_THREAD_START
            if (error) {
                TOAST(([NSString stringWithFormat: @"%@(%ld)", (error.errorMsg ? error.errorMsg : @""), (long)error.code]));
                return;
            }
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"续费信息"
                                                                                     message: jsonString
                                                                              preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            GR_RUN_IN_MAIN_THREAD_END
        }];
    }]];
//    [controller addAction:[UIAlertAction actionWithTitle:@"终止" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//
//    }]];


    [self presentViewController:controller animated:YES completion:nil];
}

@end
