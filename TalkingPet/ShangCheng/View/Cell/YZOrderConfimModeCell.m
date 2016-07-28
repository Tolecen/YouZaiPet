//
//  YZOrderConfimModeCell.m
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/28.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZOrderConfimModeCell.h"

@interface YZOrderConfimModeCell()

@property (nonatomic, weak) UIImageView *imageV;
@property (nonatomic, weak) UILabel *titleLb;
@property (nonatomic, weak) UIButton *selectBtn;

@end

@implementation YZOrderConfimModeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:imageV];
        self.imageV = imageV;
        
        UILabel *titleLb = [[UILabel alloc] init];
        titleLb.font = [UIFont systemFontOfSize:13.f];
        titleLb.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:titleLb];
        self.titleLb = titleLb;
        
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [selectBtn setImage:[UIImage imageNamed:@"shoppingcar_unselect"] forState:UIControlStateNormal];
        [selectBtn setImage:[UIImage imageNamed:@"shoppingcar_select"] forState:UIControlStateSelected];
        [selectBtn addTarget:self action:@selector(inner_Select:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:selectBtn];
        self.selectBtn = selectBtn;
        
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).mas_offset(10);
            make.centerY.mas_equalTo(self.contentView);
            make.width.height.mas_equalTo(30);
        }];
        
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageV.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView).mas_offset(-10);
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithWhite:245/255.0f alpha:1];;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-0.5);
            make.height.mas_equalTo(.5);
        }];
    }
    return self;
}

- (void)inner_Select:(UIButton *)sender {
    if (!sender.selected) {
        self.changeBtnSelected(self);
    }
}

- (void)setIcon:(NSString *)icon {
    self.imageV.image = [UIImage imageNamed:icon];
}

- (void)setTitle:(NSString *)title {
    self.titleLb.text = title;
}

- (void)setBtnSelected:(BOOL)btnSelected {
    _btnSelected = btnSelected;
    self.selectBtn.selected = btnSelected;
}

@end
