//
//  MarketDetailCell.m
//  TalkingPet
//
//  Created by cc on 16/8/7.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "MarketDetailCell.h"
#import "MarketCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "YZGoodsDetailVC.h"
@interface MarketDetailCell()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic ,strong)UIImageView *bgImgV;
@property (nonatomic ,strong)UIImageView *blankImgV;
@property (nonatomic ,strong)UILabel *titleL;
@property (nonatomic ,strong)UILabel *subtitleL;
@property (nonatomic ,strong)UICollectionView *collectionView;




@end


@implementation MarketDetailCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        
        self.bgImgV=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 170)];
        //        self.bgImgV.image= [UIImage imageNamed:@"tuangou"];
        [self.contentView addSubview:self.bgImgV];
        //背景层上半透明的遮盖层
        UIView *translucentV=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bgImgV.frame.size.width-152, self.bgImgV.frame.size.height-60)];
        translucentV.alpha=0.6;
        translucentV.center=CGPointMake(ScreenWidth/2, 85);
        translucentV.backgroundColor=[UIColor whiteColor];
        [self.bgImgV addSubview: translucentV];
        
        
        self.titleL=[[UILabel alloc] initWithFrame:CGRectMake(0, 57, 250, 15)];
        self.titleL.font=[UIFont boldSystemFontOfSize:15];
        self.titleL.center=CGPointMake(ScreenWidth/2, self.titleL.center.y);
        self.titleL.textColor=[UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
        self.titleL.textAlignment=NSTextAlignmentCenter;
        [self.bgImgV addSubview:self.titleL];
        
        
        
        
        UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(0, 82, 50, 1)];
        label1.backgroundColor=[UIColor lightGrayColor];
        label1.center=CGPointMake(ScreenWidth/2, 82.5f);
        label1.alpha=0.5f;
        [self.bgImgV addSubview:label1];
        
        
        
        
        self.subtitleL=[[UILabel alloc] initWithFrame:CGRectMake(0, 99, 250, 12)];
        self.subtitleL.font=[UIFont systemFontOfSize:12];
        self.subtitleL.center=CGPointMake(ScreenWidth/2, self.subtitleL.center.y);
        self.subtitleL.textAlignment=NSTextAlignmentCenter;
        self.subtitleL.textColor=[UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
        [self.bgImgV addSubview:self.subtitleL];
        
        UICollectionViewFlowLayout *cLayout=[[UICollectionViewFlowLayout alloc] init];
        
        cLayout.minimumInteritemSpacing = 1;
        cLayout.minimumLineSpacing = 5;
        
        UIEdgeInsets sectionInset = UIEdgeInsetsMake(7.5, 5, 7.5, 5);
        cLayout.sectionInset = sectionInset;
        //        CGFloat width = (ScreenWidth-20-15)/4;
        cLayout.itemSize = CGSizeMake(85,
                                      125);
        cLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 170, ScreenWidth, 140) collectionViewLayout:cLayout];
        self.collectionView.delegate=self;
        self.collectionView.dataSource=self;
        self.collectionView.backgroundColor=[UIColor whiteColor];
        [self.collectionView registerClass:[MarketCollectionViewCell class] forCellWithReuseIdentifier:@"MarketCollectionViewCell"];
        [self.collectionView registerClass:[MarketCollectionViewCell class] forCellWithReuseIdentifier:@"MarketCollectionViewCell1"];
        
        [self addSubview:self.collectionView];
        
    }
    return self;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.model items].count+1;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
    
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SectionCellIdentifier = @"MarketCollectionViewCell";
    
    if(indexPath.row==[[self.model items] count])
    {
        MarketCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MarketCollectionViewCell1" forIndexPath:indexPath];
        [cell hiedenLabel];
        
        return cell;
    }
    else{
        MarketCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SectionCellIdentifier forIndexPath:indexPath];
        cell.model=self.model.items[indexPath.row];
        return cell;
    }
    
    
    
}

-(void)setModel:(MarketDetailModel *)model
{
    _model=model;
    self.titleL.text=model.title;
    self.subtitleL.text=model.subtitle;
    [self.bgImgV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:@"dog_placeholder"]];
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==[[self.model items] count]) {
        self.block(nil);
    }
    else
    {
        CommodityModel *goodsModel = self.model.items[indexPath.row];
        self.block(goodsModel);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
