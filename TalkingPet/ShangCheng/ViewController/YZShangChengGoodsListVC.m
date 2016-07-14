//
//  YZShangChengGoodsListVC.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/25.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShangChengGoodsListVC.h"
#import "YZShangChengGoodsListCell.h"
#import "YZGoodsDetailVC.h"
#import "MJRefresh.h"
#import "NetServer+ShangCheng.h"

@interface YZShangChengGoodsListVC()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation YZShangChengGoodsListVC

- (void)dealloc {
    NSLog(@"dealloc:[%@]", self);
    _items = nil;
}

- (NSString *)title {
    return @"宠物粮";
}

- (void)inner_Pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)inner_MoreAction:(id)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(inner_Pop:)];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10.f;
    flowLayout.minimumLineSpacing = 10.f;
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.sectionInset = sectionInset;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - sectionInset.left - sectionInset.right - 10) / 2;
    flowLayout.itemSize = CGSizeMake(width,
                                     width / 5 * 6);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor colorWithRed:.9
                                                     green:.9
                                                      blue:.9
                                                     alpha:1.f];
    [collectionView registerClass:[YZShangChengGoodsListCell class] forCellWithReuseIdentifier:NSStringFromClass(self.class)];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view).mas_offset(0);
    }];
    
    [collectionView addHeaderWithTarget:self action:@selector(inner_Refresh:)];
    [collectionView addFooterWithTarget:self action:@selector(inner_LoadMore:)];
    [collectionView headerBeginRefreshing];
}

#pragma mark -- Refresh

- (void)inner_Refresh:(id)sender {
    [self inner_PostWithPageIndex:0 refresh:YES];
}

- (void)inner_LoadMore:(id)sender {
    [self inner_PostWithPageIndex:self.pageIndex refresh:NO];
}

- (void)inner_PostWithPageIndex:(NSInteger)pageIndex
                        refresh:(BOOL)refresh {
    if (refresh) {
        [self.collectionView footerEndRefreshing];
    } else {
        [self.collectionView headerEndRefreshing];
    }
    __weak __typeof(self) weakSelf = self;
    [NetServer searchGoodsListWithKeyword:nil
                                pageIndex:pageIndex
                                  success:^(NSArray *items, NSInteger nextPageIndex) {
                                      weakSelf.pageIndex = nextPageIndex;
                                      if (refresh) {
                                          weakSelf.items = [NSArray arrayWithArray:items];
                                          [weakSelf.collectionView headerEndRefreshing];
                                      } else {
                                          weakSelf.items = [[NSArray arrayWithArray:weakSelf.items] arrayByAddingObjectsFromArray:items];
                                          [weakSelf.collectionView footerEndRefreshing];
                                      }
                                      [weakSelf.collectionView reloadData];
                                  } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
                                      if (refresh) {
                                          [weakSelf.collectionView headerEndRefreshing];
                                      } else {
                                          [weakSelf.collectionView footerEndRefreshing];
                                      }
                                  }];
}

#pragma mark -- UICollectionView

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YZShangChengGoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
    cell.goods = self.items[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    YZGoodsDetailVC *detailVC = [[YZGoodsDetailVC alloc] init];
    YZGoodsModel *goodsModel = self.items[indexPath.row];
    detailVC.goodsId = goodsModel.goodsId;
    detailVC.goodsName = goodsModel.brand.brand;
    detailVC.hideNaviBg = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
