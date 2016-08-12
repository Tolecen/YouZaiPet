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
        
        
        
        
        self.bgImgV=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 160)];
        //        self.bgImgV.image= [UIImage imageNamed:@"tuangou"];
        [self.contentView addSubview:self.bgImgV];
        
        //背景层上半透明的遮盖层
        UIView *translucentV=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bgImgV.frame.size.width*0.8, self.bgImgV.frame.size.height*0.6)];
        translucentV.alpha=0.4;
        translucentV.center=CGPointMake(ScreenWidth/2, 80);
        translucentV.backgroundColor=[UIColor whiteColor];
        [self.bgImgV addSubview: translucentV];
        
        
        self.titleL=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, 250, 30)];
        self.titleL.font=[UIFont systemFontOfSize:20];
        
        self.titleL.center=CGPointMake(translucentV.frame.size.width/2, self.titleL.center.y);
        
        
        self.titleL.textAlignment=NSTextAlignmentCenter;
        
        
        
        [translucentV addSubview:self.titleL];
        
        self.subtitleL=[[UILabel alloc] initWithFrame:CGRectMake(0, 50, 250, 30)];
        self.subtitleL.font=[UIFont systemFontOfSize:15];
        self.subtitleL.center=CGPointMake(translucentV.frame.size.width/2, self.subtitleL.center.y);
        self.subtitleL.textAlignment=NSTextAlignmentCenter;
        
        [translucentV addSubview:self.subtitleL];
        
        UICollectionViewFlowLayout *cLayout=[[UICollectionViewFlowLayout alloc] init];
        
        cLayout.minimumInteritemSpacing = 1;
        cLayout.minimumLineSpacing = 5;
        
        UIEdgeInsets sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        cLayout.sectionInset = sectionInset;
        //        CGFloat width = (ScreenWidth-20-15)/4;
        cLayout.itemSize = CGSizeMake(70,
                                      100);
        cLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 160, ScreenWidth, 120) collectionViewLayout:cLayout];
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
