//
//  YZQuanSheDetailCollectionHeaderView.h
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/7.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZShangChengModel.h"

@interface YZQuanSheDetailCollectionHeaderView : UICollectionReusableView

@property (nonatomic, strong) YZQuanSheDetailModel *detailModel;

@property (nonatomic, copy) void(^ShowQuanSheIntroBlock)(void);

@end
