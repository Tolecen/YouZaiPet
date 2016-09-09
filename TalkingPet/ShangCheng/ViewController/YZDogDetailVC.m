//
//  YZShangChengDetailVC.m
//  TalkingPet
//
//  Created by LiuXiaoyu on 16/6/23.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "YZDogDetailVC.h"
#import "YZShoppingCarVC.h"
#import "YZQuanSheDetailViewController.h"
#import "YZShangChengDogListCell.h"
#import "YZDogDetailCollectionHeaderView.h"
#import "YZDetailTextCollectionView.h"
#import "YZDogDetalMiddleView.h"

#import "YZDetailBottomBar.h"
#import "NetServer+ShangCheng.h"
#import "MJRefresh.h"
#import "YZShangChengShareHelper.h"
#import "YZShoppingCarHelper.h"
#import "SVProgressHUD.h"
#import "RootViewController.h"
#import "NetServer+Payment.h"
#import "YZOrderConfimViewController.h"

@interface YZDogDetailVC()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, YZDetailBottomBarDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) YZDogDetailModel *detailModel;

@property (nonatomic, copy) NSArray *items;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) NSMutableDictionary *cache;


@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) UIView *sanjiaoView;

@property (nonatomic, assign)BOOL isShow;

@end

@implementation YZDogDetailVC

- (void)dealloc {
    _dogModel = nil;
    _detailModel = nil;
    _items = nil;
    _cache = nil;
}

- (void)inner_Pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAnotherBackButtonWithTarget:@selector(inner_Pop:)];
    [self setRightButtonWithName:nil BackgroundImg:@"goods_more" Target:@selector(moreBtnClicked)];
    self.cache = [[NSMutableDictionary alloc] init];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10.f;
    flowLayout.minimumLineSpacing = 10.f;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                                          0,
                                                                                          ScreenWidth,
                                                                                          ScreenWidth)
                                                          collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor colorWithRed:.9
                                                     green:.9
                                                      blue:.9
                                                     alpha:1.f];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class)];
    [collectionView registerClass:[YZShangChengDogListCell class] forCellWithReuseIdentifier:NSStringFromClass(YZShangChengDogListCell.class)];
    [collectionView registerClass:[YZDogDetailCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(YZDogDetailCollectionHeaderView.class)];
    [collectionView registerClass:[YZDogDetalMiddleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(YZDogDetalMiddleView.class)];
    [collectionView registerClass:[YZDetailTextCollectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(YZDetailTextCollectionView.class)];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view).mas_offset(0);
        make.bottom.mas_equalTo(self.view).mas_offset(-50);
    }];
    
    [collectionView addFooterWithTarget:self action:@selector(inner_LoadMore:)];
    
    
#pragma mark--进入购物车按钮（在下方工具栏更改工程量太大 so....）
    UIView *sanjiaoView=[[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-10)/2, ScreenHeight-65, 10, 10)];
    
    sanjiaoView.backgroundColor=[UIColor colorWithRed:0.40 green:0.79 blue:0.69 alpha:1.00];
    
    sanjiaoView.transform=CGAffineTransformMakeRotation(M_PI/4);
    self.sanjiaoView=sanjiaoView;
    self.sanjiaoView.hidden=YES;
    [self.view addSubview:self.sanjiaoView];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake(ScreenWidth/3, ScreenHeight-90, ScreenWidth
                         /3, 30);
    [btn setTitle:@"去狗窝结算" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor=[UIColor colorWithRed:0.40 green:0.79 blue:0.69 alpha:1.00];
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius=15;
    self.btn=btn;
    self.btn.hidden=YES;
    [self.view addSubview:self.btn];
    
    
    
    
    
    YZDetailBottomBar *bottomBar = [[YZDetailBottomBar alloc] initWithFrame:CGRectZero type:YZShangChengType_Dog];
    bottomBar.delegate = self;
    [self.view addSubview:bottomBar];
    [bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view).mas_offset(0);
        make.height.mas_offset(50);
    }];
    
    [self inner_GetDogDetail];
    [self inner_GetDogListWithLoadMore:NO];
}

- (void)inner_GetDogDetail {
    if (!self.dogModel.dogId) {
        return;
    }
    WS(weakSelf);
    [NetServer getDogDetailInfoWithDogId:self.dogModel.dogId
                                 success:^(YZDogDetailModel *detailModel) {
                                     weakSelf.detailModel = detailModel;
                                     [weakSelf.collectionView reloadData];
                                 }
                                 failure:^(NSError *error, AFHTTPRequestOperation *operation) {
                                     
                                 }];
}

