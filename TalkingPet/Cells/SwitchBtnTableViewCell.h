//
//  SwitchBtnTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 15/3/3.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SwitchBtnCellDelegate <NSObject>
@optional
-(void)switchBtnClickedIndex:(int)index btnOn:(BOOL)isOn;
@end
@interface SwitchBtnTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel * nameL;
@property (nonatomic,strong) UISwitch * switchBtn;
@property (nonatomic,assign) int theIndex;
@property (nonatomic,assign) id <SwitchBtnCellDelegate> delegate;
@end
