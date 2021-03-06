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
            
            if (i==0) {
                self.unreadBgV = [[UIImageView alloc] initWithFrame:CGRectMake(70-26, 0, 26, 16)];
                [self.unreadBgV setImage:[UIImage imageNamed:@"unreadNumBg"]];
                [button addSubview:self.unreadBgV];
                
                self.unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, 25, 16)];
                [self.unreadLabel setTextColor:[UIColor whiteColor]];
                [self.unreadLabel setBackgroundColor:[UIColor clearColor]];
                [self.unreadLabel setTextAlignment:NSTextAlignmentCenter];
                self.unreadLabel.adjustsFontSizeToFitWidth = YES;
                [self.unreadLabel setFont:[UIFont systemFontOfSize:13]];
                [self.unreadBgV addSubview:self.unreadLabel];
                self.unreadBgV.hidden = YES;
            }
            else if (i==2){
                self.unreadBgVOrder = [[UIImageView alloc] initWithFrame:CGRectMake(70-26, 0, 26, 16)];
                [self.unreadBgVOrder setImage:[UIImage imageNamed:@"unreadNumBg"]];
                [button addSubview:self.unreadBgVOrder];
                
                self.unreadLabelOrder = [[UILabel alloc] initWithFrame:CGRectMake(1, 0, 25, 16)];
                [self.unreadLabelOrder setTextColor:[UIColor whiteColor]];
                [self.unreadLabelOrder setBackgroundColor:[UIColor clearColor]];
                [self.unreadLabelOrder setTextAlignment:NSTextAlignmentCenter];
                self.unreadLabelOrder.adjustsFontSizeToFitWidth = YES;
                [self.unreadLabelOrder setFont:[UIFont systemFontOfSize:13]];
                [self.unreadBgVOrder addSubview:self.unreadLabelOrder];
                self.unreadBgV.hidden = YES;

            }
            
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
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.cartCount>0) {
        self.unreadBgV.hidden = NO;
        self.unreadLabel.text = [NSString stringWithFormat:@"%d",self.cartCount];
    }
    else
        self.unreadBgV.hidden = YES;
    
    if (self.orderCount>0) {
        self.unreadBgVOrder.hidden = NO;
        self.unreadLabelOrder.text = [NSString stringWithFormat:@"%d",self.orderCount];
    }
    else
        self.unreadBgVOrder.hidden = YES;
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
