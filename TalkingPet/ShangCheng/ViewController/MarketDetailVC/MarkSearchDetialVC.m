//
//  MarkSearchDetialVC.m
//  TalkingPet
//
//  Created by cc on 16/8/12.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "MarkSearchDetialVC.h"

#import "YZGoodsDetailVC.h"
#import "MJRefresh.h"
#import "NetServer+Payment.h"
#import "CommodityModel.h"
#import "GoodsSearchHeadV.h"
#import "TagCell.h"
#import "MarketCollectionViewCell.h"

#import "NetServer+ShangCheng.h"




@interface MarkSearchDetialVC ()<UICollectionViewDataSource, UICollectionViewDelegate,UISearchBarDelegate>


@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *items;
//@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic ,strong)UISearchBar *searchBar;
@property (nonatomic ,strong)GoodsSearchHeadV *headerView;

@property (nonatomic,strong) UICollectionView *faceCollectionV;

@property (nonatomic ,assign)BOOL isDrop;


@end

@implementation MarkSearchDetialVC


-(void)creatUI
{
    
    UIImage *backImage = [UIImage imageNamed:@"shangcheng_back_icon"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStyleDone target:self action:@selector(inner_Pop:)];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入商品名称";
    [self.navigationItem setTitleView:_searchBar];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    cancel.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = cancel;
    
    
    
    UICollectionViewFlowLayout* faceLayout = [[UICollectionViewFlowLayout alloc]init];
    //    faceLayout.itemSize = CGSizeMake((self.view.frame.size.width-21)/2,40);
    faceLayout.sectionInset = UIEdgeInsetsMake(1, 5, 1, 5);
    faceLayout.minimumInteritemSpacing = 1;
    faceLayout.minimumLineSpacing = 5;
    faceLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGRect faceframe=CGRectMake(0, 30, ScreenWidth, 30);
    _faceCollectionV = [[UICollectionView alloc] initWithFrame:faceframe collectionViewLayout:faceLayout];
    _faceCollectionV.delegate = self;
    _faceCollectionV.dataSource = self;
    _faceCollectionV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_faceCollectionV];
    _faceCollectionV.showsHorizontalScrollIndicator = NO;
    _faceCollectionV.showsVerticalScrollIndicator=NO;
    [_faceCollectionV registerClass:[TagCell class] forCellWithReuseIdentifier:@"CollectionViewCell2"];
    //    _faceCollectionV.hidden=YES;
    _faceCollectionV.tag=1101;
    
}


-(void)cancelClick
{
    
}


-(void)loadData
{
    __weak MarkSearchDetialVC *weakself=self;
//    [NetServer getMarketDetailGoodsWithlink:self.link success:^(id result) {
//        NSDictionary *dic=(NSDictionary*)result;
//        NSMutableArray *mArr=[NSMutableArray array];
//        for (NSDictionary *cdict in dic[@"data"]) {
//            CommodityModel *cdmodel=[[CommodityModel alloc] init];
//            [cdmodel setValuesForKeysWithDictionary:cdict];
//            [mArr addObject:cdmodel];
//        }
//        weakself.items=mArr;
//        [weakself sorteditemWithindex:0];
//        weakself.titleArr=[weakself sorttitleArr];
//        [weakself.faceCollectionV reloadData];
//        [weakself.collectionView reloadData];
//        
//    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
//        
//    }];
}

-(NSArray *)sorttitleArr
{
    NSMutableArray *mTitleArr=[NSMutableArray array];
    mTitleArr=[self.titleArr mutableCopy];
    for (CommodityModel *obj in self.items) {
        [mTitleArr addObject:[obj.name copy]];
    }
    NSSet *set = [NSSet setWithArray:mTitleArr];
    NSArray *arr=[set allObjects];
    return arr;
    
}



- (void)dealloc {
    NSLog(@"dealloc:[%@]", self);
    _items = nil;
}

- (void)inner_Pop:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (void)inner_MoreAction:(id)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(inner_Pop:)];
    
    [self creatUI];
    [self loadData];
    
    
    _headerView =[[GoodsSearchHeadV alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    
    
    __weak  MarkSearchDetialVC * weakself=self;
    _headerView.block=^(NSInteger index)
    {
        [weakself sorteditemWithindex:index];
        [weakself.collectionView reloadData];
        
    };
    
    [self.view addSubview:_headerView];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10.f;
    flowLayout.minimumLineSpacing = 10.f;
    UIEdgeInsets sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.sectionInset = sectionInset;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - sectionInset.left - sectionInset.right - 10) / 2;
    flowLayout.itemSize = CGSizeMake(width,
                                     width / 5 * 6);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, ScreenHeight-64-60)
                                                          collectionViewLayout:flowLayout];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor colorWithRed:.9
                                                     green:.9
                                                      blue:.9
                                                     alpha:1.f];
    [collectionView registerClass:[MarketCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass(self.class)];
    
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
    _collectionView.tag=1102;
    
    [collectionView addHeaderWithTarget:self action:@selector(inner_Refresh:)];
}

