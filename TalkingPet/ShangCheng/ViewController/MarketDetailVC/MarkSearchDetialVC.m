//
//  MarketGoodsListVC.m
//  TalkingPet
//
//  Created by cc on 16/8/10.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "MarkSearchDetialVC.h"
#import "MarketCollectionViewCell.h"
#import "YZGoodsDetailVC.h"
#import "MJRefresh.h"
#import "NetServer+Payment.h"
#import "CommodityModel.h"
#import "GoodsSearchHeadV.h"
#import "TagCell.h"
#import "YZShangChengGoodsListCell.h"

#import "NetServer+ShangCheng.h"


@interface MarkSearchDetialVC()<UICollectionViewDataSource, UICollectionViewDelegate,UISearchBarDelegate>


@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *items;
//@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic ,strong)UISearchBar *searchBar;
@property (nonatomic ,strong)GoodsSearchHeadV *headerView;

@property (nonatomic,strong) UICollectionView *faceCollectionV;
@property (nonatomic ,assign)BOOL isDrop;
@property (nonatomic ,assign)NSInteger index;

@property (nonatomic ,assign)BOOL isLatest;

@property (nonatomic,assign)NSInteger pageIndex;// 页数下标@

@property (nonatomic ,copy)NSString * searchString;//搜索文字

@property (nonatomic ,copy)NSString * conditionStr;//排序条件

@property (nonatomic,assign)NSInteger tot;//总条数
@property (nonatomic,assign)NSInteger typeid;//分类

@property (nonatomic ,strong)UILabel *tooltip;



@end

@implementation MarkSearchDetialVC


-(void)creatUI
{
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入商品名称";
    [self.navigationItem setTitleView:_searchBar];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(inner_Pop:)];
    cancel.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = cancel;
    
    UICollectionViewFlowLayout* faceLayout = [[UICollectionViewFlowLayout alloc]init];
    //    faceLayout.itemSize = CGSizeMake((self.view.frame.size.width-21)/2,40);
    faceLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    faceLayout.minimumInteritemSpacing = 5;
    faceLayout.minimumLineSpacing = 10;
    faceLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGRect faceframe=CGRectMake(0, 40, ScreenWidth, 0);
    _faceCollectionV = [[UICollectionView alloc] initWithFrame:faceframe collectionViewLayout:faceLayout];
    _faceCollectionV.delegate = self;
    _faceCollectionV.dataSource = self;
    _faceCollectionV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_faceCollectionV];
    _faceCollectionV.showsHorizontalScrollIndicator = NO;
    _faceCollectionV.showsVerticalScrollIndicator=NO;
    [_faceCollectionV registerClass:[TagCell class] forCellWithReuseIdentifier:@"CollectionViewCell2"];
    _faceCollectionV.tag=1201;
    
}


-(void)cancelClick
{
    self.tot=0;
    self.pageIndex=0;
    self.typeid=0;
    [self.collectionView headerBeginRefreshing];
    [self.collectionView reloadData];
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
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setHidesBackButton:YES];
}


