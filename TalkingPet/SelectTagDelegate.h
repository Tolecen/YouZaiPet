//
//  SelectTagDelegate.h
//  TalkingPet
//
//  Created by wangxr on 15/2/10.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SelectTagDelegate <NSObject>
@optional
- (void)selectedTag:(Tag*)tag;
@end
