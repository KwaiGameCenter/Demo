//
//  KGSensitiveFilterViewController.m
//  KwaiGameSDK_Example
//
//  Created by 刘玮 on 2019/6/5.
//  Copyright © 2019 mookhf. All rights reserved.
//

#import "KGSensitiveFilterViewController.h"
#import <KwaiGameSDK/KwaiGameSDK+Sensitive.h>
#import "NSError+KwaiBase.h"
#import "KwaiBase.h"
#import "UIView+Toast.h"
#define GR_RUN_IN_MAIN_THREAD_START dispatch_async(dispatch_get_main_queue(), ^{
#define GR_RUN_IN_MAIN_THREAD_END });

#define TOAST(message) [[UIApplication sharedApplication].keyWindow makeToast: message];
#define SHOW_TOAST(message) [[UIApplication sharedApplication].keyWindow makeToastActivity:CSToastPositionCenter];
#define HIDDEN_TOAST() [[UIApplication sharedApplication].keyWindow hideToastActivity];

@interface KGSensitiveFilterViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *inputTextView;
@property (nonatomic, weak) IBOutlet UITextView *typeTextView;
@property (nonatomic, weak) IBOutlet UITableView *selectTypeView;

@property (nonatomic, copy) NSArray *typesArray;
@property (nonatomic, copy) NSArray *realTypesArray;
@property (nonatomic, strong) NSMutableArray *selectTypes;

@end

@implementation KGSensitiveFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.realTypesArray = @[@"user_name",
                            @"user_desc",
                            @"video_title",
                            @"video_content",
                            @"video_comment",
                            @"video_comment_risk",
                            @"private_message",
                            @"live_stream_comment",
                            @"user_search",
                            @"tag_search",
                            @"tag_publish",
                            @"tag_recommend",
                            @"music_search",
                            @"chatroom_title",
                            @"feed",
                            @"kwai_id",
                            @"asr_text",
                            @"damaku",
                            @"senior_damaku",
                            @"comment",
                            @"label",
                            @"search",
                            @"content",
                            @"shuiliao",
                            @"location",
                            @"game_nick_name",
                            @"game_chat_content",
                            @"game_moment"];
    
    NSMutableArray *tmp = [NSMutableArray arrayWithArray: self.realTypesArray];
    [tmp insertObject: @"clear" atIndex: 0];
    [tmp insertObject: @"all" atIndex: 0];
    self.typesArray = tmp;
    
    self.selectTypes = [NSMutableArray arrayWithCapacity: self.realTypesArray.count];
    self.selectTypeView.dataSource = self;
    self.selectTypeView.delegate = self;
    [self.selectTypeView registerClass: UITableViewCell.class forCellReuseIdentifier: @"BaseCell"];
    self.inputTextView.delegate = self;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (IBAction)doCheckAction: (id)sender {
    if (KWAI_IS_ARRAY_NIL(self.selectTypes)) {
        TOAST(@"需要选择检查类型");
        return;
    }
    SHOW_TOAST(@"检查中...");
    [[KwaiGameSDK sharedSDK] isSensitiveWord: self.inputTextView.text
                                       types: self.selectTypes
                                  completion: ^(NSError * _Nonnull error, NSArray<KwaiSensitiveWord *> * _Nonnull results) {
                                      GR_RUN_IN_MAIN_THREAD_START
                                      HIDDEN_TOAST();
                                      GR_RUN_IN_MAIN_THREAD_END
                                      if (error) {
                                          GR_RUN_IN_MAIN_THREAD_START
                                          TOAST(error.errorMsg);
                                          GR_RUN_IN_MAIN_THREAD_END
                                          return;
                                      }
                                      if (results.count <= 0) {
                                          GR_RUN_IN_MAIN_THREAD_START
                                          self.inputTextView.textColor = [UIColor blackColor];
                                          self.inputTextView.text = self.inputTextView.text;
                                          TOAST(@"输入合法!!!");
                                          GR_RUN_IN_MAIN_THREAD_END
                                          return;
                                      }
                                      GR_RUN_IN_MAIN_THREAD_START
                                      NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: self.inputTextView.text];
                                      [attributedString addAttribute: NSFontAttributeName
                                                               value: self.inputTextView.font
                                                               range: NSMakeRange(0, self.inputTextView.text.length)];
                                      for (KwaiSensitiveWord *result in results) {
                                          [attributedString addAttribute: NSForegroundColorAttributeName
                                                                   value: [self colorForLevel: result.level]
                                                                   range: result.range];
                                      }
                                      self.inputTextView.attributedText = attributedString;
                                      TOAST(@"输入内容包含敏感词!!!");
                                      GR_RUN_IN_MAIN_THREAD_END
                                  }];
}

- (UIColor *)colorForLevel: (int)level {
    if (level < 0 || level > 5) {
        return [UIColor blackColor];
    }
    switch (level) {
        case 1:
            return [UIColor blueColor];
        case 2:
            return [UIColor greenColor];
        case 3:
            return [UIColor yellowColor];
        case 4:
            return [UIColor orangeColor];
        case 5:
            return [UIColor redColor];
        default:
            return [UIColor blackColor];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section {
    return self.typesArray.count;
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"BaseCell"];
    if (cell != nil) {
        if (indexPath.row < self.typesArray.count) {
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.text = self.typesArray[indexPath.row];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: true];
    if (indexPath.row < self.typesArray.count) {
        NSString *type = self.typesArray[indexPath.row];
        if ([type isEqualToString: @"all"]) {
            [self.selectTypes removeAllObjects];
            [self.selectTypes addObjectsFromArray: self.realTypesArray];
        } else if ([type isEqualToString: @"clear"]) {
            [self.selectTypes removeAllObjects];
        } else {
            if ([self.selectTypes containsObject: type]) {
                [self.selectTypes removeObject: type];
            } else {
                [self.selectTypes addObject: type];
            }
        }
        self.typeTextView.text = [self.selectTypes componentsJoinedByString: @","];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textView: (UITextView *)textView shouldChangeTextInRange: (NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString: @"\n"]) {
        [self.view endEditing: YES];
        return NO;
    }
    return YES;
}

@end
