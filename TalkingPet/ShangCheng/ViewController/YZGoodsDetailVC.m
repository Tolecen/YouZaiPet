//
//  YZGoodsDetailVC.m
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/11.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZGoodsDetailVC.h"
#import "YZGoodsDetailCollectionHeaderView.h"
#import "YZDetailTextCollectionView.h"

#import "YZShoppingCarVC.h"
#import "YZShangChengGoodsListCell.h"
#import "YZDetailBottomBar.h"
#import "NetServer+ShangCheng.h"
#import "MJRefresh.h"

@interface YZGoodsDetailVC()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, YZDetailBottomBarDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) YZGoodsDetailModel *detailModel;

@property (nonatomic, copy) NSArray *items;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSMutableDictionary *cache;

@end

@implementation YZGoodsDetailVC

- (void)dealloc {
    _goodsId = nil;
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
    [collectionView registerClass:[YZShangChengGoodsListCell class] forCellWithReuseIdentifier:NSStringFromClass(YZShangChengGoodsListCell.class)];
    [collectionView registerClass:[YZGoodsDetailCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(YZGoodsDetailCollectionHeaderView.class)];
    [collectionView registerClass:[YZDetailTextCollectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(YZDetailTextCollectionView.class)];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view).mas_offset(0);
        make.bottom.mas_equalTo(self.view).mas_offset(-50);
    }];
    
    YZDetailBottomBar *bottomBar = [[YZDetailBottomBar alloc] initWithFrame:CGRectZero type:YZShangChengType_Goods];
    bottomBar.delegate = self;
    [self.view addSubview:bottomBar];
    [bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view).mas_offset(0);
        make.height.mas_offset(50);
    }];
    
    [collectionView addFooterWithTarget:self action:@selector(inner_LoadMore:)];
    
    [self inner_GetGoodsDetail];
    [self inner_GetGoodsList];
}

- (void)inner_GetGoodsDetail {
    if (!self.goodsId) {
        return;
    }
    WS(weakSelf);
    [NetServer getDogGoodsDetailInfoWithGoodsId:self.goodsId
                                        success:^(YZGoodsDetailModel *detailModel) {
                                            weakSelf.detailModel = detailModel;
                                            weakSelf.detailModel.content = nil;
                                            [weakSelf.collectionView reloadData];
                                        }
                                        failure:^(NSError *error, AFHTTPRequestOperation *operation) {
                                            
                                        }];
}

- (void)inner_GetGoodsList {
    __weak __typeof(self) weakSelf = self;
    [NetServer searchGoodsListWithName:self.goodsName
                             pageIndex:1
                               success:^(NSArray *items, NSInteger nextPageIndex) {
                                   weakSelf.pageIndex = nextPageIndex;
                                   weakSelf.items = items;
                                   [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
                               } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
                               }];
}

- (void)inner_LoadMore:(id)sender {
    __weak __typeof(self) weakSelf = self;
    [NetServer searchGoodsListWithName:self.goodsName
                             pageIndex:self.pageIndex
                               success:^(NSArray *items, NSInteger nextPageIndex) {
                                   if (items && items.count > 0) {
                                       weakSelf.pageIndex = nextPageIndex;
                                       weakSelf.items = [[NSArray arrayWithArray:weakSelf.items] arrayByAddingObjectsFromArray:items];
                                       [weakSelf.collectionView footerEndRefreshing];
                                       [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
                                   } else {
                                       [weakSelf.collectionView footerEndRefreshing];
                                   }
                               } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
                               }];
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

- (CGFloat)inner_CalcuteReferenceSizeForHeaderInSectionZero {
    CGFloat height = ScreenWidth;
    height += 15;
    UIFont *titleFont = [UIFont systemFontOfSize:14];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:self.detailModel.name attributes:@{NSFontAttributeName: titleFont}];
    CGFloat titleHeight = [title boundingRectWithSize:CGSizeMake(ScreenWidth - 20, ceil(titleFont.lineHeight * 2) + 1) options:NSStringDrawingUsesLineFragmentOrigin context:NULL].size.height;
    height += titleHeight;
    
    height += 15;
    
    if (self.detailModel.content && self.detailModel.content.length > 0) {
        UIFont *contentFont = [UIFont systemFontOfSize:12];
        NSAttributedString *content = [[NSAttributedString alloc] initWithString:self.detailModel.content attributes:@{NSFontAttributeName: contentFont}];
        CGFloat contentHeight = [content boundingRectWithSize:CGSizeMake(ScreenWidth - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:NULL].size.height;
        height += contentHeight;
        height += 15;
    }
    
    UIFont *priceFont = [UIFont systemFontOfSize:15];
    height += (ceil(priceFont.lineHeight) + 1);
    height += 15;
    return height;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.detailModel) {
            if ([self.cache objectForKey:kCacheReferenceHeaderSizeHeightKey]) {
                CGFloat height = [self.cache[kCacheReferenceHeaderSizeHeightKey] floatValue];
                return CGSizeMake(ScreenWidth, height);
            } else {
                CGFloat height = [self inner_CalcuteReferenceSizeForHeaderInSectionZero];
                [self.cache setObject:@(height) forKey:kCacheReferenceHeaderSizeHeightKey];
                return CGSizeMake(ScreenWidth, height);
            }
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
    YZShangChengGoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(YZShangChengGoodsListCell.class) forIndexPath:indexPath];
    cell.goods = self.items[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            YZGoodsDetailCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(YZGoodsDetailCollectionHeaderView.class) forIndexPath:indexPath];
            headerView.detailModel = self.detailModel;
            headerView.backgroundColor = [UIColor whiteColor];
            return headerView;
        } else {
            YZDetailTextCollectionView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(YZDetailTextCollectionView.class) forIndexPath:indexPath];
            reusableView.text = @"相关推荐";
            return reusableView;
        }
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        YZGoodsDetailVC *detailVC = [[YZGoodsDetailVC alloc] init];
        YZGoodsModel *goodsModel = self.items[indexPath.row];
        detailVC.goodsId = goodsModel.goodsId;
        detailVC.goodsName = goodsModel.brand.brand;
        detailVC.hideNaviBg = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark --

- (void)shareAction {
    
}

- (void)clearPriceAction {
    
}

- (void)addShoppingCarAction {
    
}

@end
