//
//  ITTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 14/10/23.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView * imageV;
@property (nonatomic,strong) UILabel * desLabel;
@property (nonatomic,strong) UIImageView * unreadBgV;
@property (nonatomic,strong) UILabel * unreadLabel;
-(void)setUnreadNum:(NSString *)unreadNum;
@end
