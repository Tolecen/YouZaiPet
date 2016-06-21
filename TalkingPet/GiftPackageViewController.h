//
//  GiftPackageViewController.h
//  TalkingPet
//
//  Created by Tolecen on 14/12/9.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MJRefresh.h"
#import "PackageInfoTableViewCell.h"
#import "PackageInfo.h"
#import "MyBagListViewController.h"
#import "SVProgressHUD.h"
@interface GiftPackageViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,PackageDelegate>{
    UIButton * currentButton;
    UIColor * currentColor;
    NSInteger currentIndex;
    NSInteger buttonIndex;
}
@property (nonatomic, strong)UITableView * packageTableview;
@property (nonatomic ,strong)NSMutableArray * dataArray;
@property (nonatomic ,strong)NSMutableArray * titleArray;
@property (nonatomic ,strong)NSMutableArray * codeArray;
@property (nonatomic, strong)UIView * sectionBtnView;
@property (nonatomic, strong)UIButton * commentNumBtn;
@property (nonatomic, strong)UIButton * favorNumBtn;
@property (nonatomic, strong)UILabel * nocontentLabel;
@end
