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
    dogCell.detailModel = shoppingCarModel;
    return dogCell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    YZShoppingCarModel *shoppingCarModel = [YZShoppingCarHelper instanceManager].dogShangPinCache[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[YZShoppingCarHelper instanceManager] removeShoppingCarItemWithScene:YZShangChengType_Dog
                                                                        model:shoppingCarModel];
    }
    [self.tableView reloadData];
    if (shoppingCarModel.selected) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShoppingCarCalcutePriceNotification object:nil];
    }
}

@end