- (void)inner_GetDogListWithLoadMore:(BOOL)loadMore {
    NSInteger pageIndex = loadMore ? self.pageIndex : 1 ;
    WS(weakSelf);
    [NetServer searchDogListWithType:self.dogModel.productType.dogTypeId
                             keyword:nil
                                size:YZDogSize_All
                                 sex:YZDogSex_All
                           sellPrice:YZDogValueRange_All
                                area:nil
                                 age:YZDogAgeRange_All
                              shopId:nil
                           pageIndex:pageIndex
                             success:^(NSArray *items, NSInteger nextPageIndex) {
                                 if (items && items.count > 0) {
                                     weakSelf.pageIndex = nextPageIndex;
                                     
                                     NSMutableArray * fg = [NSMutableArray arrayWithArray:items];
                                     for (int i = 0; i<items.count; i++) {
                                         YZDogModel * dog = items[i];
                                         if ([self.dogModel.dogId isEqualToString:dog.dogId]) {
                                             [fg removeObjectAtIndex:i];
                                             break;
                                         }
                                     }
                                     
                                     
                                     if (loadMore) {
                                         weakSelf.items = [[NSArray arrayWithArray:weakSelf.items] arrayByAddingObjectsFromArray:fg];
                                     } else {
                                         weakSelf.items = [NSArray arrayWithArray:fg];
                                     }
                                     [weakSelf.collectionView footerEndRefreshing];
                                     [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:2]];
                                 } else {
                                     if (loadMore) {
                                         [weakSelf.collectionView footerEndRefreshing];
                                     }
                                 }
                             }
                             failure:^(NSError *error, AFHTTPRequestOperation *operation) {
                                 if (loadMore) {
                                     [weakSelf.collectionView footerEndRefreshing];
                                 }
                             }];
}

- (void)inner_LoadMore:(id)sender {
    [self inner_GetDogListWithLoadMore:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self showNaviBg];
}

#pragma mark -- UICollectionView

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsZero;
    }
    else if (section==1){
        return UIEdgeInsetsZero;
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeZero;
    }
    else if (indexPath.section == 1) {
        return CGSizeZero;
    }
    CGFloat width = (ScreenWidth - 30) / 2;
    return CGSizeMake(width,
                      width / 5 * 6);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.detailModel) {
            return CGSizeMake(ScreenWidth, ScreenWidth + 190);
        }
        return CGSizeZero;
    }
    else if (section == 1) {
        if (self.detailModel) {
            return CGSizeMake(ScreenWidth, 200);
        }
        return CGSizeZero;
    }
    return CGSizeMake(ScreenWidth, 30);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.detailModel ? 1 : 0;
    }
    else if (section == 1) {
        return self.detailModel ? 0: 0;
    }
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UICollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class) forIndexPath:indexPath];
        return collectionViewCell;
    }
    else if (indexPath.section == 1) {
        UICollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(UICollectionViewCell.class) forIndexPath:indexPath];
        return collectionViewCell;
    }
    YZShangChengDogListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(YZShangChengDogListCell.class) forIndexPath:indexPath];
    cell.dogModel = self.items[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            YZDogDetailCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(YZDogDetailCollectionHeaderView.class) forIndexPath:indexPath];
            headerView.detailModel = self.detailModel;
            headerView.backgroundColor = [UIColor whiteColor];
            return headerView;
        }
        else if (indexPath.section == 1) {
            YZDogDetalMiddleView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(YZDogDetalMiddleView.class) forIndexPath:indexPath];
            headerView.detailModel = self.detailModel;
            headerView.backgroundColor = [UIColor whiteColor];
            return headerView;
        }else {
            YZDetailTextCollectionView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(YZDetailTextCollectionView.class) forIndexPath:indexPath];
            reusableView.text = @"邻舍狗狗";
            return reusableView;
        }
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        YZDogDetailVC *detailVC = [[YZDogDetailVC alloc] init];
        YZDogModel *dogModel = self.items[indexPath.row];
        detailVC.dogModel = dogModel;
        detailVC.hideNaviBg = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark --

- (void)shareAction {
    [YZShangChengShareHelper shareWithScene:YZShangChengType_Dog
                                     target:self
                                      model:nil
                                    success:nil
                                    failure:nil];
}

-(void)btnClick
{
    if (![self inner_AlreadyLogin]) {
        return;
    }
    YZShoppingCarVC *shoppingCarVC = [[YZShoppingCarVC alloc] init];
    shoppingCarVC.selectedIndex = 0;
    [self.navigationController pushViewController:shoppingCarVC animated:YES];
    
    
}

