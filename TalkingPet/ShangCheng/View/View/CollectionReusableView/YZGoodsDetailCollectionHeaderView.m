//
//  YZGoodsDetailCollectionHeaderView.m
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/11.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZGoodsDetailCollectionHeaderView.h"
#import "PagedFlowView.h"
#import "EGOImageView.h"
#import "YZShangChengConst.h"

@interface YZGoodsDetailCollectionHeaderView()<PagedFlowViewDataSource, PagedFlowViewDelegate, UIWebViewDelegate>

@property (nonatomic, weak) UILabel *titleLb;

//@property (nonatomic, weak) UILabel *contentLb;

@property (nonatomic, weak) UILabel *priceLb;

@property (nonatomic, weak) PagedFlowView *flowView;

@property (nonatomic, weak) UIWebView *webView;

@end

@implementation YZGoodsDetailCollectionHeaderView

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
        
        UILabel *titleLb = [[UILabel alloc] init];
        titleLb.font = [UIFont systemFontOfSize:14];
        titleLb.numberOfLines = 2;
        [self addSubview:titleLb];
        self.titleLb = titleLb;
        
//        UILabel *contentLb = [[UILabel alloc] init];
//        contentLb.font = [UIFont systemFontOfSize:12];
//        contentLb.textColor = [UIColor commonGrayColor];
//        contentLb.numberOfLines = 0;
//        [self addSubview:contentLb];
//        self.contentLb = contentLb;
        UIWebView *webView = [[UIWebView alloc] init];
        webView.scalesPageToFit = YES;
        webView.delegate = self;
        [self addSubview:webView];
        self.webView = webView;
        
        UILabel *priceLb = [[UILabel alloc] init];
        priceLb.font = [UIFont systemFontOfSize:15];
        priceLb.textColor = [UIColor commonPriceColor];
        [self addSubview:priceLb];
        self.priceLb = priceLb;
        
        [flowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(self).mas_offset(0);
            make.width.height.mas_equalTo(ScreenWidth);
        }];
        
        CGFloat titleHeight = ceil(titleLb.font.lineHeight * 2) + 1;
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(flowView.mas_bottom).mas_offset(15);
            make.left.mas_equalTo(self).mas_offset(10);
            make.right.mas_equalTo(self).mas_offset(-10);
            make.height.mas_lessThanOrEqualTo(titleHeight);
        }];
        
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self).mas_offset(0);
            make.height.mas_equalTo(100);
            make.top.mas_equalTo(titleLb.mas_bottom).mas_offset(15);
        }];
        
//        [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(titleLb.mas_bottom).mas_offset(15);
//            make.left.mas_equalTo(self).mas_offset(10);
//            make.right.mas_equalTo(self).mas_offset(-10);
//            make.height.mas_lessThanOrEqualTo(1000);
//        }];
        
        [priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(webView.mas_bottom).mas_offset(0);
            make.left.mas_equalTo(self).mas_offset(10);
            make.right.mas_equalTo(self).mas_offset(-10);
        }];
        
        NSArray * xcImagvArr = [NSArray arrayWithObjects:@"1",@"2", nil];
        NSArray * xcTitleArr = [NSArray arrayWithObjects:@"正品保障",@"一线品牌", nil];
        
        for (int i = 0; i<2; i++) {
            UIView * xcView = [[UIView alloc] initWithFrame:CGRectZero];
            [self addSubview:xcView];
            UIImageView * aimgv = [[UIImageView alloc] initWithFrame:CGRectZero];
            aimgv.image = [UIImage imageNamed:xcImagvArr[i]];
            [xcView addSubview:aimgv];
            UILabel * tL = [[UILabel alloc] initWithFrame:CGRectZero];
            tL.backgroundColor = [UIColor clearColor];
            tL.font = [UIFont systemFontOfSize:10];
            tL.textColor = CommonGreenColor;
            tL.adjustsFontSizeToFitWidth = YES;
            [xcView addSubview:tL];
            tL.text = [xcTitleArr objectAtIndex:i];
            
            [xcView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.priceLb).mas_offset(50*(i+1)+70*i);
//                make.top.mas_equalTo(webView.mas_bottom).mas_offset(0);
                make.centerY.mas_equalTo(self.priceLb);
                make.height.mas_equalTo(20);
                make.width.mas_equalTo(80);
            }];
            
            [aimgv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(2);
                make.left.mas_equalTo(0);
                make.height.mas_equalTo(16);
                make.width.mas_equalTo(16);
            }];
            
            [tL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(aimgv.mas_right).mas_offset(4);
                make.height.mas_equalTo(20);
                make.width.mas_equalTo(60);
            }];
        }
    }
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(webView.scrollView.contentSize.height);
    }];
    [self.delegate reloadHeaderWithWebHeight:webView.scrollView.contentSize.height];
}

- (void)setDetailModel:(YZGoodsDetailModel *)detailModel {
    if (!detailModel || detailModel == _detailModel) {
        return;
    }
    _detailModel = detailModel;
    self.titleLb.text = [Common filterHTML:detailModel.name];
//    self.contentLb.text = [Common filterHTML:detailModel.content];
//    if (!detailModel.content || detailModel.content.length == 0) {
//        [self.priceLb mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.contentLb.mas_bottom).mas_offset(0);
//        }];
//    }
    self.priceLb.text = [[YZShangChengConst sharedInstance].priceNumberFormatter stringFromNumber:[NSNumber numberWithDouble:detailModel.sellPrice]];
    [self.flowView reloadData];
    NSString *htmlString = [detailModel.content stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    [self.webView loadHTMLString:htmlString baseURL:nil];
    [self setNeedsUpdateConstraints];
}

- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView {
    return 1;
}

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index {
    EGOImageView * imageV = (EGOImageView*)[flowView dequeueReusableCell];
    if (!imageV) {
        imageV = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"dog_goods_placeholder"]];
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
