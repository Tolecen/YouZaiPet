//
//  YZShangChengDetailVC.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/23.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZDogDetailVC.h"
#import "YZShoppingCarVC.h"
#import "YZQuanSheDetailViewController.h"
#import "YZShangChengDogListCell.h"
#import "YZDogDetailCollectionHeaderView.h"
#import "YZDetailTextCollectionView.h"

#import "YZDetailBottomBar.h"
#import "NetServer+ShangCheng.h"
#import "MJRefresh.h"
#import "YZShangChengShareHelper.h"
#import "YZShoppingCarHelper.h"
#import "YZShoppingCarVC.h"

@interface YZDogDetailVC()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, YZDetailBottomBarDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) YZDogDetailModel *detailModel;

@property (nonatomic, copy) NSArray *items;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSMutableDictionary *cache;

@end

@implementation YZDogDetailVC

- (void)dealloc {
    _dogModel = nil;
    _detailModel = nil;
    _items = nil;
    _cache = nil;
}

- (void)inner_Pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAnotherBackButtonWithTarget:@selector(inner_Pop:)];
    self.cache = [[NSMutableDictionary alloc] init];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10.f;
    flowLayout.minimumLineSpacing = 10.f;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                                          0,
                                                                                          ScreenWidth,
                                                                                          ScreenWidth)
                                                          collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor colorWithRed:.9
                                                     green:.9
                                                      blue:.9
                                                     alpha:1.f];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
    [collectionView registerClass:[YZShangChengDogListCell class] forCellWithReuseIdentifier:NSStringFromClass(YZShangChengDogListCell.class)];
    [collectionView registerClass:[YZDogDetailCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(YZDogDetailCollectionHeaderView.class)];
    [collectionView registerClass:[YZDetailTextCollectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(YZDetailTextCollectionView.class)];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view).mas_offset(0);
        make.bottom.mas_equalTo(self.view).mas_offset(-50);
    }];
    
    [collectionView addFooterWithTarget:self action:@selector(inner_LoadMore:)];
    
    YZDetailBottomBar *bottomBar = [[YZDetailBottomBar alloc] initWithFrame:CGRectZero type:YZShangChengType_Dog];
    bottomBar.delegate = self;
    [self.view addSubview:bottomBar];
    [bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view).mas_offset(0);
        make.height.mas_offset(50);
    }];
    
    [self inner_GetDogDetail];
    [self inner_GetDogListWithLoadMore:NO];
}

- (void)inner_GetDogDetail {
    if (!self.dogModel.dogId) {
        return;
    }
    WS(weakSelf);
    [NetServer getDogDetailInfoWithDogId:self.dogModel.dogId
                                 success:^(YZDogDetailModel *detailModel) {
                                     weakSelf.detailModel = detailModel;
                                     [weakSelf.collectionView reloadData];
                                 }
                                 failure:^(NSError *error, AFHTTPRequestOperation *operation) {
                                     
                                 }];
}

- (void)inner_GetDogListWithLoadMore:(BOOL)loadMore {
    NSInteger pageIndex = loadMore ? self.pageIndex : 1 ;
    WS(weakSelf);
    [NetServer searchDogListWithType:self.dogModel.productType.dogTypeId
                             keyword:nil
                                size:YZDogSize_All
                                 sex:YZDogSex_All
                           sellPrice:YZDogValueRange_All
                                area:nil
                                 age:YZDogAgeRange_All
                              shopId:nil
                           pageIndex:pageIndex
                             success:^(NSArray *items, NSInteger nextPageIndex) {
                                 if (items && items.count > 0) {
                                     weakSelf.pageIndex = nextPageIndex;
                                     if (loadMore) {
                                         weakSelf.items = [[NSArray arrayWithArray:weakSelf.items] arrayByAddingObjectsFromArray:items];
                                     } else {
                                         weakSelf.items = [NSArray arrayWithArray:items];
                                     }
                                     [weakSelf.collectionView footerEndRefreshing];
                                     [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
                                 } else {
                                     if (loadMore) {
                                         [weakSelf.collectionView footerEndRefreshing];
                                     }
                                 }
                             }
                             failure:^(NSError *error, AFHTTPRequestOperation *operation) {
                                 if (loadMore) {
                                     [weakSelf.collectionView footerEndRefreshing];
                                 }
                             }];
}

- (void)inner_LoadMore:(id)sender {
    [self inner_GetDogListWithLoadMore:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self showNaviBg];
}

#pragma mark -- UICollectionView

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeZero;
    }
    CGFloat width = (ScreenWidth - 30) / 2;
    return CGSizeMake(width,
                      width / 5 * 6);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.detailModel) {
            return CGSizeMake(ScreenWidth, ScreenWidth + 120);
        }
        return CGSizeZero;
    }
    return CGSizeMake(ScreenWidth, 30);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.detailModel ? 1 : 0;
    }
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UICollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class) forIndexPath:indexPath];
        return collectionViewCell;
    }
    YZShangChengDogListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(YZShangChengDogListCell.class) forIndexPath:indexPath];
    cell.dogModel = self.items[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            YZDogDetailCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(YZDogDetailCollectionHeaderView.class) forIndexPath:indexPath];
            headerView.detailModel = self.detailModel;
            headerView.backgroundColor = [UIColor whiteColor];
            return headerView;
        } else {
            YZDetailTextCollectionView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(YZDetailTextCollectionView.class) forIndexPath:indexPath];
            reusableView.text = @"邻舍狗狗";
            return reusableView;
        }
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        YZDogDetailVC *detailVC = [[YZDogDetailVC alloc] init];
        YZDogModel *dogModel = self.items[indexPath.row];
        detailVC.dogModel = dogModel;
        detailVC.hideNaviBg = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark -- 

- (void)shareAction {
    [YZShangChengShareHelper shareWithScene:YZShangChengType_Dog
                                     target:self
                                      model:nil
                                    success:nil
                                    failure:nil];
}

- (void)clearPriceAction {
    YZShoppingCarVC *shoppingCarVC = [[YZShoppingCarVC alloc] init];
    shoppingCarVC.selectedIndex = 0;
    [self.navigationController pushViewController:shoppingCarVC animated:YES];
}

- (void)enterDogHomeAction {
    YZQuanSheDetailViewController *quanShe = [[YZQuanSheDetailViewController alloc] init];
    quanShe.quanSheId = self.detailModel.shop.shopId;
    quanShe.quanSheName = self.detailModel.shop.shopName;
    [self.navigationController pushViewController:quanShe animated:YES];
}

- (void)addShoppingCarAction {
    if (!self.dogModel) {
        return;
    }
    [[YZShoppingCarHelper instanceManager] addShoppingCarWithScene:YZShangChengType_Dog
                                                             model:self.dogModel];
}


@end
