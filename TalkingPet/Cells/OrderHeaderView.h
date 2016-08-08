//
//  OrderHeaderView.h
//  TalkingPet
//
//  Created by TaoXinle on 16/7/27.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderYZList;
@interface OrderHeaderView : UITableViewHeaderFooterView
@property (nonatomic,retain)UILabel * timeL;
@property (nonatomic,strong)UILabel * statusL;
@property(nonatomic,strong)OrderYZList  *YZList;
@end
