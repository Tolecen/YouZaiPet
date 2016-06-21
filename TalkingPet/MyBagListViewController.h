//
//  MyBagListViewController.h
//  TalkingPet
//
//  Created by Tolecen on 14/12/13.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "MJRefresh.h"
#import "PackageInfoTableViewCell.h"
#import "PackageInfo.h"
#import "UIViewController+MJPopupViewController.h"
#import "MJDetailViewController.h"
//@class GiftPackageViewController;
@interface MyBagListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,MJPopupDelegate>
{
    int currentIndex;
}
@property (nonatomic, strong)UITableView * packageTableview;
@property (nonatomic ,strong)NSMutableArray * dataArray;
@property (nonatomic, strong)UILabel * nocontentLabel;
@end
