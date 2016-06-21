//
//  ClothingListViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/5/29.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "ClothingListViewController.h"
#import "EGOImageView.h"
@interface FuZhuangListCell : UITableViewCell
@property (nonatomic,strong)EGOImageView * thumImageV;
@property (nonatomic,strong)UILabel * titleL;
@property (nonatomic,strong)UIView * priceBg;
@property (nonatomic,strong)UILabel * yunfeiL;
@property (nonatomic,strong)UILabel * mcardPriceL;
@property (nonatomic,strong)UILabel * nL;
@property (nonatomic,strong)NSString * nPriceStr;
@end
@implementation FuZhuangListCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIView * bg = [[UIView alloc] initWithFrame:CGRectMake(5, 5, ScreenWidth-10, (ScreenWidth-10)*0.7+20+5+20+10)];
        bg.backgroundColor = [UIColor whiteColor];
        bg.layer.cornerRadius = 5;
        bg.layer.masksToBounds = YES;
        [self.contentView addSubview:bg];
        
        
        self.thumImageV = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-10, (ScreenWidth-10)*0.7)];
        self.thumImageV.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
        [bg addSubview:self.thumImageV];
        
//        UIImageView * g = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.thumImageV.frame.size.height-40, ScreenWidth, 40)];
//        g.backgroundColor = [UIColor clearColor];
//        g.image = [UIImage imageNamed:@"liebiaojianbian"];
////        g.alpha = 0.4;
//        [self.contentView addSubview:g];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, self.thumImageV.frame.size.height, ScreenWidth-20, 20)];
        self.titleL.backgroundColor = [UIColor clearColor];
        self.titleL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
        self.titleL.font = [UIFont systemFontOfSize:14];
        [bg addSubview:self.titleL];
        self.titleL.text = @"看的撒肯德基看SD卡数据库的框架金科了";
        
//        self.priceBg = [[UIView alloc] initWithFrame:CGRectMake(10, self.thumImageV.frame.size.height, ScreenWidth-20, 40)];
//        self.priceBg.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
//        [self.contentView addSubview:self.priceBg];
        
        self.nL = [[UILabel alloc] initWithFrame:CGRectMake(10, self.titleL.frame.size.height+self.titleL.frame.origin.y+5, ScreenWidth-20-120, 20)];
        self.nL.backgroundColor = [UIColor clearColor];
        self.nL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
        self.nL.font = [UIFont systemFontOfSize:13];
        self.nL.text = @"定制价:";
        [bg addSubview:self.nL];
        
//        CGSize u = [nL.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 20)];
        self.yunfeiL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-10-100, self.titleL.frame.size.height+self.titleL.frame.origin.y+5+2, 100, 20)];
        self.yunfeiL.backgroundColor = [UIColor clearColor];
        self.yunfeiL.font = [UIFont systemFontOfSize:12];
        self.yunfeiL.adjustsFontSizeToFitWidth = YES;
        self.yunfeiL.textAlignment = NSTextAlignmentRight;
        self.yunfeiL.textColor = [UIColor colorWithWhite:160/255.0f alpha:1];
        self.yunfeiL.text = @"免运费";
        [bg addSubview:self.yunfeiL];
        
