//
//  YZShoppingDogVC.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/27.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShoppingDogVC.h"
#import "YZShoppingCarDogCell.h"

@implementation YZShoppingDogVC

- (Class)registerCellClass {
    return [YZShoppingCarDogCell class];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 196.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZShoppingCarDogCell *dogCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self registerCellClass])];
    return dogCell;
}

@end
