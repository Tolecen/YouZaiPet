//
//  TopicTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 15/3/26.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "TopicTableViewCell.h"

@implementation TopicTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-10-10-75-10, 75)];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setTextColor:[UIColor colorWithWhite:120/255.0f alpha:1]];
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.titleLabel];
        
        self.liulanL = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 200, 20)];
        [self.liulanL setBackgroundColor:[UIColor clearColor]];
        [self.liulanL setTextColor:[UIColor colorWithRed:133/255.0f green:209/255.0f blue:252/255.0f alpha:1]];
        [self.liulanL setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.liulanL];
        self.liulanL.adjustsFontSizeToFitWidth = YES;
        
        self.contentImageV = [[EGOImageView alloc] initWithFrame:CGRectMake(ScreenWidth-10-75, 10, 75, 75)];
        [self.contentImageV setBackgroundColor:[UIColor lightGrayColor]];
        [self.contentView addSubview:self.contentImageV];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    NSString * content = [self.theDict objectForKey:@"content"];
    CGSize cSize;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0){
        NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle2.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle2.copy};
        cSize = [content boundingRectWithSize:CGSizeMake(ScreenWidth-10-10-75-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes2 context:nil].size;
    }
    else
        cSize = [content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(ScreenWidth-10-10-75-10, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    [self.titleLabel setText:content];
    [self.titleLabel setFrame:CGRectMake(10, 10, cSize.width, cSize.height)];
    
    long long numv = [[self.theDict objectForKey:@"viewCount"] longLongValue];
    NSString * bnStr = [NSString stringWithFormat:@"%lld",numv];
    if (numv>=100000000) {
        float j = (numv/100000000.0f);
        bnStr = [NSString stringWithFormat:@"%.1f亿",j];
    }
    else if (numv>=100000){
        float j = numv/100000.0f;
        bnStr = [NSString stringWithFormat:@"%.1f万",j];
    }
    self.liulanL.text = [NSString stringWithFormat:@"%@浏览",bnStr];
//    
//    [self.liulanL setText:@"3456789浏览"];
    [self.liulanL setFrame:CGRectMake(10, 10+(cSize.height>=55?cSize.height:55)+5, 200, 20)];
    
    self.contentImageV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/1/w/100",[self.theDict objectForKey:@"pic"]]];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
