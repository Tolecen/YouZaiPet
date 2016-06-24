//
//  YZShangChengKindScrollCell.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/25.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShangChengKindScrollCell.h"
#import "YZDogKindCollectionViewCell.h"

@interface YZShangChengKindScrollCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation YZShangChengKindScrollCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0.f;
        flowLayout.minimumLineSpacing = 15.f;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UIEdgeInsets sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flowLayout.sectionInset = sectionInset;
        flowLayout.itemSize = CGSizeMake(45,
                                         60);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                              collectionViewLayout:flowLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerClass:[YZDogKindCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass(YZDogKindCollectionViewCell.class)];
        [self.contentView addSubview:collectionView];
        self.collectionView = collectionView;
        
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}

#pragma mark -- UICollectionView

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YZDogKindCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(YZDogKindCollectionViewCell.class) forIndexPath:indexPath];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 25;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
