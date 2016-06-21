//
//  PostCardView.h
//  TalkingPet
//
//  Created by Tolecen on 15/6/23.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "TalkingBrowse.h"
@interface PostCardView : UIView
@property (nonatomic,strong)UIView * spritesView;
@property (nonatomic,strong)UIImageView * templateImageV;
@property (nonatomic,strong)NSDictionary * pcJsonDict;

@property (nonatomic,strong)EGOImageView * headerV;
@property (nonatomic,strong)EGOImageView * contentImageV;
@property (nonatomic,strong)EGOImageView * erweimaV;
@property (nonatomic,strong)UILabel * pcContentL;
@property (nonatomic,strong)UILabel * nicknameL;
@property (nonatomic,strong)UILabel * timeL;
@property (nonatomic,strong)UILabel * timeL2;

-(void)displaySpritesWithTalking:(TalkingBrowse *)talking;
@end
