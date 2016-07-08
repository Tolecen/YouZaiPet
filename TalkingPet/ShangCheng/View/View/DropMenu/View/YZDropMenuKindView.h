//
//  YZDropMenuKindView.h
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/24.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZDropMenuKindView : UIView

@property (nonatomic, copy) NSArray *indexKeys;
@property (nonatomic, copy) NSArray *alphabet;
@property (nonatomic, copy) NSArray *hots;

- (void)reloadKindMenu;

@end
