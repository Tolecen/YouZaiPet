//
//  YZGoodsDetailTextCollectionView.m
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/11.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZDetailTextCollectionView.h"

@interface YZDetailTextCollectionView()

@property (nonatomic, weak) UILabel *textLb;

@end

@implementation YZDetailTextCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor commonGrayColor];
        
        UILabel *allLb = [[UILabel alloc] init];
        allLb.textColor = [UIColor colorWithR:172
                                            g:172
                                            b:172 alpha:1.f];
        allLb.font = [UIFont systemFontOfSize:10];
        [self addSubview:allLb];
        
        [allLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.centerX.equalTo(self);
        }];
        self.textLb = allLb;
    }
    return self;
}

- (void)setText:(NSString *)text {
    if (!text) {
        return;
    }
    _text = text;
    self.textLb.text = [NSString stringWithFormat:@"● %@ ●", text];
}

@end
