//
//  YZDogDetailCollectionHeaderView.m
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/11.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZDogDetailCollectionHeaderView.h"
#import "PagedFlowView.h"
#import "EGOImageView.h"
#import "YZShangChengConst.h"

@interface YZDogDetailCollectionHeaderView()<PagedFlowViewDataSource, PagedFlowViewDelegate>

@property (nonatomic, weak) PagedFlowView *flowView;
@property (nonatomic, weak) UILabel *nameLb;
@property (nonatomic, weak) UIImageView *sexImageV;
@property (nonatomic, weak) UILabel *daysNumberLb;
@property (nonatomic, weak) UILabel *priceLb;
@property (nonatomic, weak) UIImageView *birthdayImageV;
@property (nonatomic, weak) UILabel *birthdayLb;
@property (nonatomic, weak) UILabel *dogTypeLb;

@end

@implementation YZDogDetailCollectionHeaderView

- (void)dealloc {
    _detailModel = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        PagedFlowView *flowView = [[PagedFlowView alloc] init];
        flowView.delegate = self;
        flowView.dataSource = self;
        [self addSubview:flowView];
        self.flowView = flowView;
        
        UIPageControl *page = [[UIPageControl alloc] initWithFrame:CGRectZero];
        page.currentPageIndicatorTintColor = CommonGreenColor;
        page.pageIndicatorTintColor = [UIColor colorWithWhite:200/255.0 alpha:1];
        flowView.pageControl = page;
        [flowView addSubview:page];
        
        UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLb.font = [UIFont systemFontOfSize:16.f];
        nameLb.textColor = [UIColor colorWithRed:(102 / 255.f)
                                           green:(102 / 255.f)
                                            blue:(102 / 255.f)
                                           alpha:1.f];
        [self addSubview:nameLb];
        self.nameLb = nameLb;

        UIImageView *sexImageV = [[UIImageView alloc] init];
        sexImageV.image = [UIImage imageNamed:@"female_icon"];
        [self addSubview:sexImageV];
        self.sexImageV = sexImageV;
        
        UILabel *dogTypeLb = [[UILabel alloc] initWithFrame:CGRectZero];
        dogTypeLb.font = [UIFont systemFontOfSize:14];
        dogTypeLb.textColor = [UIColor colorWithRed:(102 / 255.f)
                                           green:(102 / 255.f)
                                            blue:(102 / 255.f)
                                           alpha:1.f];
        [self addSubview:dogTypeLb];
        self.dogTypeLb = dogTypeLb;


        UILabel *daysNumberLb = [[UILabel alloc] initWithFrame:CGRectZero];
        daysNumberLb.font = [UIFont systemFontOfSize:10.f];
        daysNumberLb.textColor = [UIColor colorWithRed:(181 / 255.f)
                                                 green:(181 / 255.f)
                                                  blue:(181 / 255.f)
                                                 alpha:1.f];
        [self addSubview:daysNumberLb];
        self.daysNumberLb = daysNumberLb;

        UILabel *priceLb = [[UILabel alloc] initWithFrame:CGRectZero];
        priceLb.font = [UIFont systemFontOfSize:16];
        priceLb.adjustsFontSizeToFitWidth = YES;
        priceLb.textAlignment = NSTextAlignmentRight;
        priceLb.textColor = [UIColor commonPriceColor];
        [self addSubview:priceLb];
        self.priceLb = priceLb;
        
        UIImageView *birthdayImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"birthday_icon"]];
        [birthdayImageV sizeToFit];
        [self addSubview:birthdayImageV];
        self.birthdayImageV = birthdayImageV;
        
        UILabel *birthdayLb = [[UILabel alloc] initWithFrame:CGRectZero];
        birthdayLb.font = [UIFont systemFontOfSize:10.f];
        birthdayLb.textColor = [UIColor colorWithRed:(188 / 255.f)
                                               green:(188 / 255.f)
                                                blue:(188 / 255.f)
                                               alpha:1.f];
        birthdayLb.adjustsFontSizeToFitWidth = YES;
        [self addSubview:birthdayLb];
        self.birthdayLb = birthdayLb;

        [flowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self).mas_offset(0);
            make.width.height.mas_equalTo(ScreenWidth);
        }];
        
        [page mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(flowView.mas_bottom).mas_offset(-10);
            make.centerX.mas_equalTo(flowView).mas_offset(0);
        }];
        
        [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(10);
            make.top.mas_equalTo(flowView.mas_bottom).mas_offset(15);
        }];
        
        [sexImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLb.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(nameLb).mas_offset(0);
        }];
        
        [dogTypeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(10);
            make.top.mas_equalTo(nameLb.mas_bottom).mas_offset(10);
        }];
        
        [daysNumberLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(10);
            make.top.mas_equalTo(dogTypeLb.mas_bottom).mas_offset(10);
        }];
        
        [birthdayImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(10);
            make.top.mas_equalTo(daysNumberLb.mas_bottom).mas_offset(10);
            make.width.height.mas_equalTo(CGRectGetWidth(birthdayImageV.frame));
        }];
        
        [birthdayLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(birthdayImageV.mas_right).mas_offset(5);
            make.centerY.mas_equalTo(birthdayImageV).mas_offset(0);
        }];
        
        [priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).mas_offset(-10);
            make.top.mas_equalTo(sexImageV.mas_centerY).mas_offset(0);
        }];
    }
    return self;
}

