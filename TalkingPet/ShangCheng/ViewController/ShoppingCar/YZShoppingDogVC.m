//
//  YZShoppingDogVC.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/27.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShoppingDogVC.h"
#import "YZShoppingCarDogCell.h"
#import "NetServer+Payment.h"
#import "SVProgressHUD.h"
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
        [SVProgressHUD showWithStatus:@"删除中..."];
//        [NetServer deleteFromCartwithId:shoppingCarModel.shoppingCarFlag Success:^(id result) {
//            if ([result[@"code"] intValue]==200) {
//                [SVProgressHUD dismiss];
//                [[YZShoppingCarHelper instanceManager] removeShoppingCarItemWithScene:YZShangChengType_Dog
//                                                                                model:shoppingCarModel];
//                [self.tableView reloadData];
//            }
//            else
//                [SVProgressHUD showErrorWithStatus:@"删除失败，请重试"];
//        } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
//            [SVProgressHUD showErrorWithStatus:@"删除失败，请重试"];
//        }];
        
        
        NSMutableArray * ty = [NSMutableArray arrayWithArray:[YZShoppingCarHelper instanceManager].goodsnArray];
        for (int i = 0; i<ty.count; i++) {
            NSDictionary * dict = ty[i];
            if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"gid"]] isEqualToString:shoppingCarModel.shoppingCarFlag]) {
                [NetServer deleteFromCartwithId:[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]] Success:^(id result) {
                    if ([result[@"code"] intValue]==200) {
                        [SVProgressHUD dismiss];
                        [[YZShoppingCarHelper instanceManager] removeShoppingCarItemWithScene:YZShangChengType_Dog
                                                                                        model:shoppingCarModel];
                        [self.tableView reloadData];
                    }
                    else
                        [SVProgressHUD showErrorWithStatus:@"删除失败，请重试"];
                } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
                    [SVProgressHUD showErrorWithStatus:@"删除失败，请重试"];
                }];
                break;
            }
        }
        
    }
    
    if (shoppingCarModel.selected) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShoppingCarCalcutePriceNotification object:nil];
    }
}

@end
