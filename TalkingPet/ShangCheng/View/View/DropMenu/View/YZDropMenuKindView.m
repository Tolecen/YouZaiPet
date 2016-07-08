//
//  YZDropMenuKindView.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/24.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZDropMenuKindView.h"
#import "YZShangChengModel.h"
#import "YZShangChengKindScrollCell.h"

@interface YZDropMenuKindView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation YZDropMenuKindView

- (void)dealloc {
    _hots = nil;
    _alphabet = nil;
    _indexKeys = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass(self.class)];
        [tableView registerClass:[YZShangChengKindScrollCell class] forCellReuseIdentifier:NSStringFromClass(YZShangChengKindScrollCell.class)];
        [tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass(UITableViewHeaderFooterView.class)];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.sectionIndexColor = CommonGreenColor;
        if ([tableView respondsToSelector:@selector(sectionIndexBackgroundColor)]) {
            tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        }
        if ([tableView respondsToSelector:@selector(sectionIndexTrackingBackgroundColor)]) {
            tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        }
        [self addSubview:tableView];
        self.tableView = tableView;
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self).insets(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (void)reloadKindMenu {
    [self.tableView reloadData];
}

#pragma mark -- UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class)];
    YZShangChengKindScrollCell *scrollCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(YZShangChengKindScrollCell.class)];
    if (indexPath.section == 0) {
        scrollCell.hots = self.hots;
        return scrollCell;
    }
    YZDogTypeAlphabetModel *dogModel = self.alphabet[indexPath.section - 2][indexPath.row];
    cell.textLabel.text = dogModel.fullName;
    cell.textLabel.font = [UIFont systemFontOfSize:12.f];
    cell.textLabel.textColor = [UIColor colorWithRed:(83 / 255.f)
                                               green:(83 / 255.f)
                                                blue:(83 / 255.f)
                                               alpha:1.f];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 90;
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 + self.alphabet.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 0;
    }
    return self.alphabet.count;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexKeys;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(UITableViewHeaderFooterView.class)];
    if (section == 0) {
        headerView.textLabel.text = @"热门";
        headerView.textLabel.textColor = [UIColor colorWithRed:(198 / 255.f)
                                                         green:(198 / 255.f)
                                                          blue:(198 / 255.f)
                                                         alpha:1.f];
        headerView.contentView.backgroundColor = [UIColor colorWithRed:(228 / 255.f)
                                                                 green:(228 / 255.f)
                                                                  blue:(228 / 255.f)
                                                                 alpha:1.f];
    } else if (section == 1) {
        headerView.textLabel.text = @"全部";
        headerView.textLabel.textColor = [UIColor colorWithRed:(198 / 255.f)
                                                         green:(198 / 255.f)
                                                          blue:(198 / 255.f)
                                                         alpha:1.f];
        headerView.contentView.backgroundColor = [UIColor colorWithRed:(228 / 255.f)
                                                                 green:(228 / 255.f)
                                                                  blue:(228 / 255.f)
                                                                 alpha:1.f];
    } else if (section > 1) {
        headerView.textLabel.text = self.indexKeys[section - 2];
        headerView.contentView.backgroundColor = [UIColor whiteColor];
        headerView.textLabel.textColor = CommonGreenColor;
    }
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
