//
//  YZShangChengDropView.h
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/23.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZShangChengConst.h"

@class YZShangChengDropMenu;
@protocol YZDropMenuDataSource <NSObject>
@required
- (NSInteger)numberOfColumnsInMenu:(YZShangChengDropMenu *)menu;
- (NSString *)menu:(YZShangChengDropMenu *)menu titleForColumn:(NSInteger)column;

@end

@protocol YZDropMenuDelegate <NSObject>
@required
- (void)menuFilterSelectSize:(YZDogSize)size;

- (void)menuFilterSelectAge:(YZDogAgeRange)age;

- (void)menuFilterSelectValue:(YZDogValueRange)value sex:(YZDogSex)sex;

- (void)menuFilterSelectDogType:(NSString *)type;

@end

@interface YZShangChengDropMenu : UIView

@property (nonatomic, weak) id <YZDropMenuDataSource> dataSource;
@property (nonatomic, weak) id <YZDropMenuDelegate> delegate;

@end
