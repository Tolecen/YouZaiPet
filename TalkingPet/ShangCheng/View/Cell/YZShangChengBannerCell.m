//
//  YZShangChengBannerCell.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/23.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShangChengBannerCell.h"

@interface YZShangChengBannerCell()

@property (nonatomic, weak) UIImageView *bannerImageV;

@end

@implementation YZShangChengBannerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *bannerImageV = [[UIImageView alloc] init];
        [self.contentView addSubview:bannerImageV];
        self.bannerImageV = bannerImageV;
        [bannerImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (void)setBanner:(NSString *)banner {
    _banner = banner;
    self.bannerImageV.image = [UIImage imageNamed:banner];
}

@end
