//
//  YZOrderConfimAddressCell.m
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/28.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZOrderConfimAddressCell.h"

@interface YZOrderConfimAddressCell()

@property (nonatomic, weak) UILabel *shouhuoNameL;
@property (nonatomic, weak) UILabel *shouhuoMobileL;
@property (nonatomic, weak) UILabel *shouhuoAddressL;

@end

@implementation YZOrderConfimAddressCell

- (void)dealloc {
    _address = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView * imageVq = [[UIImageView alloc] initWithFrame:CGRectMake(10, 32, 19.5, 27.5)];
        imageVq.image = [UIImage imageNamed:@"defaultAddress"];
        [self.contentView addSubview:imageVq];
        
        UILabel *shouhuoNameL = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, 150, 20)];
        shouhuoNameL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        shouhuoNameL.font = [UIFont systemFontOfSize:16];
        shouhuoNameL.text = [@"收货人:" stringByAppendingString:@"收货人"];
        [self.contentView addSubview:shouhuoNameL];
        self.shouhuoNameL = shouhuoNameL;
        
        UILabel *shouhuoMobileL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-110, 10, 100, 20)];
        shouhuoMobileL.textColor = [UIColor colorWithWhite:140/255.0 alpha:1];
        shouhuoMobileL.textAlignment = NSTextAlignmentRight;
        shouhuoMobileL.font = [UIFont systemFontOfSize:14];
        shouhuoMobileL.text = @"15000998877";
        [self.contentView addSubview:shouhuoMobileL];
        self.shouhuoMobileL = shouhuoMobileL;
        
        UILabel *shouhuoAddressL = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, ScreenWidth-80, 40)];
        shouhuoAddressL.textColor = [UIColor colorWithWhite:140/255.0 alpha:1];
        shouhuoAddressL.numberOfLines = 2;
        shouhuoAddressL.font = [UIFont systemFontOfSize:14];
        shouhuoAddressL.text = @"北京市朝阳区大墩路11111";
        [self.contentView addSubview:shouhuoAddressL];
        self.shouhuoAddressL = shouhuoAddressL;
        
        UIView * gb = [[UIView alloc] initWithFrame:CGRectMake(0, 80, ScreenWidth, 10)];
        gb.backgroundColor = [UIColor colorWithWhite:245/255.0f alpha:1];
        [self.contentView addSubview:gb];
    }
    return self;
}

- (void)setAddress:(ReceiptAddress *)address {
    if (!address) {
        return;
    }
    _address = address;
    self.shouhuoNameL.text = address.receiptName;
    self.shouhuoMobileL.text = address.phoneNo;
    self.shouhuoAddressL.text = address.address;
    [self setNeedsLayout];
}

@end
