//
//  CustomizeViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/5/12.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "CustomizeViewController.h"
#import "EGOImageButton.h"
#import "BookPreviewViewController.h"
#import "MonthBoxViewController.h"
#import "RootViewController.h"
#import "Common.h"
@interface CustomizeCell : UITableViewCell
@property (nonatomic,retain)EGOImageButton * imageV1;
@property (nonatomic,retain)EGOImageButton * imageV2;
@end
@implementation CustomizeCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageV1 = [[EGOImageButton alloc] initWithFrame:CGRectMake(5, 5, (ScreenWidth-16)/2, ((ScreenWidth-16)/2)*7/9)];
        self.imageV1.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.imageV1];
        
        self.imageV2 = [[EGOImageButton alloc] initWithFrame:CGRectMake(5+(ScreenWidth-16)/2+6, 5, (ScreenWidth-16)/2, ((ScreenWidth-16)/2)*7/9)];
        self.imageV2.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.imageV2];
    }
    return self;
}
@end

@interface CustomizeCell2 : UITableViewCell
@property (nonatomic,retain)EGOImageView * imageV;
@end
@implementation CustomizeCell2
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageV = [[EGOImageView alloc] initWithFrame:CGRectMake(5, 5, ScreenWidth-10, (ScreenWidth-10)*4/7)];
        self.imageV.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
        [self.contentView addSubview:self.imageV];
    }
    return self;
}
@end

@interface CustomizeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * listTV;
@property (nonatomic,strong) NSArray * partNameArray;
@property (nonatomic,strong) NSArray * goodsArray;
@end

