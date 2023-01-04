//
//  KGPerformanceReportViewController.m
//  KwaiGameSDK_Example
//
//  Created by yan long on 2022/9/16.
//  Copyright © 2022 mookhf. All rights reserved.
//

#import "KGPerformanceReportViewController.h"
#import "KGPerformanceReportExpandInfoViewController.h"
#import <KwaiGameSDK/KwaiGameSDK.h>

@interface KGPerformanceReportViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSArray *itemTitles;
@property (nonatomic, copy) NSArray *sectionTitles;
@property (nonatomic, weak) UITextField *sceneNameInputTextField;
@property (nonatomic, weak) UITextField *targetFPSInputTextField;

@property (nonatomic, weak) UITextField *netDelayTimeInputTextField;
@property (nonatomic, weak) UITextField *netAddressInputTextField;
@property (nonatomic, weak) UITextField *netPortInputTextField;
@property (nonatomic, weak) UITextField *netPingTypeInputTextField;
@property (nonatomic, copy) NSString *sceneName;


@end

@implementation KGPerformanceReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置场景名" style:UIBarButtonItemStylePlain target:self action:@selector(setSceneName)];
    
    
    self.sectionTitles = @[@"场景加载",@"网络延迟",@"设置画质",@"设置目标帧率",@"自定义",@"crash"];
    self.itemTitles = @[@[@"场景开始",@"场景加载完成",@"场景推出"],@[@"游戏网络延迟上报"],@[@"very low",@"low",@"medium",@"hight",@"very hight",@"ultra"],@[@"设置目标帧率"],@[@"自定义"],@[@"模拟Crash"]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    
    
}

- (void)setSceneName {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"设置场景名称" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *text = self.sceneNameInputTextField.text;
        weakSelf.sceneName = text;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.navigationItem.title = text;
        });
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入场景名称";
        weakSelf.sceneNameInputTextField = textField;
    }];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)setTargetFPS {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"设置目标帧率" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *text = self.targetFPSInputTextField.text;
        [[KwaiGameSDK sharedSDK] reportGameTargetFPS:[text integerValue]];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输帧率";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        weakSelf.targetFPSInputTextField = textField;
    }];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)reportNetwork {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"设置网络参数" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger deleyTime = [self.netDelayTimeInputTextField.text integerValue];
        NSString *netAddress = self.netAddressInputTextField.text;
        NSInteger port = [self.netPortInputTextField.text integerValue];
        NSString *pingType = self.netPingTypeInputTextField.text;
        
        [[KwaiGameSDK sharedSDK] reportGameNetworkWithDelayTime:deleyTime netAddress:netAddress port:port pingType:pingType];
        
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入delayTime";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        weakSelf.netDelayTimeInputTextField = textField;

    }];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入netAddress";
        weakSelf.netAddressInputTextField = textField;
    }];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入port";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        weakSelf.netPortInputTextField = textField;
    }];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入pingType";
        weakSelf.netPingTypeInputTextField = textField;
    }];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.itemTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *items = self.itemTitles[section];
    return  items.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sectionTitles[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    NSArray *items = self.itemTitles[indexPath.section];
    cell.textLabel.text = items[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0){
        
        if (self.sceneName.length <= 0){
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请先设置场景名称" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertVC animated:YES completion:nil];
            return;
        }
        
        switch (indexPath.row) {
            case 0:{
                [[KwaiGameSDK sharedSDK] reportScene:self.sceneName sceneAction:kKwaiGamePerformanceReportSceneActionEnter];
                break;
            }
            case 1:{
                [[KwaiGameSDK sharedSDK] reportScene:self.sceneName sceneAction:kKwaiGamePerformanceReportSceneActionLoaded];
                break;
            }
            case 2:{
                [[KwaiGameSDK sharedSDK] reportScene:self.sceneName sceneAction:kKwaiGamePerformanceReportSceneActionQuit];
                break;
            }
            default:
                break;
        }
    }else if (indexPath.section == 1){
        [self reportNetwork];
    }else if (indexPath.section == 2){
        NSArray *items = self.itemTitles[indexPath.section];
        [[KwaiGameSDK sharedSDK] reportGamePictureQuality:items[indexPath.row]];
        
        
    }else if (indexPath.section == 3){
        [self setTargetFPS];
    }else if (indexPath.section == 4){
        KGPerformanceReportExpandInfoViewController *expandInputVC = [[KGPerformanceReportExpandInfoViewController alloc] init];
        [expandInputVC setReportExpandInfo:^(NSString * _Nonnull content) {
            NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *expandDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if (expandDict){
                [[KwaiGameSDK sharedSDK] reportGameExpandInfo:expandDict];
            }
        }];
        [self.navigationController pushViewController:expandInputVC animated:YES];
    }else if (indexPath.section == 5){
        id a = @[][1];
    }
}


@end
