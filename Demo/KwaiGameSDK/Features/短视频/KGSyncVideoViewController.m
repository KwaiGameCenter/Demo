//
//  KGSyncVideoViewController.m
//  KwaiGameSDK_Example
//
//  Created by 邓波 on 2020/3/6.
//  Copyright © 2020 mookhf. All rights reserved.
//

#import "KGSyncVideoViewController.h"
#import "KGVideoInfo.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"
#import "UIViewController+DemoSupport.h"
#import "MBProgressHUD.h"
#import "KGFooterView.h"
#import "KGTokenHelper.h"
#import "KGUtil.h"
#import <KwaiGameSDK/KwaiGameSDK.h>

@interface UITableView(FeakForiOS9)

@property (nonatomic, strong) UIRefreshControl *safeRefreshControl;

@end

@implementation UITableView(FeakForiOS9)

- (UIRefreshControl *)safeRefreshControl {
    if (@available(iOS 10.0, *)) {
        return self.refreshControl;
    } else {
        return nil;
    }
}

- (void)setSafeRefreshControl:(UIRefreshControl *)safeRefreshControl {
    if (@available(iOS 10.0, *)) {
        self.refreshControl = safeRefreshControl;
    }
}

@end

@interface KGSyncVideoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<KGVideoInfo *> *dataArray;
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, assign) long lastSeqNum;
@end

@implementation KGSyncVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *createButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [createButton setTitle:@"🔄" forState:UIControlStateNormal];
    [createButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [createButton addTarget:self action:@selector(fetchVideoCount) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *createItem = [[UIBarButtonItem alloc]initWithCustomView:createButton];

    self.navigationItem.rightBarButtonItems = @[createItem];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor grayColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.tableView.safeRefreshControl = refreshControl;

    KGFooterView *refreshFooterView = [KGFooterView refreshFooterView];
    refreshFooterView.hidden = YES;
    self.tableView.tableFooterView = refreshFooterView;

    self.dataArray = [NSMutableArray new];
    [self refreshData];
}

- (void)refreshData {
    if (self.isRefreshing) {
        return;
    }
    if (!self.tableView.tableFooterView.hidden) {
        [self.tableView.safeRefreshControl endRefreshing];
        return;
    }
    self.isRefreshing = YES;
    [KGTokenHelper requestKsPhotos:[KwaiGameSDK sharedSDK].appId gameId:[KwaiGameSDK sharedSDK].account.uid gameToken:[KwaiGameSDK sharedSDK].account.serviceToken seqNum:0 completion:^(NSError *error, NSDictionary *dictionary) {
        if (!error && [[dictionary valueForKey:@"photos"] isKindOfClass:NSArray.class]) {
            NSArray<NSDictionary *> *photos = (NSArray *)[dictionary valueForKey:@"photos"];
            [self.dataArray removeAllObjects];
            [photos enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                KGVideoInfo *video = [KGVideoInfo new];
                video.photoId = [obj valueForKey:@"photo_id"];
                video.coverUrl = [obj valueForKey:@"cover_url"];
                video.status = [[obj valueForKey:@"status"] intValue];
                video.seqNum = [[obj valueForKey:@"seq_num"] longValue];
                [self.dataArray addObject:video];
            }];
            self.lastSeqNum = self.dataArray.lastObject.seqNum;
            [self.tableView reloadData];
        } else {
            [self.view toast:error.localizedDescription];
        }
        
        [self.tableView.safeRefreshControl endRefreshing];
        self.isRefreshing = NO;
    }];
}

- (void)loadMoreData {
    [KGTokenHelper requestKsPhotos:[KwaiGameSDK sharedSDK].appId gameId:[KwaiGameSDK sharedSDK].account.uid gameToken:[KwaiGameSDK sharedSDK].account.serviceToken seqNum:self.lastSeqNum completion:^(NSError *error, NSDictionary *dictionary) {
        if (!error && [[dictionary valueForKey:@"photos"] isKindOfClass:NSArray.class]) {
            NSArray<NSDictionary *> *photos = (NSArray *)[dictionary valueForKey:@"photos"];
            [photos enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                KGVideoInfo *video = [KGVideoInfo new];
                video.photoId = [obj valueForKey:@"photo_id"];
                video.coverUrl = [obj valueForKey:@"cover_url"];
                video.status = [[obj valueForKey:@"status"] intValue];
                video.seqNum = [[obj valueForKey:@"seq_num"] longValue];
                [self.dataArray addObject:video];
            }];
            self.lastSeqNum = self.dataArray.lastObject.seqNum;
            [self.tableView reloadData];
        } else {
            [self.view toast:error.localizedDescription];
        }
        
        self.tableView.tableFooterView.hidden = YES;
    }];
}

- (void)fetchVideoCount {
    [KGTokenHelper fetchPhotosCount:[KwaiGameSDK sharedSDK].appId gameId:[KwaiGameSDK sharedSDK].account.uid gameToken:[KwaiGameSDK sharedSDK].account.serviceToken completion:^(NSError *error, NSDictionary *dictionary) {
        if (error) {
            [self.view toast:error.localizedDescription];
        } else {
            int play_count = [[dictionary valueForKey:@"play_count"] intValue];
            int like_count = [[dictionary valueForKey:@"like_count"] intValue];
            [self.view toast:[NSString stringWithFormat:@"播放数：%@， 点赞数：%@", @(play_count), @(like_count)]];
        }
    }];
}

#pragma mark - datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: NSStringFromClass(UITableViewCell.class)];
    if (indexPath.row < self.dataArray.count) {
        KGVideoInfo *video = self.dataArray[indexPath.row];
        cell.textLabel.text = video.photoId;
        [cell.imageView sd_setImageWithURL: [NSURL URLWithString:video.coverUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
        }];
        cell.detailTextLabel.text = video.status == 0 ? @"未同步" : (video.status == 1 ? @"同步中": @"已同步");
    } else {
        cell.textLabel.text = nil;
        cell.imageView.image = nil;
        cell.detailTextLabel.text = nil;
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataArray.count) {
        return self.dataArray[indexPath.row].status == 0;
    }
    return NO;
}
 
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataArray.count) {
        return @[];
    }
    NSString *photoId = self.dataArray[indexPath.row].photoId;
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"同步" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [KGTokenHelper syncKsPhotos:@[photoId] gameId:[KwaiGameSDK sharedSDK].account.uid gameToken:[KwaiGameSDK sharedSDK].account.serviceToken appId:[KwaiGameSDK sharedSDK].appId completion:^(NSError *error) {
            if (!error) {
                if (indexPath.row < self.dataArray.count && [self.dataArray[indexPath.row].photoId isEqualToString:photoId]) {
                    self.dataArray[indexPath.row].status = 1;
                    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                }
            } else {
                [self.view toast:error.localizedDescription];
            }
        }];
    }];
    editAction.backgroundColor = [UIColor grayColor];
    return @[editAction];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%@, %@", @(scrollView.contentOffset), @(scrollView.contentSize));
    if (self.dataArray.count == 0 || self.tableView.tableFooterView.hidden == NO || self.isRefreshing) {
        return;
    }
    
    if (MIN(scrollView.frame.size.height - scrollView.contentSize.height, 0) + scrollView.contentOffset.y > 40) {
        self.tableView.tableFooterView.hidden = NO;
        [self loadMoreData];
    }
}
@end
