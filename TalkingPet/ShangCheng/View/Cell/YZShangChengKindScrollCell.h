//
//  YZShangChengKindScrollCell.h
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/25.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZShangChengKindScrollCell : UITableViewCell

@property (nonatomic, copy) NSArray *hots;
@property (nonatomic, copy) void(^kindViewSelectedKindBlock)(NSString *dogType);

@end
