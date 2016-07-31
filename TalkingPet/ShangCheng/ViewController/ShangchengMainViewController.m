//
//  ShangchengMainViewController.m
//  TalkingPet
//
//  Created by TaoXinle on 16/6/23.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "ShangchengMainViewController.h"
#import "YZShangChengDogListVC.h"
#import "YZShangChengGoodsListVC.h"
#import "YZShangChengBannerCell.h"
#import "YZShangChengDogListVC.h"

@interface ShangchengMainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation ShangchengMainViewController

#pragma mark -- Life Cycle

- (NSString *)title {
    return @"友仔商城";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"sousuo@2x"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightMoreItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(toSearchPage)];
    self.navigationItem.rightBarButtonItem = rightMoreItem;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 160.f;
    [tableView registerClass:[YZShangChengBannerCell class] forCellReuseIdentifier:NSStringFromClass(self.class)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
}
-(void)toSearchPage
{
    YZShangChengDogListVC  *search =[[YZShangChengDogListVC alloc]init];
    [self.navigationController pushViewController:search animated:YES];
    
    
    
}
#pragma mark -- UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZShangChengBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.class)];
    if (indexPath.section == 0) {
        cell.banner = @"gougou";
    } else if (indexPath.section == 1) {
        cell.banner = @"tuangou";
    } else {
        cell.banner = @"jingpin";
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 0;
    }
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        YZShangChengDogListVC *listVC = [[YZShangChengDogListVC alloc] init];
        [self.navigationController pushViewController:listVC animated:YES];
    } else {
        YZShangChengGoodsListVC *listVC = [[YZShangChengGoodsListVC alloc] init];
        [self.navigationController pushViewController:listVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
