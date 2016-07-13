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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [YZShoppingCarHelper instanceManager].dogShangPinCache.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZShoppingCarDogCell *dogCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self registerCellClass])];
    YZShoppingCarModel *shoppingCarModel = [YZShoppingCarHelper instanceManager].dogShangPinCache[indexPath.row];
    dogCell.detailModel = (YZDogDetailModel *)shoppingCarModel.shoppingCarItem;
    return dogCell;
}

@end
