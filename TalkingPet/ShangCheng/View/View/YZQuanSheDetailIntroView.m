//
//  YZQuanSheDetailIntroView.m
//  TalkingPet
//
//  Created by Xiaoyu Liu on 16/7/7.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZQuanSheDetailIntroView.h"
#import "YZQuanSheDetailIntroCell.h"
#import "Common.h"
@interface YZQuanSheDetailIntroHeaderView : UIView

@property (nonatomic, strong) YZQuanSheDetailModel *detailModel;
@property (nonatomic, weak) UILabel *keeperLb;
@property (nonatomic, weak) UILabel *addressLb;
@property (nonatomic, weak) UILabel *dogLb;
@property (nonatomic, weak) UILabel *detailLb;
@property (nonatomic, assign) CGFloat height;

@end

@implementation YZQuanSheDetailIntroHeaderView

- (UILabel *)inner_CreateIntroLb {
    UILabel *lb = [[UILabel alloc] init];
    lb.font = [UIFont systemFontOfSize:13];
    lb.textColor = [UIColor colorWithR:189 g:189 b:189 alpha:1];
    return lb;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *introLb = [[UILabel alloc] init];
        introLb.font = [UIFont systemFontOfSize:13];
        introLb.textColor = [UIColor colorWithR:102 g:102 b:102 alpha:1];
        [self addSubview:introLb];
        introLb.text = @"● 犬舍介绍 ●";
        
        UILabel *keeperLb = [self inner_CreateIntroLb];
        [self addSubview:keeperLb];
        self.keeperLb = keeperLb;
        
        UILabel *dogLb = [self inner_CreateIntroLb];
        [self addSubview:dogLb];
        self.dogLb = dogLb;
        
        UILabel *addressLb = [self inner_CreateIntroLb];
        [self addSubview:addressLb];
        self.addressLb = addressLb;
        
        UILabel *detailLb = [self inner_CreateIntroLb];
        detailLb.numberOfLines = 0;
        detailLb.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:detailLb];
        self.detailLb = detailLb;
        
        [introLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).mas_offset(10);
            make.centerX.mas_equalTo(self);
        }];
        
        [keeperLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(introLb.mas_bottom).mas_offset(10);
            make.left.mas_equalTo(self).mas_offset(10);
        }];
        
        [dogLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(keeperLb.mas_bottom).mas_offset(8);
            make.left.mas_equalTo(self).mas_offset(10);
        }];
        
        [addressLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(dogLb.mas_bottom).mas_offset(8);
            make.left.mas_equalTo(self).mas_offset(10);
        }];
        
        [detailLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(10);
            make.right.mas_equalTo(self).mas_offset(-10);
            make.top.mas_equalTo(addressLb.mas_bottom).mas_offset(8);
            make.height.mas_equalTo(200);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor commonGrayColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(0);
            make.right.mas_equalTo(self).mas_offset(0);
            make.top.mas_equalTo(detailLb.mas_bottom).mas_offset(8);
            make.height.mas_equalTo(.5);
        }];
    }
    return self;
}

- (void)setDetailModel:(YZQuanSheDetailModel *)detailModel {
    if (!detailModel || _detailModel == detailModel) {
        return;
    }
    _detailModel = detailModel;
    self.keeperLb.text = [NSString stringWithFormat:@"主理人 %@", detailModel.shopKeeper];
    self.dogLb.text = [NSString stringWithFormat:@"主营犬 %@", detailModel.shopName];
    self.addressLb.text = [NSString stringWithFormat:@"地    址 %@", detailModel.shopAddress];
    self.detailLb.text = [Common filterHTML:detailModel.dogIntro];
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.detailLb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.height);
    }];
}

@end

@interface YZQuanSheDetailIntroView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UIView *containerView;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) YZQuanSheDetailIntroHeaderView *headerView;

@end

@implementation YZQuanSheDetailIntroView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
        self.alpha = 0.f;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inner_HideQuanSheIntro:)];
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
        containerView.backgroundColor = [UIColor whiteColor];
        containerView.layer.cornerRadius = 5.f;
        containerView.layer.masksToBounds = YES;
        [self addSubview:containerView];
        self.containerView = containerView;
        
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.mas_equalTo(self).mas_offset(-290);
            make.width.mas_equalTo(self).mas_offset(-40);
            make.height.mas_equalTo(self).mas_offset(-290);
        }];
        [self addGestureRecognizer:tapGesture];
        
        self.headerView = [[YZQuanSheDetailIntroHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(containerView.frame), 300)];
        
        UITableView *tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 100;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[YZQuanSheDetailIntroCell class] forCellReuseIdentifier:NSStringFromClass([YZQuanSheDetailIntroCell class])];
        [containerView addSubview:tableView];
        self.tableView = tableView;
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(containerView).insets(UIEdgeInsetsZero);
        }];
        
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(containerView.frame), 10)];
    }
    return self;
}

- (void)inner_HideQuanSheIntro:(UITapGestureRecognizer *)gesture {
    [UIView animateWithDuration:.5
                          delay:0.f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.alpha = 0.f;
                         [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                             make.centerY.mas_equalTo(self).mas_offset(-290);
                         }];
                         [self layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)show {
    [UIView animateWithDuration:.5
                          delay:0.f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.alpha = 1.f;
                         [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
                             make.centerY.mas_equalTo(self).mas_offset(0);
                         }];
                         [self layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)setDetailModel:(YZQuanSheDetailModel *)detailModel {
    if (!detailModel || _detailModel == detailModel) {
        return;
    }
    _detailModel = detailModel;
    CGFloat height = 0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        height = [[Common filterHTML:detailModel.dogIntro] boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.containerView.frame) - 20, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]}
                                                    context:NULL].size.height;
    } else {
        height = [[Common filterHTML:detailModel.dogIntro] sizeWithFont:[UIFont systemFontOfSize:13]
                                  constrainedToSize:CGSizeMake(CGRectGetWidth(self.containerView.frame) - 20, CGFLOAT_MAX)
                                      lineBreakMode:NSLineBreakByWordWrapping].height;
    }
    CGRect frame = self.headerView.frame;
    frame.size.height = ceil(height) + 1 + 115;
    self.headerView.frame = frame;
    self.headerView.height = ceil(height) + 1;
    self.headerView.detailModel = detailModel;
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView reloadData];
}

#pragma mark -- UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZQuanSheDetailIntroCell *introCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YZQuanSheDetailIntroCell class])];
    introCell.parents = self.detailModel.dogParents[indexPath.row];
    return introCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detailModel.dogParents.count;
}

@end