@implementation CustomizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"私宠定制";
//    self.partNameArray = [NSArray arrayWithObjects:@"customize_bookIcon",@"customize_postcard",@"customize_pac",@"customize_dress",@"customize_marry", nil];
//    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = [UIColor redColor];
//    [btn setTitle:@"定制明信片" forState:UIControlStateNormal];
//    [btn setFrame:CGRectMake(100, 100, 200, 100)];
//    [self.view addSubview:btn];
//    [btn addTarget:self action:@selector(toPostCardViewController) forControlEvents:UIControlEventTouchUpInside];
    
    self.listTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,self.view.frame.size.height-navigationBarHeight-49) style:UITableViewStylePlain];
    self.listTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTV.contentInset = UIEdgeInsetsMake(0, 0, 5, 0);
    self.listTV.dataSource = self;
    self.listTV.delegate = self;
    [self.view addSubview:self.listTV];
    
    NSArray * vc = [[NSUserDefaults standardUserDefaults] objectForKey:@"custompagearray"];
    if (vc) {
        self.goodsArray = vc;
        [self.listTV reloadData];
    }
    
    [self.listTV addHeaderWithTarget:self action:@selector(tableViewHeaderRereshing:)];
    
    [self.listTV headerBeginRefreshing];
    // Do any additional setup after loading the view.
}
-(void)tableViewHeaderRereshing:(UITableView *)tableview
{
    [self getGoodsList];
}
-(void)getGoodsList
{
    NSMutableDictionary* updateDict = [NetServer commonDict];
    [updateDict setObject:@"layout" forKey:@"command"];
    [updateDict setObject:@"datum" forKey:@"options"];
    [updateDict setObject:@"7" forKey:@"code"];
    [NetServer requestWithParameters:updateDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.goodsArray = [responseObject objectForKey:@"value"];
        [self.listTV reloadData];
        [[NSUserDefaults standardUserDefaults] setObject:self.goodsArray forKey:@"custompagearray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.listTV headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.listTV headerEndRefreshing];
        [SVProgressHUD showErrorWithStatus:@"获取失败，请下拉刷新重新尝试"];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (ScreenWidth-10)*4/7+5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *goodsCellIdentifier2 = @"cuscell2";
    CustomizeCell2 *cell = [tableView dequeueReusableCellWithIdentifier:goodsCellIdentifier2];
    if (cell == nil) {
        cell = [[CustomizeCell2 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:goodsCellIdentifier2];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageV.imageURL = [NSURL URLWithString:self.goodsArray[indexPath.row][@"iconUrl"]];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.goodsArray[indexPath.row] objectForKey:@"key"] integerValue]==1) {
        [self toPostCardViewController];
    }
    else if ([[self.goodsArray[indexPath.row] objectForKey:@"key"] integerValue]==2){
        [self toBookPreviewViewController];
    }
    else if ([[self.goodsArray[indexPath.row] objectForKey:@"key"] integerValue]==3){
        if (![UserServe sharedUserServe].userName) {
            [[RootViewController sharedRootViewController] showLoginViewController];
            return;
        }
        ClothingListViewController * postV = [[ClothingListViewController alloc] init];
        postV.goodsKey = [self.goodsArray[indexPath.row] objectForKey:@"key"];
        postV.title = [self.goodsArray[indexPath.row] objectForKey:@"title"];
        [self.navigationController pushViewController:postV animated:YES];
    }
    else if ([[self.goodsArray[indexPath.row] objectForKey:@"key"] integerValue]==4){
        if (![UserServe sharedUserServe].userName) {
            [[RootViewController sharedRootViewController] showLoginViewController];
            return;
        }
        ClothingListViewController * postV = [[ClothingListViewController alloc] init];
        postV.goodsKey = [self.goodsArray[indexPath.row] objectForKey:@"key"];
        postV.title = [self.goodsArray[indexPath.row] objectForKey:@"title"];
        [self.navigationController pushViewController:postV animated:YES];
    }
        
}
-(void)toBookPreviewViewController
{
    if (![UserServe sharedUserServe].userName) {
        [[RootViewController sharedRootViewController] showLoginViewController];
        return;
    }
    BookPreviewViewController * book = [[BookPreviewViewController alloc] init];
    __block CustomizeViewController * blockSelf = self;
    book.finish = ^(NSInteger totalNum){
        BookDetailViewController * bv = [[BookDetailViewController alloc] init];
        bv.totalNum = totalNum;
        NSMutableArray * arr = [NSMutableArray arrayWithArray:blockSelf.navigationController.viewControllers];
        [arr replaceObjectAtIndex:arr.count-1 withObject:bv];
        blockSelf.navigationController.viewControllers = arr;
    };
    book.back = ^(){
        [blockSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:book animated:YES];
//    [self presentViewController:book animated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showNaviBg];
}
-(void)toPostCardViewController
{
    if (![UserServe sharedUserServe].userName) {
        [[RootViewController sharedRootViewController] showLoginViewController];
        return;
    }
//    PostCardPreviewViewController * postV = [[PostCardPreviewViewController alloc] init];
//    [self.navigationController pushViewController:postV animated:YES];
    PostCardFullScreenPreviewViewController * postV = [[PostCardFullScreenPreviewViewController alloc] init];
    postV.hideNaviBg = YES;
    [self.navigationController pushViewController:postV animated:YES];
}
-(void)toWhichPage:(UIButton *)sender
{
    if (![UserServe sharedUserServe].userName) {
        [[RootViewController sharedRootViewController] showLoginViewController];
        return;
    }
    if (sender.tag==2) {
        MonthBoxViewController * boxVC = [[MonthBoxViewController alloc] init];
        [self.navigationController pushViewController:boxVC animated:YES];
    }else if (sender.tag==3) {
        ClothingListViewController * postV = [[ClothingListViewController alloc] init];
        [self.navigationController pushViewController:postV animated:YES];
    }
    else if (sender.tag==4){
        UINavigationController * i = self.navigationController;
        [i.view setFrame:[UIScreen mainScreen].bounds];
        TOWebViewController * vb = [[TOWebViewController alloc] init];
        vb.fatherView = self.view;
        vb.url = [NSURL URLWithString:@"http://3g.163.com"];
        [self.navigationController pushViewController:vb animated:YES];
    }
}
-(void)toBookViewController
{
    if (![UserServe sharedUserServe].userName) {
        [[RootViewController sharedRootViewController] showLoginViewController];
        return;
    }
    PostCardPreviewViewController * postV = [[PostCardPreviewViewController alloc] init];
    [self.navigationController pushViewController:postV animated:YES];
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
