//
//  PetalkView.h
//  TalkingPet
//
//  Created by wangxr on 15/5/14.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkingBrowse.h"

@interface PetalkView : UIView
-(void)play;
-(void)stop;
@end
@interface PetalkView (TalkingBrowse)
- (void)layoutSubviewsWithTalking:(TalkingBrowse*)talking;
@end