//
//  PostCardThumbTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 15/5/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "PostCardThumbTableViewCell.h"

@implementation PostCardThumbTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.thumbImageV = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        self.thumbImageV.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
        [self.contentView addSubview:self.thumbImageV];
        
        self.maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        self.maskView.backgroundColor = [UIColor clearColor];
        self.maskView.image = [UIImage imageNamed:@"postcard_mask"];
        [self.contentView addSubview:self.maskView];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.selectedIndex==self.currentIndex) {
        self.maskView.hidden = NO;
    }
    else
        self.maskView.hidden = YES;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
