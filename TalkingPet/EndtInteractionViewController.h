//
//  EndtInteractionViewController.h
//  TalkingPet
//
//  Created by wangxr on 15/3/30.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "KeyboardBarView.h"
@interface EndtInteractionViewController : BaseViewController
{
    KeyboardBarView * k;
}
@property (nonatomic,retain)NSMutableArray * selectedArray;
@property (nonatomic,retain)NSString * topicId;
@end
