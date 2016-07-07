//
//  YZShangChengDetailVC.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/23.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShangChengDetailVC.h"
#import "YZShoppingCarVC.h"
#import "YZQuanSheDetailViewController.h"
#import "YZShangChengDetailImageCell.h"
#import "YZDetailBottomBar.h"

@interface YZShangChengDetailVC()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation YZShangChengDetailVC

- (void)inner_Pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAnotherBackButtonWithTarget:@selector(inner_Pop:)];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass(self.class)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0.f;
    flowLayout.minimumLineSpacing = 0.f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(ScreenWidth,
                                     ScreenWidth);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                                          0,
                                                                                          ScreenWidth,
                                                                                          ScreenWidth)
                                                          collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[YZShangChengDetailImageCell class] forCellWithReuseIdentifier:NSStringFromClass(self.class)];
    self.tableView.tableHeaderView = collectionView;
    
    YZDetailBottomBar *bottomBar = [[YZDetailBottomBar alloc] initWithFrame:CGRectZero type:YZShangChengType_Goods];
    [self.view addSubview:bottomBar];
    [bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view).mas_offset(0);
        make.height.mas_offset(50);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self showNaviBg];
}

#pragma mark -- UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YZShangChengDetailImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
    cell.backgroundColor = RandomColor;
    return cell;
}

#pragma mark -- UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class)];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YZQuanSheDetailViewController *shoppingCarVC = [[YZQuanSheDetailViewController alloc] init];
    [self.navigationController pushViewController:shoppingCarVC animated:YES];
}

@end
