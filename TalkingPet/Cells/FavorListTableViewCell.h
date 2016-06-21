//
//  FavorListTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 14-7-15.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
@class RootViewController;
@protocol FavorCellAttentionDelegate <NSObject>
@optional
-(void)toUserPage:(NSDictionary *)petDict;
-(void)attentionDelegate:(NSDictionary *)dict Index:(NSInteger)index;
@end
@interface FavorListTableViewCell : UITableViewCell
@property (nonatomic,strong) EGOImageButton * commentAvatarV;
@property (nonatomic,strong) UILabel * commentNameL;
@property (nonatomic,strong) UIImageView * darenV;
@property (nonatomic,strong) UIButton * relationBtn;
@property (nonatomic,strong) NSDictionary * favorDict;
@property (nonatomic,assign) NSInteger cellIndex;
@property (nonatomic,strong) NSString * relationShip;
@property (nonatomic,assign) id<FavorCellAttentionDelegate> delegate;
@end
