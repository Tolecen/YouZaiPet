//
//  BowserZanTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 15/2/6.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "TalkingTableViewCellDelegate.h"
@interface BowserZanTableViewCell : UITableViewCell<TalkingTableViewCellDelegate>
@property (nonatomic,strong) UILabel * zanViewzanL;
@property (nonatomic,assign) int zanAvatarNum;
@property (nonatomic,strong)NSMutableArray * showZanArray;
@property (nonatomic,strong)NSString * favorNum;
@property (nonatomic,assign)id <TalkingTableViewCellDelegate> delegate;
@end
