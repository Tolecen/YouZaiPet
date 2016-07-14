//
//  YZQuanSheDetailViewController.m
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/7.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZQuanSheDetailViewController.h"
#import "YZDogDetailVC.h"
#import "YZShangChengDogListCell.h"
#import "YZQuanSheDetailCollectionHeaderView.h"
#import "YZDetailTextCollectionView.h"
#import "YZQuanSheDetailIntroView.h"
#import "NetServer+ShangCheng.h"
#import "MJRefresh.h"

@interface YZQuanSheDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) YZQuanSheDetailIntroView *quanSheIntroView;

@property (nonatomic, copy) NSArray *items;

@property (nonatomic, strong) YZQuanSheDetailModel *quanSheDetail;

@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation YZQuanSheDetailViewController

- (void)dealloc {
    _quanSheIntroView = nil;
    _items = nil;
    _quanSheDetail = nil;
}

- (NSString *)title {
    return self.quanSheName;
}

- (void)inner_Pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(inner_Pop:)];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10.f;
    flowLayout.minimumLineSpacing = 10.f;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor colorWithRed:.9
                                                     green:.9
                                                      blue:.9
                                                     alpha:1.f];
    [collectionView registerClass:[YZShangChengDogListCell class] forCellWithReuseIdentifier:NSStringFromClass(YZShangChengDogListCell.class)];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];

    [collectionView registerClass:[YZQuanSheDetailCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(YZQuanSheDetailCollectionHeaderView.class)];
    [collectionView registerClass:[YZDetailTextCollectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(YZDetailTextCollectionView.class)];

    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    
    [collectionView addFooterWithTarget:self action:@selector(inner_LoadMore)];
    
    self.quanSheIntroView = [[YZQuanSheDetailIntroView alloc] init];
    [self.view addSubview:self.quanSheIntroView];
    [self.quanSheIntroView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    [self inner_GetQuanSheDetail];
    [self inner_GetQuanSheDogListWithLoadMore:NO];
}

- (void)inner_GetQuanSheDetail {
    WS(weakSelf);
    [NetServer getQuanSheDetailInfoWithShopId:self.quanSheId
                                      success:^(YZQuanSheDetailModel *quanSheDetail) {
                                          weakSelf.quanSheDetail = quanSheDetail;
                                          [weakSelf.collectionView reloadData];
                                      }
                                      failure:^(NSError *error, AFHTTPRequestOperation *operation) {
                                          
                                      }];
}

- (void)inner_GetQuanSheDogListWithLoadMore:(BOOL)loadMore {
    NSInteger pageIndex = loadMore ? self.pageIndex : 1;
    WS(weakSelf);
    [NetServer searchDogListWithType:nil
                             keyword:nil
                                size:YZDogSize_All
                                 sex:YZDogSex_All
                           sellPrice:YZDogValueRange_All
                                area:nil
                                 age:YZDogAgeRange_All
                              shopId:self.quanSheId
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

- (void)inner_LoadMore {
    [self inner_GetQuanSheDogListWithLoadMore:YES];
}

- (void)inner_ShowQuanSheIntroView {
    [self.quanSheIntroView show];
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
        return CGSizeMake(ScreenWidth, 180);
    }
    if (self.items && self.items.count > 0) {
        return CGSizeMake(ScreenWidth, 30);
    }
    return CGSizeZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UICollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class) forIndexPath:indexPath];
        return collectionViewCell;
    }
    YZShangChengDogListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(YZShangChengDogListCell.class) forIndexPath:indexPath];
    cell.dogModel = self.items[indexPath.row];
    cell.hideQuanShe = YES;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            YZQuanSheDetailCollectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass(YZQuanSheDetailCollectionHeaderView.class) forIndexPath:indexPath];
            header.detailModel = self.quanSheDetail;
            __weak __typeof(self) weakSelf = self;
            [header setShowQuanSheIntroBlock:^{
                [weakSelf inner_ShowQuanSheIntroView];
            }];
            return header;
        } else {
            YZDetailTextCollectionView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass(YZDetailTextCollectionView.class) forIndexPath:indexPath];
            header.text = @"全部狗狗";
            return header;
        }
    }
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.items.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    YZDogDetailVC *detailVC = [[YZDogDetailVC alloc] init];
    detailVC.dogModel = self.items[indexPath.row];
    detailVC.hideNaviBg = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
