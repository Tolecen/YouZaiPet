//
//  BookPreviewViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/5/12.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"

@interface BookPreviewViewController : BaseViewController
@property (nonatomic,copy)void(^back) ();
@property (nonatomic,copy)void(^finish) (NSInteger totalNum);
@end
