//
//  YZOrderConfimNoAddressCell.m
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/28.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZOrderConfimNoAddressCell.h"

@implementation YZOrderConfimNoAddressCell

- (void)dealloc {
    _OrderConfimAddAddressBlock = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        UIImageView *bgimg =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 90)];
        [bgimg setImage:[UIImage imageNamed:@"bg_order_detail_large"]];
        
        [self.contentView addSubview:bgimg];
        
        UIImageView * imageB = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30, 40, 12, 17)];
        imageB.image = [UIImage imageNamed:@"iv_arrow_right"];
        [self.contentView addSubview:imageB];
        
        UIImageView * imageVq = [[UIImageView alloc] initWithFrame:CGRectMake(10, 35, 19.5, 27.5)];
        imageVq.image = [UIImage imageNamed:@"iv_location_large"];
        [self.contentView addSubview:imageVq];
        
        
        
        UIView *containerV = [[UIView alloc] init];
        [bgimg addSubview:containerV];
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setTitle:@"+ 添加收货地址" forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(inner_Add:) forControlEvents:UIControlEventTouchUpInside];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [addBtn sizeToFit];
        [bgimg addSubview:addBtn];
        addBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        addBtn.layer.borderWidth = 1.f;
        addBtn.layer.cornerRadius = CGRectGetHeight(addBtn.frame) / 2;
        addBtn.layer.masksToBounds = YES;
        //        [containerV mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.left.right.mas_equalTo(self.contentView);
        //            make.height.mas_equalTo(44);
        //        }];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(CGRectGetWidth(addBtn.frame) + 10);
            make.center.mas_equalTo(bgimg);
        }];
        
        UIView *grayV = [[UIView alloc] init];
        grayV.backgroundColor = [UIColor colorWithWhite:245/255.f alpha:1];
        [bgimg addSubview:grayV];
        [grayV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(bgimg);
            make.height.mas_equalTo(10);
            make.top.mas_equalTo(bgimg.mas_bottom).mas_offset(-10);
        }];
    }
    return self;
}

- (void)inner_Add:(UIButton *)sender {
    self.OrderConfimAddAddressBlock();
}

@end
