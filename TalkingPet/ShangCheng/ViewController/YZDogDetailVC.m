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
#import "YZShangChengDetailImageCell.h"
#import "YZShangChengDogListCell.h"
#import "YZDetailBottomBar.h"
#import "NetServer+ShangCheng.h"

@interface YZDogDetailVC()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) YZDogDetailModel *detailModel;

@property (nonatomic, copy) NSArray *items;

@end

@implementation YZDogDetailVC

- (void)dealloc {
    _dogId = nil;
    _detailModel = nil;
    _items = nil;
}

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
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                                          0,
                                                                                          ScreenWidth,
                                                                                          ScreenWidth)
                                                          collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor colorWithRed:.9
                                                     green:.9
                                                      blue:.9
                                                     alpha:1.f];
    [collectionView registerClass:[YZShangChengDetailImageCell class] forCellWithReuseIdentifier:NSStringFromClass(self.class)];
    [collectionView registerClass:[YZShangChengDogListCell class] forCellWithReuseIdentifier:NSStringFromClass(self.class)];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    
    YZDetailBottomBar *bottomBar = [[YZDetailBottomBar alloc] initWithFrame:CGRectZero type:YZShangChengType_Dog];
    [self.view addSubview:bottomBar];
    [bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view).mas_offset(0);
        make.height.mas_offset(50);
    }];
    
    [self inner_GetDogDetail];
}

- (void)inner_GetDogDetail {
    if (!self.dogId) {
        return;
    }
    WS(weakSelf);
    [NetServer getDogDetailInfoWithDogId:self.dogId
                                 success:^(YZDogDetailModel *detailModel) {
                                     weakSelf.detailModel = detailModel;
                                     [weakSelf.collectionView reloadData];
                                 }
                                 failure:^(NSError *error, AFHTTPRequestOperation *operation) {
                                     
                                 }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self showNaviBg];
}

#pragma mark -- UICollectionView

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeZero;
    }
    CGFloat width = (ScreenWidth - 30) / 2;
    return CGSizeMake(width,
                      width / 5 * 6);
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YZShangChengDetailImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
    cell.backgroundColor = RandomColor;
    return cell;
}

@end
