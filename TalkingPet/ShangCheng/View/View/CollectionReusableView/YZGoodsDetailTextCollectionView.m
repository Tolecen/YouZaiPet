//
//  YZGoodsDetailTextCollectionView.m
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/11.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZGoodsDetailTextCollectionView.h"

@implementation YZGoodsDetailTextCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor commonGrayColor];
        
        UILabel *allLb = [[UILabel alloc] init];
        allLb.text = @"相关推荐";
        allLb.textColor = [UIColor colorWithR:172
                                            g:172
                                            b:172 alpha:1.f];
        allLb.font = [UIFont systemFontOfSize:10];
        [self addSubview:allLb];
        
        [allLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

@end
