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
        
        UIView *containerV = [[UIView alloc] init];
        [self.contentView addSubview:containerV];
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setTitle:@"+ 添加收货地址" forState:UIControlStateNormal];
        [addBtn setTitleColor:CommonGreenColor forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(inner_Add:) forControlEvents:UIControlEventTouchUpInside];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [addBtn sizeToFit];
        [containerV addSubview:addBtn];
        addBtn.layer.borderColor = CommonGreenColor.CGColor;
        addBtn.layer.borderWidth = 1.f;
        addBtn.layer.cornerRadius = CGRectGetHeight(addBtn.frame) / 2;
        addBtn.layer.masksToBounds = YES;
        [containerV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self.contentView);
            make.height.mas_equalTo(44);
        }];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(CGRectGetWidth(addBtn.frame) + 10);
            make.center.mas_equalTo(containerV);
        }];
        
        UIView *grayV = [[UIView alloc] init];
        grayV.backgroundColor = [UIColor colorWithWhite:245/255.f alpha:1];
        [self.contentView addSubview:grayV];
        [grayV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.contentView);
            make.height.mas_equalTo(10);
            make.top.mas_equalTo(containerV.mas_bottom).mas_offset(0);
        }];
    }
    return self;
}

- (void)inner_Add:(UIButton *)sender {
    self.OrderConfimAddAddressBlock();
}

@end
