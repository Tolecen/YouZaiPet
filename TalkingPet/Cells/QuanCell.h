//
//  QuanCell.h
//  TalkingPet
//
//  Created by Tolecen on 15/7/23.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuanCell : UITableViewCell
@property (nonatomic,strong)UIImageView * topImageV;
@property (nonatomic,strong)UILabel * titleL;
@property (nonatomic,strong)UILabel * priceL;
@property (nonatomic,strong)UILabel * desL1;
@property (nonatomic,strong)UILabel * desL2;
@property (nonatomic,strong)UILabel * timeL;
@property (nonatomic,strong)UIImageView * checmarkView;
@property (nonatomic,strong)NSString * thePriceStr;
@property (nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,assign)BOOL isSelected;
@property (nonatomic,assign)NSInteger cellIndex;
@property (nonatomic,strong)NSDictionary * quanDict;
@property (nonatomic,strong)UIImageView * statusImageV;
@end