- (void)setDetailModel:(YZDogDetailModel *)detailModel {
    if (!detailModel || detailModel == _detailModel) {
        return;
    }
    _detailModel = detailModel;
    self.nameLb.text = detailModel.name;
    self.sexImageV.image = (detailModel.sex == YZDogSex_Female) ? [UIImage imageNamed:@"female_icon"] : [UIImage imageNamed:@"male_icon"];
    self.dogTypeLb.text = detailModel.productType.typeName;
    self.birthdayLb.text = detailModel.birthdayString;
    self.priceLb.text = [[YZShangChengConst sharedInstance].priceNumberFormatter stringFromNumber:[NSNumber numberWithDouble:detailModel.sellPrice]];

    NSString *daysNumberString = [NSString stringWithFormat:@"降临地球 %ld 天", (unsigned long)detailModel.birtydayDays];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:daysNumberString];
    [attr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.f], NSForegroundColorAttributeName: self.daysNumberLb.textColor} range:NSMakeRange(0, 4)];
    [attr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.f], NSForegroundColorAttributeName: CommonGreenColor} range:NSMakeRange(4, daysNumberString.length - 5)];
    [attr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.f], NSForegroundColorAttributeName: self.daysNumberLb.textColor} range:NSMakeRange(daysNumberString.length - 1, 1)];
    self.daysNumberLb.attributedText = attr;

    if (self.detailModel.images && self.detailModel.images.count > 1) {
        self.flowView.pageControl.numberOfPages = self.detailModel.images.count;
        self.flowView.pageControl.hidden = NO;
    } else {
        self.flowView.pageControl.hidden = YES;
    }
    [self.flowView reloadData];
    [self setNeedsUpdateConstraints];
}

- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView {
    if (self.detailModel.images && self.detailModel.images.count > 0) {
        return self.detailModel.images.count;
    }
    return 1;
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
    EGOImageView * imageV = (EGOImageView*)[flowView dequeueReusableCell];
    if (!imageV) {
        imageV = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"dog_placeholder"]];
        imageV.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
        imageV.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth);
    }
    if (self.detailModel.images && self.detailModel.images.count > 0) {
        YZDogImage *imageModel = self.detailModel.images[index];
        [imageV setImageURL:[NSURL URLWithString:imageModel.url]];
    }
    return imageV;
}

- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView {
    return CGSizeMake(ScreenWidth, ScreenWidth);
}

@end
