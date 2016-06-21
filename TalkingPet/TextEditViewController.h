//
//  TextEditViewController.h
//  TalkingPet
//
//  Created by wangxr on 15/7/9.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"

@interface TextEditViewController : BaseViewController
@property (nonatomic,copy)void(^finish) (NSString * text);
@property (nonatomic,assign) int max;
-(void)setText:(NSString*)text;
@end
