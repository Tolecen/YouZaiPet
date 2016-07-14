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
#import "YZQuanSheSearchListCell.h"
#import "MJRefresh.h"
#import "NetServer+ShangCheng.h"
#import "YZGoodsDetailVC.h"
#import "YZDogDetailVC.h"
#import "MLKMenuPopover.h"

@interface YZSearchViewController()<UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, MLKMenuPopoverDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) YZShangChengType searchType;
@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, copy) NSString *dogkeyword;
@property (nonatomic, copy) NSString *quansheKeyword;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) MLKMenuPopover *menuPopover;
@property (nonatomic, weak) UIButton *searchBtn;

@end

@implementation YZSearchViewController

- (void)dealloc {
    _items = nil;
}

- (void)inner_Pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex {
    [UIView animateWithDuration:.5 animations:^{
        self.searchBtn.imageView.layer.affineTransform = CGAffineTransformRotate(self.searchBtn.imageView.layer.affineTransform, M_PI);
    }];
    if (selectedIndex == 0) {
        self.searchType = YZShangChengType_Dog;
        [self.searchBtn setTitle:@"狗狗" forState:UIControlStateNormal];
    } else if (selectedIndex == 1) {
        self.searchType = YZShangChengType_Goods;
        [self.searchBtn setTitle:@"犬舍" forState:UIControlStateNormal];
    }
}

- (MLKMenuPopover *)menuPopover {
    if (!_menuPopover) {
        _menuPopover = [[MLKMenuPopover alloc] initWithFrame:CGRectMake(10, 0, 90, 88)
                                                   menuItems:@[@"狗狗",@"犬舍"]
                                                  imageItems:@[@"search_gou", @"search_quanshe"]];
        _menuPopover.menuPopoverDelegate = self;
    }
    return _menuPopover;
}

- (void)inner_ChangeSearchStyle:(UIButton *)sender {
    if (self.menuPopover.menuShow) {
        [UIView animateWithDuration:.5 animations:^{
            self.searchBtn.imageView.layer.affineTransform = CGAffineTransformRotate(self.searchBtn.imageView.layer.affineTransform, M_PI);
        }];
        [self.menuPopover dismissMenuPopover];
    } else {
        [UIView animateWithDuration:.5 animations:^{
            self.searchBtn.imageView.layer.affineTransform = CGAffineTransformRotate(self.searchBtn.imageView.layer.affineTransform, M_PI);
        }];
        [self.menuPopover showInView:self.view];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入狗狗种类/犬舍名称";
    [self.navigationItem setTitleView:searchBar];
    self.searchBar = searchBar;

    self.searchType = YZShangChengType_Dog;
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"狗狗" forState:UIControlStateNormal];
    [searchBtn setImage:[UIImage imageNamed:@"search_arrow"] forState:UIControlStateNormal];
    searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [searchBtn sizeToFit];
    [searchBtn addTarget:self action:@selector(inner_ChangeSearchStyle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.leftBarButtonItem = searchBarButtonItem;
    self.searchBtn = searchBtn;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [cancelBtn sizeToFit];
    [cancelBtn addTarget:self action:@selector(inner_Pop:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10.f;
    flowLayout.minimumLineSpacing = 10.f;
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.sectionInset = sectionInset;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor colorWithRed:.9
                                                     green:.9
                                                      blue:.9
                                                     alpha:1.f];
    [collectionView registerClass:[YZQuanSheSearchListCell class] forCellWithReuseIdentifier:NSStringFromClass(YZQuanSheSearchListCell.class)];
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
    NSInteger pageIndex = loadMore ? self.pageIndex : 0;
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
    NSInteger pageIndex = loadMore ? self.pageIndex : 0;
    WS(weakSelf);
    [NetServer searchQuanSheListWithShopName:keyword
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

#pragma mark -- UICollectionView

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchType == YZShangChengType_Dog) {
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - 30) / 2;
        return CGSizeMake(width,
                          width / 5 * 6);
    } else {
        return CGSizeMake(ScreenWidth - 20, 80);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YZQuanSheSearchListCell *quanSheCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(YZQuanSheSearchListCell.class) forIndexPath:indexPath];
    YZShangChengDogListCell *dogCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(YZShangChengDogListCell.class) forIndexPath:indexPath];
    id searchModel = self.items[indexPath.row];
    if ([searchModel isKindOfClass:[YZDogModel class]]) {
        dogCell.dogModel = searchModel;
        return dogCell;
    } else if ([searchModel isKindOfClass:[YZQuanSheModel class]]) {
        quanSheCell.quanSheModel = searchModel;
        return quanSheCell;
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
