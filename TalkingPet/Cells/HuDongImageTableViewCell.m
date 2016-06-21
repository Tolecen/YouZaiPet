//
//  HuDongImageTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 15/3/31.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "HuDongImageTableViewCell.h"

@implementation HuDongImageTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.imageV = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 100)];
        self.imageV.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
        [self.contentView addSubview:self.imageV];
        
        self.lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        self.lineV.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
        [self.contentView addSubview:self.lineV];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageV.imageURL = [NSURL URLWithString:[self.imageDict objectForKey:@"pic"]];
    float scaleWH = [[self.self.imageDict objectForKey:@"scaleWH"] floatValue];
//    NSLog(@"yyyy:%f",scaleWH);
    self.imageV.frame = CGRectMake(10, 0, ScreenWidth-20, (ScreenWidth-20)/(scaleWH>0?scaleWH:1));
    
    if (self.imageIndex==(self.imageNum-1)) {
        self.lineV.hidden = NO;
        [self.lineV setFrame:CGRectMake(0, (ScreenWidth-20)/(scaleWH>0?scaleWH:1)+9, ScreenWidth, 1)];
    }
    else
    {
        self.lineV.hidden = YES;
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
