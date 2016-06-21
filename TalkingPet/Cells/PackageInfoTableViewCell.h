//
//  PackageInfoTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 14/12/9.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "PackageInfo.h"
#import "SVProgressHUD.h"
@protocol PackageDelegate <NSObject>
@optional
-(void)getPackageWithId:(NSString *)theId;
@end
@interface PackageInfoTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView * bgV;
@property (nonatomic,strong) UILabel * packageTitleLabel;
@property (nonatomic,strong) UILabel * packageInfoLabel;
@property (nonatomic,strong) EGOImageView * packageImageV;
@property (nonatomic,strong) UIImageView * statusImageV;
@property (nonatomic,strong) UILabel * statusLabel;
@property (nonatomic,strong) UIButton * getButtton;
@property (nonatomic,strong) PackageInfo * packageInfo;
@property (nonatomic, strong)id <PackageDelegate>delegate;
@end
