//
//  OrderListViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/5/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderConfirmViewController.h"
@protocol PCOrderListDelegate <NSObject>
@optional
-(void)resetPCNum:(NSInteger)num;

@end
@interface OrderListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView * listTableV;
@property (nonatomic,strong)NSString * goodsTitle;
@property (nonatomic,strong)UILabel * numL;
@property (nonatomic,assign)NSInteger allNum;
@property (nonatomic,strong)UILabel * allPriceL;
@property (nonatomic,strong)NSString * allPriceStr;
@property (nonatomic,strong)NSString * univalent;
@property (nonatomic,strong)NSString * allPrice;
@property (nonatomic,strong)NSMutableDictionary * orderListDict;
@property (nonatomic,strong)NSArray * listKeyArray;
@property (nonatomic,strong)NSDictionary * goodsInfoDict;
@property (nonatomic,assign)id<PCOrderListDelegate>delegate;
@end
