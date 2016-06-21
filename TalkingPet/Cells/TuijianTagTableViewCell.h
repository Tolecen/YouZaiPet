//
//  TuijianTagTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 15/7/1.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "TalkingBrowse.h"
@interface TuijianTagTableViewCell : UITableViewCell
@property (nonatomic,strong)EGOImageView * iconV;
@property (nonatomic,strong)UILabel * titleL;
@property (nonatomic,strong)UILabel * desL;
@property (nonatomic,strong)NSDictionary * tagDict;
@end