-(void)sorteditemWithindex:(NSInteger)index
{
    NSLog(@"排序处理！！！！%ld",(long)index);
    
    switch (index) {
        case 0:
            self.items=[[self.items sortedArrayUsingSelector:@selector(compareModelUseTime:)] copy];
            
            break;
        case 1:
            self.items=[[self.items sortedArrayUsingSelector:@selector(compareModelSales:)] copy];
            break;
        case 2:
            
            if (!_isDrop) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.faceCollectionV.frame=CGRectMake(0, 30, ScreenWidth, 0);
                    self.collectionView.frame=CGRectMake(0, 30, ScreenWidth, ScreenHeight-64-30);
                } completion:^(BOOL finished) {
                    _isDrop=!_isDrop;
                }];
            }
            else
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.faceCollectionV.frame=CGRectMake(0, 30, ScreenWidth, 30);
                    self.collectionView.frame=CGRectMake(0, 60, ScreenWidth, ScreenHeight-64-60);
                } completion:^(BOOL finished) {
                    _isDrop=!_isDrop;
                }];
            }
            
            break;
        default:
            break;
    }
}

-(void)foldView
{
    self.faceCollectionV.frame=CGRectMake(0, 30, ScreenWidth, 0);
    self.collectionView.frame=CGRectMake(0, 30, ScreenWidth, ScreenHeight-64-30);
    
}

-(void)dropView
{
    self.faceCollectionV.frame=CGRectMake(0, 30, ScreenWidth, 30);
    self.collectionView.frame=CGRectMake(0, 60, ScreenWidth, ScreenHeight-64-60);
    
    
}



#pragma mark -- Refresh

- (void)inner_Refresh:(id)sender {
    [self inner_PostWithPageIndex:1 refresh:YES];
}

#pragma mark--刷新&加载
- (void)inner_PostWithPageIndex:(NSInteger)pageIndex
                        refresh:(BOOL)refresh {
    if (refresh) {
        [self.collectionView footerEndRefreshing];
    } else {
        [self.collectionView headerEndRefreshing];
    }
    
    __weak MarkSearchDetialVC *weakself=self;
    
//    [NetServer getMarketDetailGoodsWithlink:self.link success:^(id result) {
//        NSDictionary *dic=(NSDictionary*)result;
//        NSMutableArray *mArr=[NSMutableArray array];
//        for (NSDictionary *cdict in dic[@"data"]) {
//            CommodityModel *cdmodel=[[CommodityModel alloc] init];
//            [cdmodel setValuesForKeysWithDictionary:cdict];
//            [mArr addObject:cdmodel];
//        }
//        
//        self.items=mArr;
//        
//        if (refresh) {
//            [weakself.collectionView headerEndRefreshing];
//        } else {
//            [weakself.collectionView footerEndRefreshing];
//        }
//        
//        [weakself sorteditemWithindex:0];
//        [weakself.collectionView reloadData];
//        
//    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
//        if (refresh) {
//            [weakself.collectionView headerEndRefreshing];
//        } else {
//            [weakself.collectionView footerEndRefreshing];
//        }
//    }];
    
    
    
    [self.collectionView headerEndRefreshing];
    
    
}

#pragma mark -- UICollectionView

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag==1102) {
        MarketCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
        cell.model = self.items[indexPath.row];
        return cell;
    }
    else
    {
        static NSString *SectionCellIdentifier = @"CollectionViewCell2";
        TagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SectionCellIdentifier forIndexPath:indexPath];
        for (UIView *view in [cell.contentView subviews])
        {
            [view removeFromSuperview];
        }
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        [cell.contentView addSubview:titleLable];
        titleLable.layer.masksToBounds=YES;
        titleLable.layer.cornerRadius=12;
        titleLable.layer.borderWidth=1;
        titleLable.layer.borderColor=CommonGreenColor.CGColor;
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.backgroundColor = [UIColor clearColor];
        titleLable.textColor = CommonGreenColor;
        titleLable.font = [UIFont systemFontOfSize:13];
        titleLable.text = self.titleArr[indexPath.row];
        cell.backgroundColor=[UIColor clearColor];
        
        return cell;
    }
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag==1102) {
        
        return self.items.count;
    }
    else
    {
        return self.titleArr.count;
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView.tag==1102)
    {
        
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        YZGoodsDetailVC *detailVC = [[YZGoodsDetailVC alloc] init];
        CommodityModel *goodsModel = self.items[indexPath.row];
        detailVC.goodsId = goodsModel.gid;
        detailVC.goodsName = goodsModel.name;
        detailVC.hideNaviBg = YES;
//        detailVC.link=goodsModel.link;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else{
        NSLog(@"分类选择处理");
        
        
        NSMutableArray * arr=[NSMutableArray array];
        for (CommodityModel *obj in self.items) {
            if ([obj.name isEqualToString: _titleArr[indexPath.row]]) {
                [arr addObject:obj];
            }
        }
        self.items=arr;
        [self.collectionView reloadData];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag==1101) {
        CGSize size;
        size = [self.titleArr[indexPath.row] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
        return CGSizeMake(size.width+1,25);
    }
    else
    {
        CGFloat width = (ScreenWidth - 30) / 2;
        return CGSizeMake(width, width / 5 * 6);
    }
    
}



#pragma mark -- UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //    点击搜索按钮事件处理
    [searchBar resignFirstResponder];
    //    [self.collectionView headerBeginRefreshing];
    
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    NSLog(@"searchText%@",searchText);
    
//    [NetServer getDogGoodsDetailInfoWithGoodsname:searchText success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
//        
//    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
//        
//    }];
    
    
    
}








- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.searchBar resignFirstResponder];
    
    
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
