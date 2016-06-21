//
//  AccessoryCell.h
//  TalkingPet
//
//  Created by wangxr on 15/2/3.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface AccessoryCell : UICollectionViewCell
@property (nonatomic,retain)UIImageView * stateIV;
@property (nonatomic,retain)EGOImageView * imageV;
@property (nonatomic,retain)UIActivityIndicatorView * activity;
@end