//        self.mL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-100-100, 10, 100, 20)];
//        self.mL.backgroundColor = [UIColor clearColor];
//        self.mL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
//        self.mL.font = [UIFont systemFontOfSize:14];
//        self.mL.text = @"M卡用户:";
//        [self.priceBg addSubview:self.mL];
//        
////        CGSize u = [nL.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 20)];
//        self.mcardPriceL = [[UILabel alloc] initWithFrame:CGRectMake(u.width+10+2, 10, 100, 20)];
//        self.mcardPriceL.backgroundColor = [UIColor clearColor];
//        self.mcardPriceL.font = [UIFont systemFontOfSize:20];
////        self.mcardPriceL.textAlignment = NSTextAlignmentRight;
//        self.mcardPriceL.adjustsFontSizeToFitWidth = YES;
//        self.mcardPriceL.textColor = [UIColor colorWithRed:255/255.0f green:144/255.0f blue:83/255.0f alpha:1];
//        self.mcardPriceL.text = @"￥397";
//        [self.priceBg addSubview:self.mcardPriceL];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
//    CGSize u = [self.nPriceStr sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(100, 20)];
//    CGSize v = [self.nL.text  sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(100, 20)];
//    self.normalPriceL.frame = CGRectMake(ScreenWidth-10-u.width, 10, 100, 20);
//    self.normalPriceL.text = self.nPriceStr;
//    self.nL.frame = CGRectMake(self.normalPriceL.frame.origin.x-v.width, 10, 100, 20);
    NSString * priceStr =[NSString stringWithFormat:@"定制价：%@元",self.nPriceStr];
    NSMutableAttributedString * attributedStr3 = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:13] range: NSMakeRange(0, priceStr.length)];
    [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithWhite:130/255.0f alpha:1] range: NSMakeRange(0, priceStr.length)];
    [attributedStr3 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:20] range: NSMakeRange(4, priceStr.length-5)];
    [attributedStr3 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1] range: NSMakeRange(4, priceStr.length-5)];
    self.nL.attributedText = attributedStr3;
    
}
@end
@interface ClothingListViewController ()

@end

@implementation ClothingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageIndex = 0;
    self.squareKey = @"5";
    
    self.view.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
//    self.title = @"服装定制";
    [self setBackButtonWithTarget:@selector(backBtnDo:)];

    self.topbg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/3+10)];
    self.topbg.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    
    
    self.sameView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/3)];
    _sameView.delegate = self;
    _sameView.dataSource = self;
//    self.sameView.layer.cornerRadius = 5;
//    self.sameView.layer.masksToBounds = YES;
    //    _sameView.hidden = YES;
//    [self.view addSubview:_sameView];
    [self.topbg addSubview:self.sameView];
    
    UIPageControl * page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, ScreenWidth/3-20, ScreenWidth, 20)];
    page.currentPageIndicatorTintColor = [UIColor colorWithRed:135/255.0 green:130/255.0 blue:250/255.0 alpha:1];
    page.pageIndicatorTintColor = [UIColor colorWithWhite:200/255.0 alpha:1];
    _sameView.pageControl = page;
    [_sameView addSubview:page];
    
    
    self.listTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight)];
    self.listTableV.dataSource = self;
    self.listTableV.delegate = self;
    self.listTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTableV.backgroundColor = [UIColor clearColor];
    self.listTableV.rowHeight = (ScreenWidth-10)*0.7+20+5+20+10+5;
    [self.view addSubview:self.listTableV];
//    self.listTableV.tableHeaderView = self.topbg;
    
    [self.listTableV addHeaderWithTarget:self action:@selector(tableViewHeaderRereshing:)];
    //        [self.tableV headerBeginRefreshing];
    [self.listTableV addFooterWithTarget:self action:@selector(tableViewFooterRereshing:)];
    
    [self getClothList];
