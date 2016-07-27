//
//  OrderListSingleCell.m
//  TalkingPet
//
//  Created by Tolecen on 16/7/26.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "OrderListSingleCell.h"

@implementation OrderListSingleCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIView * bgV = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 80)];
        bgV.backgroundColor = [UIColor colorWithR:245 g:245 b:245 alpha:1];
        [self.contentView addSubview:bgV];
        
        
        self.goodPicV = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 0, 80, 80)];
        self.goodPicV.backgroundColor = [UIColor colorWithR:240 g:240 b:240 alpha:1];
        [self.contentView addSubview:_goodPicV];
        
        
        self.goodNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.goodPicV.frame)+10, 0, ScreenWidth-120-10-(CGRectGetMaxX(self.goodPicV.frame)+10), 40)];
        self.goodNameL.font = [UIFont systemFontOfSize:13];
        self.goodNameL.numberOfLines = 2;
        self.goodNameL.backgroundColor = [UIColor clearColor];
        self.goodNameL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        [self.contentView addSubview:self.goodNameL];
        self.goodNameL.text = @"这里是商品名字";
        
        self.goodDesL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.goodPicV.frame)+10, 40, ScreenWidth-120-10-(CGRectGetMaxX(self.goodPicV.frame)+10), 40)];
        self.goodDesL.font = [UIFont systemFontOfSize:13];
        self.goodDesL.numberOfLines = 2;
        self.goodDesL.backgroundColor = [UIColor clearColor];
        self.goodDesL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        [self.contentView addSubview:self.goodDesL];
        self.goodDesL.text = @"这里是商品描述";
        
        self.moneyL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-20-120, 10, 120, 20)];
        self.moneyL.font = [UIFont systemFontOfSize:13];
        self.moneyL.numberOfLines = 1;
        self.moneyL.textAlignment = NSTextAlignmentRight;
        self.moneyL.adjustsFontSizeToFitWidth = YES;
        self.moneyL.backgroundColor = [UIColor clearColor];
        self.moneyL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        [self.contentView addSubview:self.moneyL];
        self.moneyL.text = @"￥10000";
        
        self.amountL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-20-120, 50, 120, 20)];
        self.amountL.font = [UIFont systemFontOfSize:13];
        self.amountL.numberOfLines = 1;
        self.amountL.textAlignment = NSTextAlignmentRight;
        self.amountL.adjustsFontSizeToFitWidth = YES;
        self.amountL.backgroundColor = [UIColor clearColor];
        self.amountL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        [self.contentView addSubview:self.amountL];
        self.amountL.text = @"x 1";

        
    }
    return self;
}
@end
