//
//  UserCenterGouWuFuncTableViewCell.h
//  TalkingPet
//
//  Created by TaoXinle on 16/7/11.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCenterGouWuFuncTableViewCell : UITableViewCell
@property (nonatomic,copy)void(^buttonClicked) (int index);
@property (nonatomic,assign)int cartCount;
@property (nonatomic,assign)int orderCount;
@property (nonatomic,strong) UIImageView * unreadBgV;
@property (nonatomic,strong) UILabel * unreadLabel;

@property (nonatomic,strong) UIImageView * unreadBgVOrder;
@property (nonatomic,strong) UILabel * unreadLabelOrder;
@end
