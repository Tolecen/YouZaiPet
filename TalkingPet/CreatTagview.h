//
//  CreatTagview.h
//  TalkingPet
//
//  Created by cc on 16/8/5.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag.h"

typedef void(^CreatBlock)(Tag *tag);

@interface CreatTagview : UIView
@property(nonatomic,copy)CreatBlock cblock;
@end
