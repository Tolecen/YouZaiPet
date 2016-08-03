//
//  YZShoppingGoodsVC.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/27.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZShoppingGoodsVC.h"
#import "YZShoppingCarGoodsCell.h"

@interface YZShoppingGoodsVC()

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *previousBarButton;

@end

@implementation YZShoppingGoodsVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _toolbar = nil;
    _previousBarButton = nil;
}

- (Class)registerCellClass {
    return [YZShoppingCarGoodsCell class];
}

- (void)inner_RegisterNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 150.f;
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame), ScreenWidth, 44)];
    [_toolbar setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.previousBarButton = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(previousButtonIsClicked:)];
    NSArray *barButtonItems = @[flexBarButton,self.previousBarButton];
    _toolbar.items = barButtonItems;
    [self.view addSubview:_toolbar];
    
    [self inner_RegisterNotification];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [YZShoppingCarHelper instanceManager].goodsShangPinCache.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZShoppingCarGoodsCell *goodsCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self registerCellClass])];
    YZShoppingCarModel *shoppingCarModel = [YZShoppingCarHelper instanceManager].goodsShangPinCache[indexPath.row];
    goodsCell.detailModel = shoppingCarModel;
    return goodsCell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    YZShoppingCarModel *shoppingCarModel = [YZShoppingCarHelper instanceManager].goodsShangPinCache[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[YZShoppingCarHelper instanceManager] removeShoppingCarItemWithScene:YZShangChengType_Goods
                                                                        model:shoppingCarModel];
    }
    [self.tableView reloadData];
    if (shoppingCarModel.selected) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kShoppingCarCalcutePriceNotification object:nil];
    }
}

- (void)previousButtonIsClicked:(id)sender {
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
    
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    NSArray *subviews = [self.view subviews];
    for (UIView *sub in subviews) {
        if ([sub isKindOfClass:[UITableView class]]) {
            sub.frame = CGRectMake(0, 0, sub.frame.size.width, CGRectGetMaxY(self.view.frame) - rect.size.height);
            sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, sub.frame.size.height/2);
        } else {
            sub.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), ScreenWidth, 44);
        }
    }
    [UIView commitAnimations];
}

- (void)keyboardShow:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
}

- (void)keyboardWillHide:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    NSArray *subviews = [self.view subviews];
    for (UIView *sub in subviews) {
        if (sub.center.y < CGRectGetHeight(self.view.frame)/2.0) {
            sub.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, CGRectGetHeight(self.view.frame)/2.0);
        }
    }
    _toolbar.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame), ScreenWidth, _toolbar.frame.size.height);
    self.tableView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(self.view.frame));
    [UIView commitAnimations];
}

- (void)keyboardHide:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
}

@end
