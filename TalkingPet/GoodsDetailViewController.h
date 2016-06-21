//
//  GoodsDetailViewController.h
//  TalkingPet
//
//  Created by wangxr on 15/1/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "TOWebViewController.h"
typedef enum {
    GoodsDetailTyepExchange = 0,
    GoodsDetailTyepTrial
} GoodsDetailTyep;
@interface GoodsDetailViewController : BaseViewController
@property (nonatomic,assign)GoodsDetailTyep type;
@property (nonatomic,assign)NSDictionary * goodsDic;
@property (nonatomic,copy)void(^trialSuccess) ();;
@end