#pragma  mark -- 清算按钮代理事件
- (void)clearPriceAction {
    if (![self inner_AlreadyLogin]) {
        return;
    }
    
    [NetServer addToCartwithId:self.dogModel.dogId Success:^(id result) {
        if ([result[@"code"] intValue]==200) {
            [[YZShoppingCarHelper instanceManager] shoppingCarSelectedAllWithSelectedState:NO];
            
            [[YZShoppingCarHelper instanceManager] addShoppingCarWithScene:YZShangChengType_Dog
                                                                     model:self.detailModel
                                                                clearPrice:YES];
            YZOrderConfimViewController *viewC = [[YZOrderConfimViewController alloc] init];
            [self.navigationController pushViewController:viewC animated:YES];
            
            
        }
        else if([result[@"code"] intValue]==400)
        {
            [SVProgressHUD showErrorWithStatus:result[@"message"]];
        }
        
        if(_isShow)
        {
            self.btn.hidden=YES;
            self.sanjiaoView.hidden=YES;
        }else
        {
            self.btn.hidden=NO;
            self.sanjiaoView.hidden=NO;
        }
        _isShow=!_isShow;
        
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [SVProgressHUD showErrorWithStatus:@"添加到购物车失败，请重试"];
    }];
    
}

- (void)enterDogHomeAction {
    YZQuanSheDetailViewController *quanShe = [[YZQuanSheDetailViewController alloc] init];
    quanShe.quanSheId = self.detailModel.shop.shopId;
    quanShe.quanSheName = self.detailModel.shop.shopName;
    [self.navigationController pushViewController:quanShe animated:YES];
}

#pragma  mark -- 放入狗窝
- (void)addShoppingCarAction {
    if (![self inner_AlreadyLogin]) {
        return;
    }
    if (!self.dogModel) {
        return;
    }
    [SVProgressHUD showWithStatus:@"添加到购物车..."];
    [NetServer addToCartwithId:self.dogModel.dogId Success:^(id result) {
        if ([result[@"code"] intValue]==200) {
            [[YZShoppingCarHelper instanceManager] addShoppingCarWithScene:YZShangChengType_Dog
                                                                     model:self.dogModel
                                                                clearPrice:NO];
            [SVProgressHUD showSuccessWithStatus:@"已添加到购物车"];
            
        }
        else if([result[@"code"] intValue]==400)
        {
            [SVProgressHUD showErrorWithStatus:result[@"message"]];
        }
        
        if(_isShow)
        {
            self.btn.hidden=YES;
            self.sanjiaoView.hidden=YES;
        }else
        {
            self.btn.hidden=NO;
            self.sanjiaoView.hidden=NO;
        }
        _isShow=!_isShow;
        
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [SVProgressHUD showErrorWithStatus:@"添加到购物车失败，请重试"];
    }];
    
    
    
    
    
}

- (BOOL)inner_AlreadyLogin {
    NSString *currentPetId = [UserServe sharedUserServe].userID;
    if (!currentPetId) {
        [[RootViewController sharedRootViewController] showLoginViewController];
        return NO;
    }
    return YES;
}


-(void)moreBtnClicked
{
    if (!self.detailModel) {
        return;
    }
    NSString * goodsName = [Common filterHTML:self.detailModel.name];
    NSString * content = [Common filterHTML:self.detailModel.content];
    if (!content || content.length<1) {
        content = @" ";
    }
    ShareSheet * shareSheet = [[ShareSheet alloc]initWithIconArray:@[@"weiChatFriend",@"friendCircle",@"sina",@"qq"] titleArray:@[@"微信好友",@"朋友圈",@"微博",@"QQ"] action:^(NSInteger index) {
        switch (index) {
            case 0:{
                [ShareServe shareToWeixiFriendWithTitle:[NSString stringWithFormat:@"%@",goodsName] Content:[NSString stringWithFormat:@"%@",content] imageUrl:self.detailModel.thumb webUrl:[NSString stringWithFormat:SHAREDOGSBASEURL@"%@",self.detailModel.dogId] Succeed:^{
                    
                }];
            }break;
            case 1:{
                [ShareServe shareToFriendCircleWithTitle:[NSString stringWithFormat:@"%@",goodsName] Content:[NSString stringWithFormat:@"%@",content] imageUrl:self.detailModel.thumb webUrl:[NSString stringWithFormat:SHAREDOGSBASEURL@"%@",self.detailModel.dogId] Succeed:^{
                    
                }];
            }break;
            case 2:{
                [ShareServe shareToSineWithContent:[NSString stringWithFormat:@"%@,%@,%@",goodsName,content,[NSString stringWithFormat:SHAREDOGSBASEURL@"%@",self.detailModel.dogId]] imageUrl:self.detailModel.thumb Succeed:^{
                    
                }];
            }break;
            case 3:{
                [ShareServe shareToQQWithTitle:[NSString stringWithFormat:@"%@",goodsName] Content:[NSString stringWithFormat:@"%@",content] imageUrl:self.detailModel.thumb webUrl:[NSString stringWithFormat:SHAREDOGSBASEURL@"%@",self.detailModel.dogId] Succeed:^{
                    
                }];
            }break;
                
            default:
                break;
        }
        
    }];
    [shareSheet show];
}

@end
