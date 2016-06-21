//
//  ImageAssetsViewController.h
//  TalkingPet
//
//  Created by wangxr on 15/3/26.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
@class ALAssetsLibrary;
@interface ImageAssetsViewController : BaseViewController
@property (nonatomic,assign) int maxCount;
@property (nonatomic,copy)void(^finish) (NSMutableArray * assetArray,NSMutableArray*appends);
-(void)setSelectedArray:(NSMutableArray*)array;
@end
