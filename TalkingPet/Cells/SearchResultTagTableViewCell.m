//
//  SearchResultTagTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 14-8-28.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "SearchResultTagTableViewCell.h"
#import "EGOImageView.h"
@implementation SearchResultTagTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        
        self.bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth, 110)];
        [self.bgImg setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.bgImg];
        
        self.tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.tagBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.tagBtn setFrame:CGRectMake(15, 15, 80, 20)];
        [self.contentView addSubview:self.tagBtn];

        [self.tagBtn  setTitleEdgeInsets:UIEdgeInsetsMake(1, 15, 0, 0)];
        [self.tagBtn  setBackgroundColor:[UIColor colorWithRed:182/255.0 green:178/255.0 blue:251/255.0 alpha:1]];
        self.tagBtn .layer.cornerRadius = 8;
        self.tagBtn .layer.masksToBounds = YES;
        
        UIImageView * timg = [[UIImageView alloc] initWithFrame:CGRectMake(6, 4, 14, 12)];
        [timg setImage:[UIImage imageNamed:@"tagImg"]];
        [self.tagBtn addSubview:timg];
        if (ScreenWidth<=320) {
            self.disNum = 4;
        }
        else
            self.disNum = 5;
        self.h = (ScreenWidth-30-(self.disNum-1)*10)/self.disNum;
        for (int i = 0; i<self.disNum; i++) {
            EGOImageView * imagev1 = [[EGOImageView alloc] initWithFrame:CGRectMake(15+((self.h+10)*i), 43, self.h, self.h)];
            imagev1.tag = i+1;
            imagev1.backgroundColor = [UIColor whiteColor];
            [self.contentView addSubview:imagev1];
        }
        [self.bgImg setFrame:CGRectMake(0, 5, ScreenWidth, 43+self.h+5)];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.tagBtn setTitle:[self.tagDict objectForKey:@"name"] forState:UIControlStateNormal];
    
    CGSize tagSize = [[self.tagDict objectForKey:@"name"]sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(120, 20)];
    [self.tagBtn setFrame:CGRectMake(15, 15, tagSize.width+30, 20)];
    
    NSArray * listArray = [self.tagDict objectForKey:@"petalks"];
    if (listArray.count<=0) {
        return;
    }
    for (int i = 0; i<listArray.count; i++) {
        EGOImageView * imgV = (EGOImageView *)[self.contentView viewWithTag:i+1];
        NSDictionary * h = listArray[i];
        if (h) {
            imgV.imageURL = [NSURL URLWithString:[[h objectForKey:@"thumbUrl"] stringByAppendingString:@"?imageView2/2/w/200"]];
        }
        
    }
    
    


}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
