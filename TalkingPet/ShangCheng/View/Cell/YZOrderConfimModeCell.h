//
//  YZOrderConfimModeCell.h
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/28.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZOrderConfimModeCell : UITableViewCell

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL btnSelected;

@property (nonatomic, copy) void(^changeBtnSelected)(YZOrderConfimModeCell *cell);

@end
