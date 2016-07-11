//
//  YZShangChengListVC.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/23.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShangChengDogListVC.h"
#import "YZDogDetailVC.h"
#import "YZShangChengDropMenu.h"
#import "YZShangChengDogListCell.h"
#import "YZShangChengModel.h"
#import "MJRefresh.h"
#import "NetServer+ShangCheng.h"
#import "UIActionSheet+block.h"
#import "SVProgressHUD.h"

NSString *const SexFilterKey        = @"SexFilterKey";
NSString *const AgeFilterKey        = @"AgeFilterKey";
NSString *const PriceFilterKey      = @"PriceFilterKey";
NSString *const SizeFilterKey       = @"SizeFilterKey";
NSString *const TypeFilterKey       = @"TypeFilterKey";

@interface YZShangChengDogListVC()<UICollectionViewDataSource, UICollectionViewDelegate, YZDropMenuDataSource, YZDropMenuDelegate, UISearchBarDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *items;

@property (nonatomic, weak) YZShangChengDropMenu *dropMenu;
//最新的filter
@property (nonatomic, assign) YZDogSex sexFilter;
@property (nonatomic, assign) YZDogSize sizeFilter;
@property (nonatomic, assign) YZDogAgeRange ageRangeFilter;
@property (nonatomic, assign) YZDogValueRange valueRangeFilter;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, copy) NSString *typeFilter;
//保存旧的filter
@property (nonatomic, strong) NSMutableDictionary *restoreFilters;

@end

@implementation YZShangChengDogListVC

- (void)dealloc {
    NSLog(@"dealloc:[%@]", self);
    _restoreFilters = nil;
    _items = nil;
}

#pragma mark -- NavigationAction

- (void)inner_Pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)inner_MoreAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:nil
                                                    cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:nil
                                                    otherButtonTitles:@"清除所有筛选条件", nil];
    __weak __typeof(self) weakSelf = self;
    [actionSheet showInView:self.view action:^(NSInteger index) {
        if (index == 0) {
            [weakSelf.collectionView headerEndRefreshing];
            [weakSelf.collectionView footerEndRefreshing];
            [weakSelf inner_ConfigureDefault];
            [weakSelf.collectionView headerBeginRefreshing];
        }
    }];
}

#pragma mark -- Life Cycle

- (void)inner_ConfigureDefault {
    self.restoreFilters[SizeFilterKey] = @(self.sizeFilter);
    self.restoreFilters[AgeFilterKey] = @(self.ageRangeFilter);
    self.restoreFilters[SexFilterKey] = @(self.sexFilter);
    self.restoreFilters[PriceFilterKey] = @(self.valueRangeFilter);
    self.restoreFilters[TypeFilterKey] = self.typeFilter;
    
    self.typeFilter = @"";
    self.sexFilter = YZDogSex_All;
    self.sizeFilter = YZDogSize_All;
    self.ageRangeFilter = YZDogAgeRange_All;
    self.valueRangeFilter = YZDogValueRange_All;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self inner_ConfigureDefault];
    self.restoreFilters = [@{SexFilterKey: @(self.sexFilter),
                             SizeFilterKey: @(self.sizeFilter),
                             AgeFilterKey: @(self.ageRangeFilter),
                             PriceFilterKey: @(self.valueRangeFilter),
                             TypeFilterKey: self.typeFilter} mutableCopy];
    
    UIImage *backImage = [UIImage imageNamed:@"shangcheng_back_icon"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStyleDone target:self action:@selector(inner_Pop:)];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
//    [self setBackButtonWithTarget:@selector(inner_Pop:)];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.placeholder = @"test";
    [self.navigationItem setTitleView:searchBar];
    
    YZShangChengDropMenu *dropMenu = [[YZShangChengDropMenu alloc] initWithFrame:CGRectZero];
    dropMenu.delegate = self;
    dropMenu.dataSource = self;
    [self.view addSubview:dropMenu];
    self.dropMenu = dropMenu;
    
    UIImage *image = [UIImage imageNamed:@"navigation_more_icon"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightMoreItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(inner_MoreAction:)];
    self.navigationItem.rightBarButtonItem = rightMoreItem;
    
    [dropMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(0);
        make.top.mas_equalTo(self.view).mas_offset(0);
        make.right.mas_equalTo(self.view).mas_offset(0);
        make.height.mas_equalTo(33);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10.f;
    flowLayout.minimumLineSpacing = 10.f;
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.sectionInset = sectionInset;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - sectionInset.left - sectionInset.right - 10) / 2;
    flowLayout.itemSize = CGSizeMake(width,
                                     width / 5 * 6);//card w / h = 5 / 6;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor colorWithRed:.9
                                                     green:.9
                                                      blue:.9
                                                     alpha:1.f];
    [collectionView registerClass:[YZShangChengDogListCell class] forCellWithReuseIdentifier:NSStringFromClass(self.class)];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(0);
        make.top.mas_equalTo(dropMenu.mas_bottom).mas_offset(0);
        make.right.mas_equalTo(self.view).mas_offset(0);
        make.bottom.mas_equalTo(self.view).mas_offset(0);
    }];
    
    [collectionView addHeaderWithTarget:self action:@selector(inner_Refresh:)];
    [collectionView addFooterWithTarget:self action:@selector(inner_LoadMore:)];
    [collectionView headerBeginRefreshing];
}

