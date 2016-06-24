//
//  YZShangChengListVC.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/23.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShangChengListVC.h"
#import "YZShangChengDetailVC.h"
#import "YZShangChengDropMenu.h"
#import "YZShangChengListCell.h"

@interface YZShangChengListVC()<UICollectionViewDataSource, UICollectionViewDelegate, YZDropMenuDataSource, YZDropMenuDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, weak) YZShangChengDropMenu *dropMenu;

@end

@implementation YZShangChengListVC

- (void)inner_Pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(inner_Pop:)];
    YZShangChengDropMenu *dropMenu = [[YZShangChengDropMenu alloc] initWithFrame:CGRectZero];
    dropMenu.delegate = self;
    dropMenu.dataSource = self;
    [self.view addSubview:dropMenu];
    self.dropMenu = dropMenu;
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
    [collectionView registerClass:[YZShangChengListCell class] forCellWithReuseIdentifier:NSStringFromClass(self.class)];
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
    YZShangChengListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
    
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

@end
