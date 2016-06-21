//
//  HuDongImageTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 15/3/31.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface HuDongImageTableViewCell : UITableViewCell
@property (nonatomic,strong) EGOImageView * imageV;
@property (nonatomic,strong) NSDictionary * imageDict;
@property (nonatomic,assign) int imageNum;
@property (nonatomic,strong) UIView * lineV;
@property (nonatomic,assign) int imageIndex;
@end
