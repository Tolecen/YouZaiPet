//
//  WXROrderCell.m
//  TalkingPet
//
//  Created by wangxr on 15/6/17.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "WXROrderCell.h"
#import "EGOImageView.h"

@interface WXROrderCell ()
{
    EGOImageView * imageView;
    UILabel * payStateL;
    UILabel * titleL;
    UILabel * unitPriceL;
    UILabel * numberL;
    UILabel * transportationCostsL;
    UILabel * totalL;
    UILabel * totalPriceL;
    UIButton * liaisonB;
    UIButton * payB;
}
@end
@implementation WXROrderCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        payStateL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-110, 10, 100, 20)];
        payStateL.font = [UIFont systemFontOfSize:14];
        payStateL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:payStateL];
        UIView * lineA = [[UIView alloc] initWithFrame:CGRectMake(10, 30, ScreenWidth-20, 1)];
        lineA.backgroundColor = [UIColor colorWithWhite:200/255.0 alpha:1];
        [self.contentView addSubview:lineA];
        imageView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 40, 80, 80)];
        [self.contentView addSubview:imageView];
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, ScreenWidth-180, 80)];
        titleL.font = [UIFont systemFontOfSize:14];
        titleL.numberOfLines = 0;
        titleL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        [self.contentView addSubview:titleL];
        unitPriceL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-80, 40, 70, 20)];
        unitPriceL.adjustsFontSizeToFitWidth = YES;
        unitPriceL.minimumScaleFactor = 0.1;
        unitPriceL.font = [UIFont systemFontOfSize:16];
        unitPriceL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        unitPriceL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:unitPriceL];
        numberL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-80, 70, 70, 20)];
        numberL.font = [UIFont systemFontOfSize:12];
        numberL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        numberL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:numberL];
        transportationCostsL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-80, 100, 70, 20)];
        transportationCostsL.font = [UIFont systemFontOfSize:12];
        transportationCostsL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        transportationCostsL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:transportationCostsL];
        UIView * lineB = [[UIView alloc] initWithFrame:CGRectMake(10, 130, ScreenWidth-20, 1)];
        lineB.backgroundColor = [UIColor colorWithWhite:200/255.0 alpha:1];
        [self.contentView addSubview:lineB];
        totalL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-150, 140, 70, 20)];
        totalL.font = [UIFont systemFontOfSize:12];
        totalL.text = @"共计:";
        totalL.textColor = [UIColor colorWithWhite:140/255.0 alpha:1];
        totalL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:totalL];
        totalPriceL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-80, 140, 70, 20)];
        totalPriceL.adjustsFontSizeToFitWidth = YES;
        totalPriceL.minimumScaleFactor = 0.1;
        totalPriceL.font = [UIFont systemFontOfSize:20];
        totalPriceL.textColor = [UIColor orangeColor];
        totalPriceL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:totalPriceL];
        liaisonB = [UIButton buttonWithType:UIButtonTypeCustom];
        liaisonB.frame = CGRectMake(ScreenWidth-200, 180, 90, 32);
        [liaisonB addTarget:self action:@selector(liaison) forControlEvents:UIControlEventTouchUpInside];
        [liaisonB setImage:[UIImage imageNamed:@"liaison"] forState:UIControlStateNormal];
        [self.contentView addSubview:liaisonB];
        payB = [UIButton buttonWithType:UIButtonTypeCustom];
        payB.frame = CGRectMake(ScreenWidth-100, 180, 90, 32);
        [payB addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
        [payB setImage:[UIImage imageNamed:@"pay"] forState:UIControlStateNormal];
        [self.contentView addSubview:payB];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
}
-(void)liaison
{
    if (_liaisonAction) {
        _liaisonAction();
    }
}
-(void)pay
{
    if (_payAction) {
        _payAction();
    }
}
@end
@implementation WXROrderCell (MyOrderViewConyroller)
- (void)bulidCellWithDictionary:(NSDictionary*)source
{
    payStateL.text = source[@"stateDesc"];
    if ([source[@"state"] intValue]== 2) {
        payStateL.textColor = [UIColor orangeColor];
        liaisonB.frame = CGRectMake(ScreenWidth-200, 180, 90, 32);
        payB.hidden = NO;
        [payB setImage:[UIImage imageNamed:@"pay"] forState:UIControlStateNormal];
        payB.frame = CGRectMake(ScreenWidth-100, 180, 90, 32);
    }else if([source[@"state"] intValue]== 5)
    {
        payStateL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        liaisonB.frame = CGRectMake(ScreenWidth-200, 180, 90, 32);
        payB.hidden = NO;
        [payB setImage:[UIImage imageNamed:@"receipt"] forState:UIControlStateNormal];
        payB.frame = CGRectMake(ScreenWidth-100, 180, 90, 32);
    }else
    {
        payStateL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        liaisonB.frame = CGRectMake(ScreenWidth-100, 180, 90, 32);
        payB.hidden = YES;
    }
    imageView.imageURL = [NSURL URLWithString:[source[@"orderProducts"] lastObject][@"cover"]];
    titleL.text = [source[@"orderProducts"] lastObject][@"name"];
    unitPriceL.text = [@"￥" stringByAppendingString:[source[@"orderProducts"] lastObject][@"price"]];
    numberL.text = [@"×" stringByAppendingString:source[@"productCount"]];
    transportationCostsL.text = [@"运费:" stringByAppendingString:source[@"shippingFee"]];
    totalPriceL.text = [@"￥" stringByAppendingString:source[@"amount"]];
    
}
@end
