//
//  TagTalkListViewController.h
//  TalkingPet
//
//  Created by Tolecen on 14-8-15.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Tag.h"
#import "EGOImageLoader.h"
#import "EGOImageButton.h"
@interface TagTalkListViewController : BaseViewController<EGOImageButtonDelegate>
@property (nonatomic,retain)Tag * tag;
@property (nonatomic, retain) EGOImageButton * dButton;
@property (nonatomic,assign)BOOL shouldRequestTagInfo;
@property (nonatomic,assign)BOOL shouldDismiss;
@property (nonatomic,strong)UIView * bgV;
@property (nonatomic,strong)UIView * selectedLine;
@property (nonatomic,assign)int displayModel; //0,最新    1,最热     2,最热最新
@property (nonatomic,assign)BOOL canShowPublishBtn;
@end
