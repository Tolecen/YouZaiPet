//
//  PackageInfoTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 14/12/9.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "PackageInfoTableViewCell.h"

@implementation PackageInfoTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.view.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
//        self.bgV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 310, 115)];
//        [self.bgV setImage:[UIImage imageNamed:@"cellbgv"]];
//        self.bgV.alpha = 0.22;
//        [self.contentView addSubview:self.bgV];
//        self.bgV.layer.cornerRadius = 5;
//        self.bgV.layer.masksToBounds = YES;
        
        self.packageTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
        [self.packageTitleLabel setBackgroundColor:[UIColor clearColor]];
        [self.packageTitleLabel setTextColor:[UIColor colorWithWhite:100/255.0f alpha:1]];
        self.packageTitleLabel.font = [UIFont systemFontOfSize:15];
        self.packageTitleLabel.text = @"LV 1 会员大礼包";
        [self.contentView addSubview:self.packageTitleLabel];
        
        self.packageImageV = [[EGOImageView alloc] initWithFrame:CGRectMake(20, 35, 75, 75)];
        [self.packageImageV setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.packageImageV];
        self.packageImageV.layer.cornerRadius = 3;
        self.packageImageV.layer.masksToBounds = YES;
        self.packageImageV.placeholderImage = [UIImage imageNamed:@"package_holder"];
//        self.packageImageV setim
        
        self.statusImageV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-5-10-43, 10, 43, 16)];
        [self.statusImageV setImage:[UIImage imageNamed:@"package_statusbg"]];
        [self.contentView addSubview:self.statusImageV];
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 43, 16)];
        self.statusLabel.backgroundColor = [UIColor clearColor];
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.font = [UIFont systemFontOfSize:11];
        self.statusLabel.textColor = [UIColor whiteColor];
        self.statusLabel.text = @"可领取";
        [self.statusImageV addSubview:self.statusLabel];
        
        self.packageInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 30, ScreenWidth-120, 60)];
        self.packageInfoLabel.backgroundColor = [UIColor clearColor];
        self.packageInfoLabel.textColor = [UIColor colorWithWhite:100/255.0f alpha:1];
        self.packageInfoLabel.font = [UIFont systemFontOfSize:13];
        self.packageInfoLabel.numberOfLines = 0;
        self.packageInfoLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.packageInfoLabel.text = @"卡上的撒娇快接啊数据的拉伸快乐到家啊时间的克拉斯记得啦三联的卡斯加大实际到了卡萨丁克拉数据的卡手机大立科技啊稍等撒科技大厦可敬的萨达是阿克苏见大师级的卡上就啊了可适当加莱卡涉及到了卡斯就得阿克苏的境况拉伸的啊上课了多久啊三联的拉克丝加达拉斯";
        [self.contentView addSubview:self.packageInfoLabel];
        
        self.getButtton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.getButtton setFrame:CGRectMake(ScreenWidth/2+8, 120-15-20, 53, 30)];
        [self.getButtton setBackgroundImage:[UIImage imageNamed:@"package_getBtn"] forState:UIControlStateNormal];
        [self.getButtton setTitle:@"领取" forState:UIControlStateNormal];
        [self.getButtton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.getButtton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.getButtton];
        [self.getButtton addTarget:self action:@selector(getButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(10, 119, ScreenWidth-10, 1)];
        [lineV setBackgroundColor:[UIColor colorWithWhite:230/255.0f alpha:1]];
        [self.contentView addSubview:lineV];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.packageImageV.imageURL = [NSURL URLWithString:self.packageInfo.packageIconUrlStr];
    self.packageTitleLabel.text = self.packageInfo.packageTitle;
    self.packageInfoLabel.text = self.packageInfo.packageInfo;
    CGSize sz = [self.packageInfo.packageInfo sizeWithFont:self.packageInfoLabel.font constrainedToSize:CGSizeMake(ScreenWidth-120, 60) lineBreakMode:NSLineBreakByCharWrapping];

    if (self.packageInfo.canGet) {
        self.getButtton.hidden = NO;
        self.statusImageV.hidden = NO;
        self.statusLabel.text = @"可领取";
        [self.packageInfoLabel setFrame:CGRectMake(105, 35, ScreenWidth-120, 60)];
        self.packageInfoLabel.frame = CGRectMake(self.packageInfoLabel.frame.origin.x, 35, 220, sz.height);
    }
    else if (self.packageInfo.haveGot){
        self.getButtton.hidden = YES;
        self.statusImageV.hidden = NO;
        self.statusLabel.text = @"已领取";
        [self.packageInfoLabel setFrame:CGRectMake(105, 30, ScreenWidth-120, 80)];
    }
    else
    {
        self.getButtton.hidden = YES;
        self.statusImageV.hidden = YES;
//        self.statusLabel.text = @"已领取";
        [self.packageInfoLabel setFrame:CGRectMake(105, 30, ScreenWidth-120, 80)];
    }
    
    if (self.packageInfo.canPreview&&self.packageInfo.canGet){
//        self.getButtton.hidden = YES;
        self.getButtton.hidden = NO;
        self.statusImageV.hidden = NO;
        self.statusLabel.text = @"可领取";
//        [self.packageInfoLabel setFrame:CGRectMake(85, 30, 220, 40)];
        self.packageInfoLabel.frame = CGRectMake(self.packageInfoLabel.frame.origin.x, 35, 200, sz.height);
    }
    else if (self.packageInfo.canPreview&&self.packageInfo.haveGot){
        self.getButtton.hidden = YES;
        self.statusImageV.hidden = NO;
        self.statusLabel.text = @"已领取";
        [self.packageInfoLabel setFrame:CGRectMake(105, 30, ScreenWidth-120, 80)];
        
    }
    else if (self.packageInfo.canPreview){
        self.getButtton.hidden = YES;
        self.statusImageV.hidden = NO;
        self.statusLabel.text = @"可预览";
        [self.packageInfoLabel setFrame:CGRectMake(105, 30, ScreenWidth-120, 80)];

    }
//        self.packageInfoLabel.frame = CGRectMake(self.packageInfoLabel.frame.origin.x, self.packageInfoLabel.frame.origin.y, 220, sz.height);
}
-(void)getButtonClicked
{
    self.getButtton.enabled = NO;
    [SVProgressHUD showWithStatus:@"领取中"];
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"giftBag" forKey:@"command"];
    [mDict setObject:@"draw" forKey:@"options"];
    [mDict setObject:self.packageInfo.packageId forKey:@"code"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"no" forKey:@"petId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"error"] isEqualToString:@"200"]) {
            [SVProgressHUD showSuccessWithStatus:@"领取成功"];
            self.packageInfo.haveGot = YES;
            
            self.getButtton.hidden = YES;
            self.statusImageV.hidden = NO;
            self.statusLabel.text = @"已领取";
            [self.packageInfoLabel setFrame:CGRectMake(105, 30, ScreenWidth-120, 80)];
            [SystemServer sharedSystemServer].shouldReNewTree = YES;
            if ([self.delegate respondsToSelector:@selector(getPackageWithId:)]) {
                [self.delegate getPackageWithId:self.packageInfo.packageId];
            }

        }
        else
        {
            [SVProgressHUD dismiss];
        }
        self.getButtton.enabled = YES;
//        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"领取失败"];
        self.getButtton.enabled = YES;
    }];
}
- (void)awakeFromNib {
    // Initialization code
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
////    NSLog(@"selected");
//    // Configure the view for the selected state
//}

@end
