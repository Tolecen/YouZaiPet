//
//  PrizeTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 15/3/9.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface PrizeTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView * bgV;
@property (nonatomic,strong) EGOImageView * prizeV;
@property (nonatomic,strong) UILabel * nameL;
@property (nonatomic,strong) UILabel * statusL;
@property (nonatomic,strong) UILabel * readL;
@property (nonatomic,strong) NSDictionary * awardDict;
@end
