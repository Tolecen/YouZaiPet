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

@interface YZShangChengListVC()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation YZShangChengListVC

- (void)inner_Pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAnotherBackButtonWithTarget:@selector(inner_Pop:)];
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
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
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
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
