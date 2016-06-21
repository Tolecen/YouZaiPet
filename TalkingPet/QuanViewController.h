//
//  QuanViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/7/20.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
@protocol QuanDelegate <NSObject>
@optional
-(void)getQuanId:(NSDictionary *)quanDict Selected:(int)selected;

@end
@interface QuanViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITextField * t;
}
@property (nonatomic,strong)UITableView * tableview;
@property (nonatomic,strong)NSMutableArray * quanArray;
@property (nonatomic,assign)int pageType;
@property (nonatomic,strong)NSString * orderId;
@property (nonatomic,strong)NSString * startId;
@property (nonatomic,assign)id<QuanDelegate>delegate;
@property (nonatomic,assign)int selectedId;
@end