#pragma mark -- Refresh

- (void)inner_Refresh:(id)sender {
    [self inner_PostWithType:self.typeFilter
                        size:self.sizeFilter
                         sex:self.sexFilter
                         age:self.ageRangeFilter
                       price:self.valueRangeFilter
                   pageIndex:1
                     refresh:YES];
}

- (void)inner_LoadMore:(id)sender {
    [self inner_PostWithType:self.typeFilter
                        size:self.sizeFilter
                         sex:self.sexFilter
                         age:self.ageRangeFilter
                       price:self.valueRangeFilter
                   pageIndex:self.pageIndex
                     refresh:NO];
}

- (void)inner_PostWithType:(NSString *)type
                      size:(YZDogSize)size
                       sex:(YZDogSex)sex
                       age:(YZDogAgeRange)age
                     price:(YZDogValueRange)price
                 pageIndex:(NSInteger)pageIndex
                   refresh:(BOOL)refresh {
    if (refresh) {
        [self.collectionView footerEndRefreshing];
    } else {
        [self.collectionView headerEndRefreshing];
    }
    __weak __typeof(self) weakSelf = self;
    [NetServer searchDogListWithType:type
                                size:size
                                 sex:sex
                           sellPrice:price
                                area:nil
                                 age:age
                              shopId:nil
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
                             }
                             failure:^(NSError *error, AFHTTPRequestOperation *operation) {
                                 [weakSelf inner_RestoreFiltersWhenError];
                                 if (refresh) {
                                     [weakSelf.collectionView headerEndRefreshing];
                                 } else {
                                     [weakSelf.collectionView footerEndRefreshing];
                                 }
                             }];
}

- (void)inner_RestoreFiltersWhenError {
    self.sexFilter = [self.restoreFilters[SexFilterKey] integerValue];
    self.sizeFilter = [self.restoreFilters[SizeFilterKey] integerValue];
    self.ageRangeFilter = [self.restoreFilters[AgeFilterKey] integerValue];
    self.valueRangeFilter = [self.restoreFilters[PriceFilterKey] integerValue];
    self.typeFilter = self.restoreFilters[TypeFilterKey];
}

#pragma mark -- DropMenu

- (NSInteger)numberOfColumnsInMenu:(YZShangChengDropMenu *)menu {
    return 3;
}

- (NSString *)menu:(YZShangChengDropMenu *)menu titleForColumn:(NSInteger)column {
    if (column == 0) {
        return @"犬种";
    } else if (column == 1) {
        return @"犬龄";
    } else if (column == 2) {
        return @"体型";
    }
    return nil;
}

- (void)menuFilterSelectDogType:(NSString *)type {
    self.restoreFilters[TypeFilterKey] = self.typeFilter;
    self.typeFilter = type;
    
    [self.collectionView headerBeginRefreshing];
}

- (void)menuFilterSelectSize:(YZDogSize)size {
    self.restoreFilters[SizeFilterKey] = @(self.sizeFilter);
    self.sizeFilter = size;
    
    [self.collectionView headerBeginRefreshing];
}

- (void)menuFilterSelectValue:(YZDogValueRange)value sex:(YZDogSex)sex {
    self.restoreFilters[SexFilterKey] = @(self.sexFilter);
    self.sexFilter = sex;
    
    self.restoreFilters[PriceFilterKey] = @(self.valueRangeFilter);
    self.valueRangeFilter = value;

    [self.collectionView headerBeginRefreshing];
}

- (void)menuFilterSelectAge:(YZDogAgeRange)age {
    self.restoreFilters[AgeFilterKey] = @(self.ageRangeFilter);
    self.ageRangeFilter = age;
    
    [self.collectionView headerBeginRefreshing];
}

#pragma mark -- UICollectionView

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YZShangChengDogListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
    cell.dogModel = self.items[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    YZDogDetailVC *detailVC = [[YZDogDetailVC alloc] init];
    YZDogModel *dogModel = self.items[indexPath.row];
    detailVC.dogModel = dogModel;
    detailVC.hideNaviBg = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -- UISearchBarDelegate

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

@end
