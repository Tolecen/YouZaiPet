//
//  YZSearchViewController.m
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/12.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZSearchViewController.h"
#import "YZShangChengConst.h"
#import "YZShangChengDogListCell.h"
#import "YZShangChengGoodsListCell.h"
#import "MJRefresh.h"
#import "NetServer+ShangCheng.h"
#import "YZGoodsDetailVC.h"
#import "YZDogDetailVC.h"
#import "MLKMenuPopover.h"

@interface YZSearchViewController()<UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, MLKMenuPopoverDelegate>

@property (nonatomic, assign) YZShangChengType searchType;
@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, copy) NSString *dogkeyword;
@property (nonatomic, copy) NSString *quansheKeyword;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) MLKMenuPopover *menuPopover;

@end

@implementation YZSearchViewController

- (void)dealloc {
    _items = nil;
}

- (void)inner_Pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex {
    [self.menuPopover dismissMenuPopover];
    if (selectedIndex == 0) {
        self.searchType = YZShangChengType_Dog;
    } else {
        self.searchType = YZShangChengType_Goods;
    }
}

- (MLKMenuPopover *)menuPopover {
    if (!_menuPopover) {
        _menuPopover = [[MLKMenuPopover alloc] initWithFrame:CGRectMake(ScreenWidth - 90, 0, 80, 88)
                                                   menuItems:@[@"搜狗狗",@"搜犬舍"]];
        _menuPopover.menuPopoverDelegate = self;
    }
    return _menuPopover;
}

- (void)inner_ChangeSearchStyle:(UIButton *)sender {
    if (self.menuPopover.menuShow) {
        [self.menuPopover dismissMenuPopover];
    } else {
        [self.menuPopover showInView:self.view];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *backImage = [UIImage imageNamed:@"shangcheng_back_icon"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStyleDone target:self action:@selector(inner_Pop:)];
    self.navigationItem.leftBarButtonItem = backButtonItem;
        
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入狗狗种类/犬舍名称";
    [self.navigationItem setTitleView:searchBar];
    self.searchBar = searchBar;

    self.searchType = YZShangChengType_Dog;
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜狗狗" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [searchBtn sizeToFit];
    [searchBtn addTarget:self action:@selector(inner_ChangeSearchStyle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = searchBarButtonItem;
    
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
    [collectionView registerClass:[YZShangChengGoodsListCell class] forCellWithReuseIdentifier:NSStringFromClass(YZShangChengGoodsListCell.class)];
    [collectionView registerClass:[YZShangChengDogListCell class] forCellWithReuseIdentifier:NSStringFromClass(YZShangChengDogListCell.class)];

    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(0);
        make.top.mas_equalTo(self.view).mas_offset(0);
        make.right.mas_equalTo(self.view).mas_offset(0);
        make.bottom.mas_equalTo(self.view).mas_offset(0);
    }];
    
    [collectionView addHeaderWithTarget:self action:@selector(inner_Refresh:)];
    [collectionView addFooterWithTarget:self action:@selector(inner_LoadMore:)];
}

- (void)inner_Refresh:(id)sender {
    if (self.searchType == YZShangChengType_Dog) {
        [self inner_SearchDogListWithKeyword:self.dogkeyword loadMore:NO];
    } else {
        [self inner_SearchQuanSheListWithKeyword:self.quansheKeyword loadMore:NO];
    }
}

- (void)inner_LoadMore:(id)sender {
    if (self.searchType == YZShangChengType_Dog) {
        [self inner_SearchDogListWithKeyword:self.dogkeyword loadMore:YES];
    } else {
        [self inner_SearchQuanSheListWithKeyword:self.quansheKeyword loadMore:YES];
    }
}

- (void)inner_SearchDogListWithKeyword:(NSString *)keyword loadMore:(BOOL)loadMore {
    NSInteger pageIndex = loadMore ? self.pageIndex : 1;
    WS(weakSelf);
    [self.collectionView footerEndRefreshing];
    [self.collectionView headerEndRefreshing];
    [NetServer searchDogListWithType:nil
                             keyword:keyword
                                size:YZDogSize_All
                                 sex:YZDogSex_All
                           sellPrice:YZDogValueRange_All
                                area:nil
                                 age:YZDogAgeRange_All
                              shopId:nil
                           pageIndex:pageIndex
                             success:^(NSArray *items, NSInteger nextPageIndex) {
                                 weakSelf.pageIndex = nextPageIndex;
                                 if (loadMore) {
                                     weakSelf.items = [[NSArray arrayWithArray:weakSelf.items] arrayByAddingObjectsFromArray:items];
                                 } else {
                                     weakSelf.items = [NSArray arrayWithArray:items];
                                 }
                                 [weakSelf.collectionView footerEndRefreshing];
                                 [weakSelf.collectionView headerEndRefreshing];
                                 [weakSelf.collectionView reloadData];
                             }
                             failure:^(NSError *error, AFHTTPRequestOperation *operation) {
                                 [weakSelf.collectionView footerEndRefreshing];
                                 [weakSelf.collectionView headerEndRefreshing];
                             }];
}

- (void)inner_SearchQuanSheListWithKeyword:(NSString *)keyword loadMore:(BOOL)loadMore {
    [self.collectionView footerEndRefreshing];
    [self.collectionView headerEndRefreshing];
    self.quansheKeyword = keyword;
    NSInteger pageIndex = loadMore ? self.pageIndex : 1;
    WS(weakSelf);
    [NetServer searchQuanSheListWithShopName:keyword
                                   pageIndex:pageIndex
                                     success:^(id data, NSInteger nextPageIndex) {
                                         [weakSelf.collectionView footerEndRefreshing];
                                         [weakSelf.collectionView headerEndRefreshing];
                                     }
                                     failure:^(NSError *error, AFHTTPRequestOperation *operation) {
                                         [weakSelf.collectionView footerEndRefreshing];
                                         [weakSelf.collectionView headerEndRefreshing];
                                     }];
}

#pragma mark -- UICollectionView

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YZShangChengGoodsListCell *goodsCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(YZShangChengGoodsListCell.class) forIndexPath:indexPath];
    YZShangChengDogListCell *dogCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(YZShangChengDogListCell.class) forIndexPath:indexPath];
    id searchModel = self.items[indexPath.row];
    if ([searchModel isKindOfClass:[YZDogModel class]]) {
        dogCell.dogModel = searchModel;
        return dogCell;
    } else if ([searchModel isKindOfClass:[YZGoodsModel class]]) {
        goodsCell.goods = searchModel;
        return goodsCell;
    }
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    id searchModel = self.items[indexPath.row];
    if ([searchModel isKindOfClass:[YZDogModel class]]) {
        YZDogDetailVC *detailVC = [[YZDogDetailVC alloc] init];
        detailVC.dogModel = searchModel;
        detailVC.hideNaviBg = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    } else if ([searchModel isKindOfClass:[YZGoodsModel class]]) {
        YZGoodsDetailVC *detailVC = [[YZGoodsDetailVC alloc] init];
        YZGoodsModel *goodsModel = searchModel;
        detailVC.goodsId = goodsModel.goodsId;
        detailVC.goodsName = goodsModel.brand.brand;
        detailVC.hideNaviBg = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark -- UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (self.searchType == YZShangChengType_Dog) {
        self.dogkeyword = searchBar.text;
    } else {
        self.quansheKeyword = searchBar.text;
    }
    [searchBar resignFirstResponder];
    [self.collectionView headerBeginRefreshing];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchBar resignFirstResponder];
}

@end