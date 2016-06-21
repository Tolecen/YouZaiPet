//
//  TopicTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 15/3/26.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface TopicTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * liulanL;
@property (nonatomic,strong) EGOImageView * contentImageV;
@property (nonatomic,strong) NSDictionary * theDict;
@end
