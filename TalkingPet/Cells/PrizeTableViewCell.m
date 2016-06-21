//
//  PrizeTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 15/3/9.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "PrizeTableViewCell.h"

@implementation PrizeTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.bgV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, ScreenWidth-10, (ScreenWidth-10)*0.3)];
        self.bgV.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
        [self.contentView addSubview:self.bgV];
        
        self.prizeV = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, (ScreenWidth-10)*0.3-10, (ScreenWidth-10)*0.3-10)];
        self.prizeV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.prizeV];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(self.prizeV.frame.size.width+10+35, 20, ScreenWidth-2*((ScreenWidth-10)*0.3-10), 20)];
        self.nameL.backgroundColor = [UIColor clearColor];
        self.nameL.font = [UIFont systemFontOfSize:15];
        self.nameL.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.nameL];
        [self.nameL setLineBreakMode:NSLineBreakByCharWrapping];
        self.nameL.numberOfLines = 0;
        self.nameL.text = @"白色的泰迪熊啊走过路过不要错过";
        
        self.statusL = [[UILabel alloc] initWithFrame:CGRectMake(self.prizeV.frame.size.width+10+35, (ScreenWidth-10)*0.3-40, 140, 20)];
        self.statusL.backgroundColor = [UIColor clearColor];
        self.statusL.font = [UIFont systemFontOfSize:14];
        self.statusL.textColor = [UIColor whiteColor];
        self.statusL.text = @"进行中";
        [self.contentView addSubview:self.statusL];
        
        
        self.readL = [[UILabel alloc] initWithFrame:CGRectMake(self.prizeV.frame.size.width+10+35, (ScreenWidth-10)*0.3-20, 140, 20)];
        self.readL.backgroundColor = [UIColor clearColor];
        self.readL.font = [UIFont systemFontOfSize:12];
        self.readL.textColor = [UIColor whiteColor];
        self.readL.text = @"10";
        [self.contentView addSubview:self.readL];
        
                            
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if ([[self.awardDict objectForKey:@"catagory"] isEqualToString:@"1"]) {
        [self.bgV setImage:[UIImage imageNamed:@"prizelist_1"]];
    }
    else if ([[self.awardDict objectForKey:@"catagory"] isEqualToString:@"2"]) {
        [self.bgV setImage:[UIImage imageNamed:@"prizelist_2"]];
    }
    else if ([[self.awardDict objectForKey:@"catagory"] isEqualToString:@"3"]) {
        [self.bgV setImage:[UIImage imageNamed:@"prizelist_3"]];
    }
    self.prizeV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/80",[self.awardDict objectForKey:@"awardCover"]]];
    self.nameL.text = [self.awardDict objectForKey:@"awardName"];
    CGSize fg = [self.nameL.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(ScreenWidth-(self.prizeV.frame.size.width+10+35)-self.prizeV.frame.size.width, 40)  lineBreakMode:NSLineBreakByCharWrapping];
    [self.nameL setFrame:CGRectMake(self.prizeV.frame.size.width+10+35, 20, ScreenWidth-(self.prizeV.frame.size.width+10+35)-self.prizeV.frame.size.width, fg.height)];
    
    [self.readL setText:[NSString stringWithFormat:@"%@浏览",[self.awardDict objectForKey:@"viewCount"]]];
    
    if ([[self.awardDict objectForKey:@"state"] isEqualToString:@"1"]) {
        self.statusL.text = @"未开始";
    }
    else if ([[self.awardDict objectForKey:@"state"] isEqualToString:@"2"]) {
        self.statusL.text = @"可参与";
    }
    else if ([[self.awardDict objectForKey:@"state"] isEqualToString:@"3"]) {
        self.statusL.text = @"已参与";
    }
    else if ([[self.awardDict objectForKey:@"state"] isEqualToString:@"4"]) {
        self.statusL.text = @"进行中";
    }
    else if ([[self.awardDict objectForKey:@"state"] isEqualToString:@"5"]){
        self.statusL.text = @"已过期";
    }
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
