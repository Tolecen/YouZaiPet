//
//  HuDongDetailTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 15/3/31.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "HuDongListTableViewCell.h"
@class RootViewController;
@interface HuDongDetailTableViewCell : UITableViewCell<HuDongListCellDelegate>
@property (nonatomic,strong)EGOImageButton * publisherAvatarV;
@property (nonatomic,strong)UIImageView * genderImageV;
@property (nonatomic,strong)UILabel * publisherNameL;
@property (nonatomic,strong)UILabel * timeL;
@property (nonatomic,strong)UIButton *favorBtn;
@property (nonatomic,strong)UIImageView * favorImgV;
@property (nonatomic,strong)UILabel * favorLabel;
@property (nonatomic,strong)UILabel * contentL;
@property (nonatomic,strong)NSMutableDictionary * contentDict;
@property (nonatomic,assign)id<HuDongListCellDelegate>delegate;
@property (nonatomic,strong) UIView * lineV;
@end
