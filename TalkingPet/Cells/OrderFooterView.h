//
//  OrderFooterView.h
//  TalkingPet
//
//  Created by TaoXinle on 16/7/27.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderFooterView : UITableViewHeaderFooterView
@property (nonatomic,retain)UILabel * desL;
@property (nonatomic,strong)UIButton * btn1;
@property (nonatomic,strong)UIButton * btn2;
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier WithButton:(BOOL)haveBtn;
@end