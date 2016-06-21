//
//  QuanCell.m
//  TalkingPet
//
//  Created by Tolecen on 15/7/23.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "QuanCell.h"
#import "Common.h"
@implementation QuanCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIView * bg = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 145)];
        bg.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bg];
        
        self.topImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 10)];
        //        self.topImageV.contentMode =
        [self.topImageV setImage:[UIImage imageNamed:@"quanheader"]];
        [self.contentView addSubview:self.topImageV];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2+10, 25, (ScreenWidth-20)/2-20, 20)];
        self.titleL.backgroundColor = [UIColor clearColor];
        self.titleL.textColor = [UIColor colorWithRed:133/255.0f green:203/255.0f blue:252/255.0f alpha:1];
        self.titleL.textAlignment = NSTextAlignmentCenter;
        self.titleL.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.titleL];
        
        self.priceL = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, (ScreenWidth-20)/2, 75)];
        self.priceL.backgroundColor = [UIColor clearColor];
        self.priceL.textAlignment = NSTextAlignmentCenter;
        self.priceL.textColor = [UIColor colorWithRed:133/255.0f green:203/255.0f blue:252/255.0f alpha:1];
        self.priceL.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.priceL];
        self.priceL.adjustsFontSizeToFitWidth = YES;
        
        self.desL1 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2+10, 50, (ScreenWidth-20)/2-20, 50)];
        self.desL1.backgroundColor = [UIColor clearColor];
        self.desL1.numberOfLines = 0;
        self.desL1.textAlignment = NSTextAlignmentCenter;
        self.desL1.lineBreakMode = NSLineBreakByTruncatingTail;
        self.desL1.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
        self.desL1.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.desL1];
        
        UIView * k = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth/2-2, 35, 1, 50)];
        k.backgroundColor = [UIColor colorWithWhite:220/255.0f alpha:1];
        [self.contentView addSubview:k];
        
        //        self.desL2 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2+10, 75, (ScreenWidth-20)/2-20, 20)];
        //        self.desL2.backgroundColor = [UIColor clearColor];
        //        self.desL2.numberOfLines = 0;
        //        self.desL2.textAlignment = NSTextAlignmentCenter;
        //        self.desL2.lineBreakMode = NSLineBreakByTruncatingTail;
        //        self.desL2.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
        //        self.desL2.font = [UIFont systemFontOfSize:12];
        //        [self.contentView addSubview:self.desL2];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-20-200, 115, 200, 20)];
        self.timeL.backgroundColor = [UIColor clearColor];
        self.timeL.numberOfLines = 0;
        self.timeL.textAlignment = NSTextAlignmentRight;
        self.timeL.lineBreakMode = NSLineBreakByTruncatingTail;
        self.timeL.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
        self.timeL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.timeL];
        
        UIImageView *l = [[UIImageView alloc] initWithFrame:CGRectMake(15, 105, ScreenWidth-30, 1)];
        [l setImage:[UIImage imageNamed:@"xuline"]];
        [self.contentView addSubview:l];
        
        self.checmarkView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 110, 30, 30)];
        [self.checmarkView setImage:[UIImage imageNamed:@"quancheckmark"]];
        [self.contentView addSubview:self.checmarkView];
        self.checmarkView.hidden = YES;
        
        self.statusImageV = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-109)/2, (150-89)/2, 109, 89)];
        
        [self.contentView addSubview:self.statusImageV];
        self.statusImageV.hidden = YES;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (![self.quanDict objectForKey:@"couponBeginTime"]) {
        self.titleL.textColor = [UIColor colorWithRed:133/255.0f green:203/255.0f blue:252/255.0f alpha:1];
        self.titleL.text = self.quanDict[@"name"];
        self.desL1.text = self.quanDict[@"desc"];
        //        self.desL2.text = @"满190可用";
        NSString * time1 = [Common getDateStringWithTimestamp:self.quanDict[@"beginTime"]];
        NSString * time2 = [Common getDateStringWithTimestamp:self.quanDict[@"endTime"]];
        self.timeL.text =[NSString stringWithFormat:@"%@ 至 %@ 可用",time1,time2];
        self.timeL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
        if ((self.selectedIndex==self.cellIndex)&&self.isSelected) {
            self.checmarkView.hidden = NO;
        }
        else
            self.checmarkView.hidden = YES;
        
        
        self.thePriceStr = [NSString stringWithFormat:@"￥%@",self.quanDict[@"faceValue"]];
        
        NSMutableAttributedString * attributedStr3 = [[NSMutableAttributedString alloc] initWithString:self.thePriceStr];
        [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(0, self.thePriceStr.length)];
        [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:133/255.0f green:203/255.0f blue:252/255.0f alpha:1] range: NSMakeRange(0, self.thePriceStr.length)];
        [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:60] range: NSMakeRange(1, self.thePriceStr.length-1)];
        [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:133/255.0f green:203/255.0f blue:252/255.0f alpha:1] range: NSMakeRange(1, self.thePriceStr.length-1)];
        self.priceL.attributedText = attributedStr3;
        

    }
    else
    {
        self.titleL.text = self.quanDict[@"couponName"];
        self.desL1.text = self.quanDict[@"couponDesc"];
        
        self.thePriceStr = [NSString stringWithFormat:@"￥%@",self.quanDict[@"couponFaceValue"]];
        
        
        NSMutableAttributedString * attributedStr3 = [[NSMutableAttributedString alloc] initWithString:self.thePriceStr];
    
        //        self.desL2.text = @"满190可用";
//        NSString * time1 = [Common getDateStringWithTimestamp:self.quanDict[@"couponBeginTime"]];
//        NSString * time2 = [Common getDateStringWithTimestamp:self.quanDict[@"couponEndTime"]];
        if ([self.quanDict[@"isTaken"] isEqualToString:@"false"]) {
            
            
            if ([self.quanDict[@"couponLimitCount"] integerValue]==[self.quanDict[@"couponSendCount"] integerValue]) {
                self.timeL.text =@"已领完";
                self.timeL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
                self.statusImageV.hidden = NO;
                [self.statusImageV setImage:[UIImage imageNamed:@"haveallgot"]];
                [self.topImageV setImage:[UIImage imageNamed:@"quanheadergray"]];
                
                [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(0, self.thePriceStr.length)];
                [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithWhite:200/255.0f alpha:1] range: NSMakeRange(0, self.thePriceStr.length)];
                [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:60] range: NSMakeRange(1, self.thePriceStr.length-1)];
                [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithWhite:200/255.0f alpha:1] range: NSMakeRange(1, self.thePriceStr.length-1)];
                self.priceL.attributedText = attributedStr3;
                self.titleL.textColor = [UIColor colorWithWhite:200/255.0f alpha:1];
            }
            else
            {
                self.titleL.textColor = [UIColor colorWithRed:133/255.0f green:203/255.0f blue:252/255.0f alpha:1];
                self.timeL.text =@"点击领取";
                self.timeL.textColor = [UIColor colorWithRed:133/255.0f green:203/255.0f blue:252/255.0f alpha:1];
                self.statusImageV.hidden = YES;
                [self.topImageV setImage:[UIImage imageNamed:@"quanheader"]];
                
                [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(0, self.thePriceStr.length)];
                [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:133/255.0f green:203/255.0f blue:252/255.0f alpha:1] range: NSMakeRange(0, self.thePriceStr.length)];
                [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:60] range: NSMakeRange(1, self.thePriceStr.length-1)];
                [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:133/255.0f green:203/255.0f blue:252/255.0f alpha:1] range: NSMakeRange(1, self.thePriceStr.length-1)];
                self.priceL.attributedText = attributedStr3;
            }
            
            
        }
        else
        {
            self.titleL.textColor = [UIColor colorWithWhite:200/255.0f alpha:1];
            self.statusImageV.hidden = NO;
            self.timeL.text =@"已领取";
            [self.statusImageV setImage:[UIImage imageNamed:@"quanhavegot"]];
            self.timeL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
            [self.topImageV setImage:[UIImage imageNamed:@"quanheadergray"]];
            
            [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(0, self.thePriceStr.length)];
            [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithWhite:200/255.0f alpha:1] range: NSMakeRange(0, self.thePriceStr.length)];
            [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:60] range: NSMakeRange(1, self.thePriceStr.length-1)];
            [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithWhite:200/255.0f alpha:1] range: NSMakeRange(1, self.thePriceStr.length-1)];
            self.priceL.attributedText = attributedStr3;
        }
        
//        
//        if ((self.selectedIndex==self.cellIndex)&&self.isSelected) {
//            self.checmarkView.hidden = NO;
//        }
//        else
            self.checmarkView.hidden = YES;
        
        


    }
    

    
}


@end

