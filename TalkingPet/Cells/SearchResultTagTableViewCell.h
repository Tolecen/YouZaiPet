//
//  SearchResultTagTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 14-8-28.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EGOImageView;
@interface SearchResultTagTableViewCell : UITableViewCell
@property (nonatomic,strong) UIButton * tagBtn;
@property (nonatomic,strong) NSDictionary * tagDict;
@property (nonatomic,assign) int disNum;
@property (nonatomic,strong)UIImageView * bgImg;
@property (nonatomic,assign) float h;
@property (nonatomic,strong) EGOImageView * timg;
@end
