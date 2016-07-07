//
//  YZQuanSheDetailViewController.m
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/7.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZQuanSheDetailViewController.h"
#import "YZShangChengDetailVC.h"
#import "YZShangChengDogListCell.h"
#import "YZQuanSheDetailCollectionHeaderView.h"
#import "YZQuanSheDetailIntroView.h"

@interface YZQuanSheDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) YZQuanSheDetailIntroView *quanSheIntroView;

@end

@implementation YZQuanSheDetailViewController

- (void)dealloc {
    _quanSheIntroView = nil;
}

- (NSString *)title {
    return @"汉源犬舍";
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
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.sectionInset = sectionInset;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - sectionInset.left - sectionInset.right - 10) / 2;
    flowLayout.itemSize = CGSizeMake(width,
                                     width / 5 * 6);
    flowLayout.headerReferenceSize = CGSizeMake(50, 200);

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor colorWithRed:.9
                                                     green:.9
                                                      blue:.9
                                                     alpha:1.f];
    [collectionView registerClass:[YZShangChengDogListCell class] forCellWithReuseIdentifier:NSStringFromClass(self.class)];
    [collectionView registerClass:[YZQuanSheDetailCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(YZQuanSheDetailCollectionHeaderView.class)];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    
    self.quanSheIntroView = [[YZQuanSheDetailIntroView alloc] init];
    [self.view addSubview:self.quanSheIntroView];
    [self.quanSheIntroView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
}

- (void)inner_ShowQuanSheIntroView {
    [self.quanSheIntroView show];
}

#pragma mark -- UICollectionView

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YZShangChengDogListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        YZQuanSheDetailCollectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass(YZQuanSheDetailCollectionHeaderView.class) forIndexPath:indexPath];
        __weak __typeof(self) weakSelf = self;
        [header setShowQuanSheIntroBlock:^{
            [weakSelf inner_ShowQuanSheIntroView];
        }];
        return header;
    }
    return nil;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
