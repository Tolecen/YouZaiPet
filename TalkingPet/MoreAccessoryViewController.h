//
//  MoreAccessoryViewController.h
//  TalkingPet
//
//  Created by wangxr on 15/2/3.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"

@interface MoreAccessoryViewController : BaseViewController
@property (nonatomic,retain)NSString * accessoryType;
- (instancetype)initWithSelectAction:(void (^)(Accessory * acc))action;
@end