//    [self getTopContent];
    // Do any additional setup after loading the view.
}
- (void)tableViewHeaderRereshing:(UITableView *)tableView
{
    self.pageIndex = 0;
    [self getClothList];
}
- (void)tableViewFooterRereshing:(UITableView *)tableView
{
    [self getClothList];
}
-(void)endRefreshing:(UITableView *)tableView
{
    [self.listTableV footerEndRefreshing];
    [self.listTableV headerEndRefreshing];
    [self.listTableV reloadData];
    
}
-(void)getTopContent
{
    if (!self.squareKey) {
        return;
    }
    NSMutableDictionary* updateDict = [NetServer commonDict];
    [updateDict setObject:@"layout" forKey:@"command"];
    [updateDict setObject:@"datum" forKey:@"options"];
    [updateDict setObject:self.squareKey forKey:@"code"];
    [NetServer requestWithParameters:updateDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"GGGGGGGGGG:%@",responseObject);
        self.headerArray = [responseObject objectForKey:@"value"];
        if (self.headerArray.count>0) {
            self.listTableV.tableHeaderView = self.topbg;
        }
        else
            self.listTableV.tableHeaderView = nil;
        [self.sameView reloadData];
        //        [self setHeaderArray:[responseObject objectForKey:@"value"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
-(void)getClothList
{
//    [SVProgressHUD showWithStatus:@"获取商品信息..."];
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"product" forKey:@"command"];
    [usersDict setObject:@"listByCategory" forKey:@"options"];
    [usersDict setObject:self.goodsKey forKey:@"categoryId"];
    if ([UserServe sharedUserServe].currentPet.petID) {
        [usersDict setObject:[UserServe sharedUserServe].currentPet.petID forKey:@"petId"];
    }
    [usersDict setObject:[NSString stringWithFormat:@"%d",self.pageIndex] forKey:@"pageIndex"];
    [usersDict setObject:@"20" forKey:@"pageSize"];
    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * array = [responseObject objectForKey:@"value"];
        if (self.pageIndex==0) {
            self.goodsArray = [NSMutableArray arrayWithArray:array];
        }
        else
            [self.goodsArray addObjectsFromArray:array];
        
        [self endRefreshing:self.listTableV];
        
        self.pageIndex++;
//        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"商品获取失败"];
    }];

}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return self.sameView.frame.size.height;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ordercell = @"fuzhuanglistcell";
    FuZhuangListCell *cell = [tableView dequeueReusableCellWithIdentifier:ordercell];
    if (cell == nil) {
        cell = [[FuZhuangListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ordercell];
//        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * infoD = self.goodsArray[indexPath.row];
    cell.thumImageV.imageURL = [NSURL URLWithString:[infoD objectForKey:@"cover"]];
    cell.titleL.text = [infoD objectForKey:@"name"];
    NSString * yunfei = [infoD objectForKey:@"shippingFee"];
    if ([yunfei floatValue]==0) {
        cell.yunfeiL.text = @"免运费";
    }
    else
        cell.yunfeiL.text = [NSString stringWithFormat:@"运费:%@元",[infoD objectForKey:@"shippingFee"]];
    cell.nPriceStr = [infoD objectForKey:@"price"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClothDetailViewController * cv = [[ClothDetailViewController alloc] init];
    cv.pageType = [self.goodsKey intValue]==3?0:1;
    NSDictionary * infoD = self.goodsArray[indexPath.row];
    cv.productId = [infoD objectForKey:@"id"];
    cv.title = [infoD objectForKey:@"name"];
    [self.navigationController pushViewController:cv animated:YES];
}
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView
{
    return CGSizeMake(ScreenWidth, ScreenWidth/3);
}
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView
{

    return self.headerArray.count;
}
- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    
    EGOImageButton * imageV = (EGOImageButton*)[flowView dequeueReusableCell];
    if (!imageV) {
        imageV = [[EGOImageButton alloc] init];
        imageV.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
        imageV.frame = CGRectMake(0, 0, ScreenWidth-20, (ScreenWidth-20)*(1/4.0f));
    }
    imageV.tag = 200+index;
    [imageV addTarget:self action:@selector(tagButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    imageV.imageURL = [NSURL URLWithString:[self.headerArray[index] objectForKey:@"iconUrl"]];
    return imageV;
}
-(void)tagButtonTouched:(EGOImageButton *)sender
{
    int index = (int)sender.tag-200;
    NSDictionary * d = [self.headerArray objectAtIndex:index];
    NSString * type = [d objectForKey:@"handleType"];
    if ([type isEqualToString:@"12"]) {
        ClothDetailViewController * cv = [[ClothDetailViewController alloc] init];
        cv.productId = [d objectForKey:@"key"];
        cv.title = [d objectForKey:@"title"];
        [self.navigationController pushViewController:cv animated:YES];
    }
    else
    {
        NSString * urlStr = [d objectForKey:@"key"];
        if (urlStr) {
            if (urlStr.length>1) {
                TOWebViewController * vb = [[TOWebViewController alloc] init];
                vb.url = [NSURL URLWithString:urlStr];
                [self.navigationController pushViewController:vb animated:YES];
            }
        }
    }
}

-(void)backBtnDo:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
