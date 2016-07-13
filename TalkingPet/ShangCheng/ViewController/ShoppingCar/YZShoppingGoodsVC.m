//
//  YZShoppingGoodsVC.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/27.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShoppingGoodsVC.h"
#import "YZShoppingCarGoodsCell.h"

@implementation YZShoppingGoodsVC

- (Class)registerCellClass {
    return [YZShoppingCarGoodsCell class];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 150.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [YZShoppingCarHelper instanceManager].goodsShangPinCache.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZShoppingCarGoodsCell *goodsCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self registerCellClass])];
    YZShoppingCarModel *shoppingCarModel = [YZShoppingCarHelper instanceManager].goodsShangPinCache[indexPath.row];
    goodsCell.detailModel = (YZGoodsDetailModel *)shoppingCarModel.shoppingCarItem;
    return goodsCell;
}

@end
