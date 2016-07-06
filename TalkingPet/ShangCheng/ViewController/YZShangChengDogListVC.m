//
//  YZShangChengListVC.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/23.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShangChengDogListVC.h"
#import "YZShangChengDetailVC.h"
#import "YZShangChengDropMenu.h"
#import "YZShangChengDogListCell.h"

@interface YZShangChengDogListVC()<UICollectionViewDataSource, UICollectionViewDelegate, YZDropMenuDataSource, YZDropMenuDelegate, UISearchBarDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, weak) YZShangChengDropMenu *dropMenu;

@end

@implementation YZShangChengDogListVC

- (void)dealloc {
    NSLog(@"dealloc:[%@]", self);
}

- (void)inner_Pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)inner_MoreAction:(id)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImage *backImage = [UIImage imageNamed:@"shangcheng_back_icon"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStyleDone target:self action:@selector(inner_Pop:)];
    self.navigationItem.leftBarButtonItem = backButtonItem;

    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.placeholder = @"test";
    [self.navigationItem setTitleView:searchBar];
    
    YZShangChengDropMenu *dropMenu = [[YZShangChengDropMenu alloc] initWithFrame:CGRectZero];
    dropMenu.delegate = self;
    dropMenu.dataSource = self;
    [self.view addSubview:dropMenu];
    self.dropMenu = dropMenu;
    
//    UIImage *image = [UIImage imageNamed:@"navigation_more_icon"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIBarButtonItem *rightMoreItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(inner_MoreAction:)];
//    self.navigationItem.rightBarButtonItem = rightMoreItem;
    
    [dropMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(0);
        make.top.mas_equalTo(self.view).mas_offset(0);
        make.right.mas_equalTo(self.view).mas_offset(0);
        make.height.mas_equalTo(44);
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10.f;
    flowLayout.minimumLineSpacing = 10.f;
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.sectionInset = sectionInset;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - sectionInset.left - sectionInset.right - 10) / 2;
    flowLayout.itemSize = CGSizeMake(width,
                                     width * 4 / 3);
    
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

#pragma mark -- UICollectionView

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YZShangChengDogListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 25;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    YZShangChengDetailVC *detailVC = [[YZShangChengDetailVC alloc] init];
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
