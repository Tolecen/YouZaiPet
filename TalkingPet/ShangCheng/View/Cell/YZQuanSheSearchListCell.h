//
//  YZQuanSheSearchListCell.h
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/12.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZShangChengModel.h"

typedef void(^QSBlock)();
@interface YZQuanSheSearchListCell : UICollectionViewCell

@property (nonatomic, strong) YZQuanSheModel *quanSheModel;

@property(nonatomic,copy)QSBlock block;

@end
