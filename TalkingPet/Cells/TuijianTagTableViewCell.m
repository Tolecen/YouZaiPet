//
//  TuijianTagTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 15/7/1.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "TuijianTagTableViewCell.h"

@implementation TuijianTagTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        float imgH = (ScreenWidth-60)/3.0f;
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIView * bgv = [[UIView alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-20, 52+imgH+10)];
        bgv.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgv];
        
        self.iconV = [[EGOImageView alloc] initWithFrame:CGRectMake(20, 20, 32, 32)];
        self.iconV.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
        self.iconV.image = [UIImage imageNamed:@"qiuzhu"];
        [self.contentView addSubview:self.iconV];
        self.iconV.layer.cornerRadius = 4;
        self.iconV.layer.masksToBounds = YES;
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(62, 20, 100, 32)];
        self.titleL.backgroundColor = [UIColor clearColor];
        self.titleL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
        self.titleL.font = [UIFont systemFontOfSize:18];
        self.titleL.adjustsFontSizeToFitWidth = YES;
        self.titleL.text = @"经验交流";
        [self.contentView addSubview:self.titleL];
        
//        self.desL = [[UILabel alloc] initWithFrame:CGRectMake(62+100+10, 20, 150, 32)];
//        self.desL.backgroundColor = [UIColor clearColor];
//        self.desL.textColor = [UIColor colorWithWhite:160/255.0f alpha:1];
//        self.desL.font = [UIFont systemFontOfSize:12];
//        self.desL.lineBreakMode = NSLineBreakByTruncatingTail;
//        self.desL.text = @"这里是描述这里是描述";
//        [self.contentView addSubview:self.desL];
        
        UIImageView *more = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-20-35, 32, 35, 8)];
        [more setImage:[UIImage imageNamed:@"moreincell"]];
        [self.contentView addSubview:more];
        
//        float imgH = (ScreenWidth-80)/3.0f;
        for (int i = 0; i<3; i++) {
            EGOImageView * imagev1 = [[EGOImageView alloc] initWithFrame:CGRectMake(10+10*(i+1)+imgH*i, 52+10, imgH, imgH)];
            imagev1.tag = i+1;
            imagev1.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
            [self.contentView addSubview:imagev1];
            imagev1.imageURL = [NSURL URLWithString:@"http://cdn.duitang.com/uploads/item/201202/01/20120201164929_2H3Je.thumb.200_200_c.jpg"];
            
//            EGOImageView * head = [[EGOImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
//            head.tag = i+100;
//            head.layer.cornerRadius = 15;
//            head.layer.masksToBounds = YES;
//            head.backgroundColor = [UIColor grayColor];
//            [imagev1 addSubview:head];
//            head.imageURL = [NSURL URLWithString:@"http://www.soideas.cn/uploads/allimg/110630/2124061950-36.jpg"];
            
            
            UIView * g = [[UIView alloc] initWithFrame:CGRectMake(0, imgH-20, imgH, 20)];
            g.backgroundColor = [UIColor blackColor];
            g.alpha = 0.7;
            [imagev1 addSubview:g];
            
            UILabel * fl = [[UILabel alloc] initWithFrame:CGRectMake(5, imgH-20, imgH-10, 20)];
            fl.backgroundColor = [UIColor clearColor];
            fl.textColor = [UIColor whiteColor];
            fl.font = [UIFont systemFontOfSize:12];
            fl.lineBreakMode = NSLineBreakByTruncatingTail;
            [imagev1 addSubview:fl];
            fl.tag = i+200;
            fl.text = @"这里是描述";
        }
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.iconV.imageURL = [NSURL URLWithString:[self.tagDict objectForKey:@"iconUrl"]];
    self.titleL.text = [self.tagDict objectForKey:@"name"];
    NSArray * g = [self.tagDict objectForKey:@"petalks"];
    
    if (g.count<3) {
        for (int i = 0; i<g.count; i++) {
            TalkingBrowse *tk = [g objectAtIndex:i];
            if (tk) {
                EGOImageView * h = (EGOImageView *)[self.contentView viewWithTag:i+1];
                h.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/1/w/200/h/200",tk.thumbImgUrl]];
//                EGOImageView * head = (EGOImageView *)[h viewWithTag:i+100];
//                head.imageURL = [NSURL URLWithString:tk.petInfo.headImgURL];
                UILabel * j = (UILabel *)[h viewWithTag:i+200];
                j.text = tk.descriptionContent;
            }

        }
        
    }
    else
    {
        for (int i = 0; i<3; i++) {
            TalkingBrowse *tk = [g objectAtIndex:i];
            if (tk) {
                EGOImageView * h = (EGOImageView *)[self.contentView viewWithTag:i+1];
                h.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/1/w/200/h/200",tk.thumbImgUrl]];
//                EGOImageView * head = (EGOImageView *)[h viewWithTag:i+100];
//                head.imageURL = [NSURL URLWithString:tk.petInfo.headImgURL];
                UILabel * j = (UILabel *)[h viewWithTag:i+200];
                j.text = tk.descriptionContent;
            }
            
        }
    }
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
