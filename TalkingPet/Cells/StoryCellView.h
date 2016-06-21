//
//  StoryCellView.h
//  TalkingPet
//
//  Created by Tolecen on 15/7/21.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface StoryCellView : UIView
@property (nonatomic,strong) UILabel * storyTimeL;
@property (nonatomic,strong) UILabel * storyTitleL;
@property (nonatomic,strong) EGOImageView * storyImageV1;
@property (nonatomic,strong) EGOImageView * storyImageV2;
@end
