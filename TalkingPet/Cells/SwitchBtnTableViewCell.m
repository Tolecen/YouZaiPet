//
//  SwitchBtnTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 15/3/3.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "SwitchBtnTableViewCell.h"

@implementation SwitchBtnTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(15,12, 160, 20)];
        self.nameL.backgroundColor = [UIColor clearColor];
        self.nameL.font = [UIFont systemFontOfSize:16];
//        self.nameL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        [self.contentView addSubview:self.nameL];
        
        self.switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenWidth-70, 7, 80, 30)];
        [self.switchBtn setOn:YES];
        [self.switchBtn addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.switchBtn];
        
    }
    return self;
}
-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        if ([self.delegate respondsToSelector:@selector(switchBtnClickedIndex:btnOn:)]) {
            [self.delegate switchBtnClickedIndex:self.theIndex btnOn:YES];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(switchBtnClickedIndex:btnOn:)]) {
            [self.delegate switchBtnClickedIndex:self.theIndex btnOn:NO];
        }
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