-(void)reloadTag
{
    
    [NetServer getDogGoodsDetailTagSuccess:^(id responseObject) {
        NSDictionary *dic=(NSDictionary*)responseObject;
        NSMutableArray *mArr=[NSMutableArray array];
        for (NSString *key in dic[@"data"]) {
            [mArr addObject:dic[@"data"][key]];
        }
        
        for (int i=0; i<mArr.count; i++) {
            if ([mArr[i][@"id" ] integerValue]==0) {
                
                if (i==0) {
                    break;
                }
                
                [mArr exchangeObjectAtIndex:i withObjectAtIndex:0];
                break ;
            }
        }
        self.titleArr=[mArr copy];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[self.titleArr copy] forKey:@"titleArr"];
        [defaults synchronize];
        [self.faceCollectionV reloadData];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *titleArr = [defaults objectForKey:@"titleArr"];
    
    if (titleArr) {
        self.titleArr=titleArr;
    }
    
    self.isLatest=YES;
    [self creatUI];
    [self reloadTag];
    
    self.index=NSIntegerMax;
    self.tot=0;
    self.pageIndex=0;
    self.typeid=0;
    self.conditionStr=@"time_desc";
    _headerView =[[GoodsSearchHeadV alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    __weak MarkSearchDetialVC * weakself=self;
    _headerView.block=^(NSInteger index)
    {
        
        [weakself loaddataWithindex:index];
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
    
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight-64-40)
                                                          collectionViewLayout:flowLayout];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor colorWithRed:.9
                                                     green:.9
                                                      blue:.9
                                                     alpha:1.f];
    [collectionView registerClass:[MarketCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass(self.class)];
    
    [collectionView registerClass:[YZShangChengGoodsListCell class] forCellWithReuseIdentifier:NSStringFromClass(self.class)];
    
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
    _collectionView.tag=1202;
    
    self.tooltip=[[UILabel alloc] initWithFrame:CGRectMake(0, collectionView.frame.size.height/3, ScreenWidth, 40)];
    self.tooltip.backgroundColor=[UIColor clearColor];
    self.tooltip.text=@"未检索到相关的产品";
    self.tooltip.textAlignment=NSTextAlignmentCenter;
    self.tooltip.textColor=[UIColor colorWithRed:188/255.f green:188/255.f blue:188/255.f alpha:1.00];
    self.tooltip.hidden=YES;
    [collectionView addSubview:self.tooltip];
    
    [collectionView addHeaderWithTarget:self action:@selector(inner_Refresh:)];
    [collectionView addFooterWithTarget:self action:@selector(inner_LoadMore:)];
    [collectionView headerBeginRefreshing];
}


-(void)loaddataWithindex:(NSInteger)index
{
    switch (index) {
        case 0:{
            
            _isLatest=YES;
            self.tot=0;
            self.pageIndex=0;
            self.conditionStr=@"time_desc";
            [self.collectionView headerBeginRefreshing];
            break;
        }
        case 1:
        {
            self.pageIndex=0;
            self.tot=0;
            _isLatest=NO;
            self.conditionStr=@"sales_desc";
            [self.collectionView headerBeginRefreshing];
            break;
        }
        case 2:
            [self dropIsShow];
            break;
        default:
            break;
    }
}

-(void)dropIsShow
{
    if (_isDrop) {
        [UIView animateWithDuration:0.3 animations:^{
            self.faceCollectionV.frame=CGRectMake(0, 40, ScreenWidth, 0);
            self.collectionView.frame=CGRectMake(0, 40, ScreenWidth, ScreenHeight-64-40);
        } completion:^(BOOL finished) {
            _isDrop=!_isDrop;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.faceCollectionV.frame=CGRectMake(0, 40, ScreenWidth, 50);
            self.collectionView.frame=CGRectMake(0, 90, ScreenWidth, ScreenHeight-64-90);
        } completion:^(BOOL finished) {
            _isDrop=!_isDrop;
        }];
    }
}



#pragma mark -- Refresh

- (void)inner_Refresh:(id)sender {
    [self inner_PostWithPageIndex:0 refresh:YES];
}
- (void)inner_LoadMore:(id)sender {
    [self inner_PostWithPageIndex:self.pageIndex refresh:NO];
}

#pragma mark--刷新&加载
- (void)inner_PostWithPageIndex:(NSInteger)pageIndex
                        refresh:(BOOL)refresh {
    
    self.tooltip.hidden=YES;
    
    
    if (refresh) {
        [self.collectionView footerEndRefreshing];
        self.pageIndex=0;
        self.tot=0;
    } else {
        [self.collectionView headerEndRefreshing];
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:[NetServer commonDict]];
    [parameters setObject:@"goods" forKey:@"skey"];
    [parameters setObject:@"20" forKey:@"psize"];
    [parameters setObject:@(self.pageIndex) forKey:@"p"];
    [parameters setObject:@(self.tot) forKey:@"tot"];
    [parameters setObject:@(self.typeid) forKey:@"type"];
    [parameters setObject:_isLatest?@"sales_desc":@"time_desc" forKey:@"orderby"];
    [parameters setObject:[self.searchString length]>0?self.searchString:@"" forKey:@"keywords"];
    __weak MarkSearchDetialVC *weakself=self;
    [NetServer getDogGoodsDetailInfoWithParameters:parameters success:^(id responseObject) {
        NSLog(@"json=======%@",responseObject);
        NSLog(@"message========%@",responseObject[@"message"]);
        
        if (self.pageIndex*20-self.tot>=20) {
            
            if (refresh) {
                
                [weakself.collectionView headerEndRefreshing];
            } else {
                
                [weakself.collectionView footerEndRefreshing];
            }
            return ;
        }
        NSDictionary *dic=(NSDictionary*)responseObject;
        NSMutableArray *mArr=[NSMutableArray array];
        
        for (NSString *skey in dic[@"data"]) {
            if ([skey isEqualToString:@"list"]) {
                for (NSDictionary *cdict in dic[@"data"][@"list"]) {
                    CommodityModel *cdmodel=[[CommodityModel alloc] init];
                    [cdmodel setValuesForKeysWithDictionary:cdict];
                    [mArr addObject:cdmodel];
                }
                weakself.tot=[dic[@"data"][@"tot"] integerValue];
                weakself.items=[mArr copy];
                weakself.pageIndex+=1;
                if (refresh) {
                    weakself.items = [NSArray arrayWithArray:mArr];
                    [weakself.collectionView headerEndRefreshing];
                } else {
                    weakself.items = [[NSArray arrayWithArray:weakself.items] arrayByAddingObjectsFromArray:mArr];
                    [weakself.collectionView footerEndRefreshing];
                }
            }
        }
        
        if(mArr.count==0)
        {
            NSLog(@"----------------------------------------");
            weakself.items=nil;
            if (refresh) {
                
                [weakself.collectionView headerEndRefreshing];
            } else {
                
                [weakself.collectionView footerEndRefreshing];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.tooltip.hidden=NO;
            });
            
            [weakself.collectionView reloadData];
        }
        
        [self.collectionView reloadData];
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        
    }];
    
}

#pragma mark -- UICollectionView

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag==1202) {
        
        
        YZShangChengGoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
        cell.goods = [CommodityModel replaceCommodityModelToYZGoodsModel:self.items[indexPath.row]];
        return cell;
        
        
        //        MarketCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.class) forIndexPath:indexPath];
        //        cell.model = self.items[indexPath.row];
        //        return cell;
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
        titleLable.text = self.titleArr[indexPath.row][@"typename"];
        cell.backgroundColor=[UIColor clearColor];
        cell.selected=NO;
        
        if (indexPath.row==self.index) {
            cell.selected=YES;
        }
        return cell;
    }
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag==1202) {
        
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
    
    if (collectionView.tag==1202) {
        
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        YZGoodsDetailVC *detailVC = [[YZGoodsDetailVC alloc] init];
        CommodityModel *goodsModel = self.items[indexPath.row];
        detailVC.goodsId = goodsModel.gid;
        detailVC.goodsName = goodsModel.name;
        detailVC.hideNaviBg = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else{
        NSLog(@"分类选择处理");
        
        if (self.index==indexPath.row) {
            self.index=NSIntegerMax;
            self.typeid=0;
        }
        else
        {
            self.index=indexPath.row;
            self.typeid=[self.titleArr[indexPath.row][@"id"] integerValue];
        }
        self.tot=0;
        _isLatest=NO;
        self.pageIndex=0;
        [self.collectionView headerBeginRefreshing];
        [self.faceCollectionV reloadData];
        [self.collectionView reloadData];
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag==1201) {
        CGSize size;
        size = [self.titleArr[indexPath.row][@"typename"] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
        return CGSizeMake(size.width+20,30);
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
    
    if(self.searchString.length>0){
        
        NSMutableArray *arr=[NSMutableArray array];
        for (CommodityModel *model in self.items) {
            if ([model.subname rangeOfString:self.searchString].length) {
                [arr addObject:model];
            }
        }
        if (self.index==NSIntegerMax) {
            self.typeid=0;
        }
        else
        {
            self.typeid=[self.titleArr[_index][@"id"] integerValue];
        }
        self.pageIndex=0;
        self.tot=0;
        [self.collectionView headerBeginRefreshing];
        [searchBar resignFirstResponder];
    }
    else
    {
        [self cancelClick];
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    self.searchString=searchText;
    
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    if (self.searchString.length==0) {
        [self cancelClick];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
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
