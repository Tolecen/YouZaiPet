//
//  MonthBoxViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/6/8.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "MonthBoxViewController.h"
#import "MJRefresh.h"
#import "EGOImageView.h"
#import "ClothDetailViewController.h"

@interface PetFoodCell : UICollectionViewCell
@property (nonatomic,retain)EGOImageView * imageView;
@property (nonatomic,retain)UILabel * textL;
@property (nonatomic,retain)UILabel * moneyL;
@property (nonatomic,retain)UILabel * mMonerL;
@end
@implementation PetFoodCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.imageView = [[EGOImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width-10, frame.size.width-10)];
        _imageView.placeholderImage = [UIImage imageNamed:@"browser_avatarPlaceholder"];
        [self.contentView addSubview:_imageView];
        
        self.textL = [[UILabel alloc] initWithFrame:CGRectMake(5, frame.size.width, frame.size.width-10, 12)];
        _textL.textColor = [UIColor blackColor];
        _textL.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:_textL];
        UILabel * priceL = [[UILabel alloc]initWithFrame:CGRectMake(5, frame.size.width + 17, frame.size.width-10, 12)];
        priceL.text = @"优惠价格:";
        priceL.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
        priceL.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:priceL];
        UILabel * mPriceL = [[UILabel alloc]initWithFrame:CGRectMake(5, frame.size.width + 34, frame.size.width-10, 12)];
        mPriceL.text = @"M卡价格:";
        mPriceL.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
        mPriceL.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:mPriceL];
        self.moneyL = [[UILabel alloc] initWithFrame:CGRectMake(55, 17+frame.size.width, frame.size.width-55, 12)];
        _moneyL.textColor = [UIColor colorWithRed:254/255.0 green:144/255.0 blue:83/255.0 alpha:1];
        _moneyL.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_moneyL];
        self.mMonerL = [[UILabel alloc] initWithFrame:CGRectMake(55, 34+frame.size.width, frame.size.width-55, 12)];
        _mMonerL.textColor = [UIColor colorWithRed:254/255.0 green:144/255.0 blue:83/255.0 alpha:1];
        _mMonerL.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_mMonerL];
    }
    return self;
}
@end

@interface PetFoodReusableView : UICollectionReusableView
@property (nonatomic,retain)UILabel * titleLable;
@end
@implementation PetFoodReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        [self addSubview:_titleLable];
        _titleLable.backgroundColor = [UIColor clearColor];
        _titleLable.textColor = [UIColor colorWithWhite:120/255.0 alpha:1];
    }
    return self;
}
@end

@interface MonthBoxViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,retain)UICollectionView * petFoodView;
@end
@implementation MonthBoxViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    self.title = @"月光宝盒";
    [self setBackButtonWithTarget:@selector(backBtnDo)];
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
    float whith = (self.view.frame.size.width-15)/2;
    layout.itemSize = CGSizeMake(whith,whith+50);
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.petFoodView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-navigationBarHeight) collectionViewLayout:layout];
    _petFoodView.delegate = self;
    _petFoodView.dataSource = self;
    _petFoodView.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1];
    [self.view addSubview:_petFoodView];
    _petFoodView.showsVerticalScrollIndicator = NO;
    [_petFoodView registerClass:[PetFoodCell class] forCellWithReuseIdentifier:@"PetFoodCell"];
    [_petFoodView registerClass:[PetFoodReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [_petFoodView addHeaderWithTarget:self action:@selector(getAllBoxlist)];
//    [_petFoodView headerBeginRefreshing];
}
- (void)getAllBoxlist
{
    
}
- (void)backBtnDo
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if (_dataArr.count==0) {
//        _hotView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width+30);
//    }
    return 2;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width, 40);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SectionCellIdentifier = @"PetFoodCell";
    PetFoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SectionCellIdentifier forIndexPath:indexPath];
    cell.imageView.imageURL = nil;
    cell.textL.text = @"狗粮或者猫粮";
    cell.moneyL.text = @"￥599";
    cell.mMonerL.text = @"￥399";
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sdentifier = @"header";
    PetFoodReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:sdentifier forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:{
            header.titleLable.text = @"成犬专区";
        }break;
        case 1:{
            header.titleLable.text = @"幼犬专区";
        }break;
        case 2:{
            header.titleLable.text = @"猫咪专区";
        }break;
        default:
            break;
    }
    return header;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClothDetailViewController * vc = [[ClothDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
