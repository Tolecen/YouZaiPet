//
//  PostCardThumbTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 15/5/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface PostCardThumbTableViewCell : UITableViewCell
@property (nonatomic,strong)EGOImageView * thumbImageV;
@property (nonatomic,strong)UIImageView * maskView;
@property (nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,assign)NSInteger currentIndex;
@end
