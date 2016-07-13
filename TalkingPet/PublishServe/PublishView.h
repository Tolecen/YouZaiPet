//
//  PublishView.h
//  TalkingPet
//
//  Created by wangxr on 15/1/29.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TishiNewView.h"
@interface PublishView : UIView
@property (nonatomic,assign)float publishox;
- (void)showWithAction:(void (^)(NSInteger index))action;
@end
