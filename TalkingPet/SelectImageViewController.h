//
//  SelectImageViewController.h
//  TalkingPet
//
//  Created by wangxr on 14-9-16.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "TalkingPublish.h"

@interface SelectImageViewController : BaseViewController
@property (nonatomic,strong) TalkingPublish * talkingPublish;
@property (nonatomic,copy) NSArray * imageArr;
@end
