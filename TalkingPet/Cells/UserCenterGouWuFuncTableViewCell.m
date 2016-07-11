//
//  UserCenterGouWuFuncTableViewCell.m
//  TalkingPet
//
//  Created by TaoXinle on 16/7/11.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "UserCenterGouWuFuncTableViewCell.h"

@implementation UserCenterGouWuFuncTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray * titleArray = @[@"购物车",@"地址管理",@"我的订单"];
        NSArray * imgArray = @[@"gouwuche@2x",@"dizhiguanli@2x",@"wodedingdan@2x"];
        
        float sep = (ScreenWidth-70*3-80)/2;
        
        for (int i = 0; i<titleArray.count; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(40+sep*i+70*i, 20, 70, 70)];
            [button setBackgroundImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
            [self.contentView addSubview:button];
            button.tag = i+1;
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel * cl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(button.frame), CGRectGetMaxY(button.frame)+10, 70, 20)];
            cl.backgroundColor = [UIColor clearColor];
            cl.textAlignment = NSTextAlignmentCenter;
            cl.font = [UIFont systemFontOfSize:15];
            cl.textColor = [UIColor colorWithR:150 g:150 b:150 alpha:1];
            cl.text = titleArray[i];
            [self.contentView addSubview:cl];
//            cl.tag = i+1;
        }
    }
    return self;
}
-(void)buttonClicked:(UIButton *)sender
{
    if (self.buttonClicked) {
        self.buttonClicked((int)sender.tag-1);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
