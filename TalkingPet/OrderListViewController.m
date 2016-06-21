//
//  OrderListViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/5/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "OrderListViewController.h"
#import "EGOImageView.h"
#import "TalkingBrowse.h"
@protocol NumChangeDelegate <NSObject>
@optional
-(void)numChangedTo:(NSInteger)num Index:(NSInteger)index;
@end
@interface OrderCell : UITableViewCell
@property (nonatomic,strong)EGOImageView * thumImageV;
@property (nonatomic,strong)UILabel * titleL;
@property (nonatomic,strong)UILabel * timeL;
@property (nonatomic,strong)UIButton * minusBtn;
@property (nonatomic,strong)UIButton * plusBtn;
@property (nonatomic,strong)UILabel * numL;
@property (nonatomic,assign)NSInteger cellIndex;
@property (nonatomic,assign)id <NumChangeDelegate>delegate;
@end
@implementation OrderCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIView * bgv = [[UIView alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth, 80)];
        bgv.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgv];
        
        self.thumImageV = [[EGOImageView alloc] initWithFrame:CGRectMake(5, 10, 70, 70)];
        self.thumImageV.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
        [self.contentView addSubview:self.thumImageV];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(85, 10, ScreenWidth-85-10, 40)];
        self.titleL.backgroundColor = [UIColor clearColor];
        self.titleL.font = [UIFont systemFontOfSize:14];
        self.titleL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
        self.titleL.numberOfLines = 0;
        self.titleL.lineBreakMode = NSLineBreakByCharWrapping;
        self.titleL.text = @"这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试这是测试";
        [self.contentView addSubview:self.titleL];
        
        
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(105, 50, 80, 30)];
        self.numL.backgroundColor = [UIColor clearColor];
        self.numL.textColor = [UIColor colorWithRed:255/255.0f green:144/255.0f blue:83/255.0f alpha:1];
        self.numL.font = [UIFont systemFontOfSize:20];
        self.numL.text = @"12";
        self.numL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.numL];
        
        
        self.minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.minusBtn setFrame:CGRectMake(85, 50, 30, 30)];
        [self.minusBtn setTitle:@"-" forState:UIControlStateNormal];
        [self.minusBtn setTitleColor:[UIColor colorWithWhite:120/255.0f alpha:1] forState:UIControlStateNormal];
        [self.minusBtn.titleLabel setFont:[UIFont systemFontOfSize:24]];
        [self.contentView addSubview:self.minusBtn];
        [self.minusBtn addTarget:self action:@selector(minusNum) forControlEvents:UIControlEventTouchUpInside];
        
        self.plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.plusBtn setFrame:CGRectMake(175, 50, 30, 30)];
        [self.plusBtn setTitle:@"+" forState:UIControlStateNormal];
        [self.plusBtn setTitleColor:[UIColor colorWithWhite:120/255.0f alpha:1] forState:UIControlStateNormal];
        [self.plusBtn.titleLabel setFont:[UIFont systemFontOfSize:24]];
        [self.contentView addSubview:self.plusBtn];
        [self.plusBtn addTarget:self action:@selector(plusNum) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)minusNum
{
    self.numL.text = [NSString stringWithFormat:@"%d",([self.numL.text intValue]-1)>=1?([self.numL.text intValue]-1):1];
    if ([self.delegate respondsToSelector:@selector(numChangedTo:Index:)]) {
        [self.delegate numChangedTo:[self.numL.text integerValue] Index:self.cellIndex];
    }
}
-(void)plusNum
{
    self.numL.text = [NSString stringWithFormat:@"%d",[self.numL.text intValue]+1];
    if ([self.delegate respondsToSelector:@selector(numChangedTo:Index:)]) {
        [self.delegate numChangedTo:[self.numL.text integerValue] Index:self.cellIndex];
    }
}


@end


@interface OrderListViewController ()<NumChangeDelegate>

@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    self.title = @"订单列表";
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    
    self.listKeyArray = [self.orderListDict allKeys];
    
    self.listTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(self.view.frame)-40-navigationBarHeight) style:UITableViewStylePlain];
    self.listTableV.backgroundView = nil;
    self.listTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTableV.backgroundColor = [UIColor clearColor];
    self.listTableV.rowHeight = 85;
    self.listTableV.delegate = self;
    self.listTableV.dataSource = self;
    [self.view addSubview:self.listTableV];
    self.listTableV.contentInset = UIEdgeInsetsMake(0, 0, 5, 0);
    
    UIButton * tolistBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tolistBtn setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-40-navigationBarHeight, ScreenWidth-150, 40)];
    [tolistBtn setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tolistBtn];
//    [tolistBtn addTarget:self action:@selector(ConfirmOrder) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setBackgroundColor:[UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1]];
    [buyBtn setTitle:@"立刻下单" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn setFrame:CGRectMake(ScreenWidth-150, CGRectGetHeight(self.view.frame)-40-navigationBarHeight, 150, 40)];
    [self.view addSubview:buyBtn];
    [buyBtn addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * picon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 26, 20)];
    [picon setImage:[UIImage imageNamed:@"postcard_icon"]];
    [tolistBtn addSubview:picon];
    
    UILabel * l = [[UILabel alloc] initWithFrame:CGRectMake(45, 13, 20, 20)];
    l.backgroundColor = [UIColor clearColor];
    l.text = @"×";
    l.font = [UIFont systemFontOfSize:14];
    l.textColor = [UIColor colorWithWhite:130/255.0f alpha:1];
    [tolistBtn addSubview:l];
    
    self.numL = [[UILabel alloc] initWithFrame:CGRectMake(55, 13, 40, 20)];
    self.numL.backgroundColor = [UIColor clearColor];
    self.numL.text = [NSString stringWithFormat:@"%d",(int)self.allNum];
    self.numL.font = [UIFont systemFontOfSize:14];
    self.numL.adjustsFontSizeToFitWidth = YES;
    self.numL.textColor = [UIColor colorWithWhite:130/255.0f alpha:1];
    [tolistBtn addSubview:self.numL];
    
    self.allPriceL = [[UILabel alloc] initWithFrame:CGRectMake(85, 10, ScreenWidth-150-85-10, 20)];
    [self.allPriceL setBackgroundColor:[UIColor clearColor]];
    self.allPriceL.textAlignment = NSTextAlignmentRight;
    //    [self.priceL setText:@"￥5元/张"];
    [self.allPriceL setFont:[UIFont systemFontOfSize:16]];
    self.allPriceL.adjustsFontSizeToFitWidth= YES;
    [self.allPriceL setTextColor:[UIColor colorWithRed:255/255.0f green:144/255.0f blue:83/255.0f alpha:1]];
    [tolistBtn addSubview:self.allPriceL];
//    self.allPriceStr = @"共0元";
    
    NSMutableAttributedString * attributedStr2 = [[NSMutableAttributedString alloc] initWithString:self.allPriceStr];
    [attributedStr2 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:16] range: NSMakeRange(0, self.allPriceStr.length)];
    [attributedStr2 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithWhite:130/255.0f alpha:1] range: NSMakeRange(0, self.allPriceStr.length)];
    [attributedStr2 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(1, self.allPriceStr.length-2)];
    [attributedStr2 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1] range: NSMakeRange(1, self.allPriceStr.length-2)];
    self.allPriceL.attributedText = attributedStr2;

    // Do any additional setup after loading the view.
}
-(NSMutableArray *)getSpecsForKey:(NSString *)key
{
    NSDictionary * template = [NSDictionary dictionaryWithObjectsAndKeys:@"postcardTmplId",@"id",[[[[[self.goodsInfoDict objectForKey:@"specs"] firstObject] objectForKey:@"values"] firstObject] objectForKey:@"id"],@"value", nil];
    NSDictionary * petalkId = [NSDictionary dictionaryWithObjectsAndKeys:@"petalkId",@"id",key,@"value", nil];
    NSMutableArray * array = [NSMutableArray arrayWithObjects:template,petalkId, nil];
    
    return array;
}
-(void)submitOrder
{
    if ([self.numL.text integerValue]<8) {
        [SVProgressHUD showErrorWithStatus:@"明信片最少选择8张才能下单哦~"];
        return;
    }
    
    NSMutableArray * itemArray =[NSMutableArray array];
    NSArray * keysArray = [self.orderListDict allKeys];
    for (int i = 0; i<keysArray.count; i++) {
        NSMutableDictionary * infoD = [NSMutableDictionary dictionary];
        [infoD setObject:[self.goodsInfoDict objectForKey:@"id"] forKey:@"productId"];
        [infoD setObject:[self.goodsInfoDict objectForKey:@"updateTime"] forKey:@"productUpdateTime"];
        [infoD setObject:@"false" forKey:@"useCard"];
        [infoD setObject:[NSString stringWithFormat:@"%d",(int)[[self.orderListDict objectForKey:keysArray[i]] count]] forKey:@"count"];
        [infoD setObject:[self getSpecsForKey:keysArray[i]] forKey:@"specs"];
        [itemArray addObject:infoD];
    }
    
    [SVProgressHUD showWithStatus:@"提交订单中..."];
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"order" forKey:@"command"];
    [usersDict setObject:@"create" forKey:@"options"];
    [usersDict setObject:itemArray forKey:@"orderItems"];
    if ([UserServe sharedUserServe].currentPet.petID) {
        [usersDict setObject:[UserServe sharedUserServe].currentPet.petID forKey:@"petId"];
    }
    [NetServer requestWithEncryptParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self toConfirmPageWithOrderId:[responseObject objectForKey:@"value"]];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"订单提交有问题，稍后再试吧"];
    }];
}
-(void)toConfirmPageWithOrderId:(NSDictionary *)order
{
    
    OrderConfirmViewController * ov = [[OrderConfirmViewController alloc] init];
    if (self.orderListDict) {
        NSArray * h = [self.orderListDict objectForKey:[self.orderListDict allKeys][0]];
        TalkingBrowse * tk = h[0];
        ov.imageUrl = [NSURL URLWithString:tk.thumbImgUrl];
    }
    
    ov.goodsTitle = self.goodsTitle;
    ov.univalent = [NSString stringWithFormat:@"%.2f",([[order objectForKey:@"amount"] floatValue]-[[order objectForKey:@"shippingFee"] floatValue])/[[order objectForKey:@"productCount"] floatValue]];
    if ([ov.univalent floatValue]!=[self.univalent floatValue]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不好意思，商品价格发生了变化，请确认好价格再决定是否支付" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    ov.goodsNum = [order objectForKey:@"productCount"];
    ov.allPriceStr = [NSString stringWithFormat:@"%.2f",[[order objectForKey:@"amount"] floatValue]-[[order objectForKey:@"shippingFee"] floatValue]];
    float shippingfee = [[order objectForKey:@"shippingFee"] floatValue];
    if (shippingfee==0) {
        ov.yunfei = @"免运费";
    }
    else{
        ov.yunfei = [NSString stringWithFormat:@"运费:￥%@",[order objectForKey:@"shippingFee"]];
    }
    ov.orderId = [order objectForKey:@"id"];
    ov.yunfeiValue = [[order objectForKey:@"shippingFee"] floatValue];
    [self.navigationController pushViewController:ov animated:YES];
}

-(void)calPrice
{
//    TalkingBrowse * tk = [self.myShuoShuoArray objectAtIndex:self.selectedIndex];
//    NSMutableArray * array = [NSMutableArray array];
//    if ([self.listDict objectForKey:tk.theID]) {
//        array = [NSMutableArray arrayWithArray:[self.listDict objectForKey:tk.theID]];
//        [array addObject:tk];
//    }
//    else
//    {
//        [array addObject:tk];
//    }
//    [self.listDict setObject:array forKey:tk.theID];
    
    NSArray * as = [self.orderListDict allKeys];
    int cardNum = 0;
    for (int i = 0; i<as.count; i++) {
        NSArray * fg = [self.orderListDict objectForKey:as[i]];
        cardNum = cardNum+(int)fg.count;
    }
    self.allNum = cardNum;
    [self calBottomPrice];
}
-(void)calBottomPrice
{
    if ([self.delegate respondsToSelector:@selector(resetPCNum:)]) {
        [self.delegate resetPCNum:self.allNum];
    }
    self.numL.text = [NSString stringWithFormat:@"%d",(int)self.allNum];
    
    self.allPrice = [NSString stringWithFormat:@"%.2f",self.allNum*[self.univalent floatValue]];
    
    self.allPriceStr =[NSString stringWithFormat:@"共%@元",self.allPrice];
    
    NSMutableAttributedString * attributedStr2 = [[NSMutableAttributedString alloc] initWithString:self.allPriceStr];
    [attributedStr2 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:16] range: NSMakeRange(0, self.allPriceStr.length)];
    [attributedStr2 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithWhite:130/255.0f alpha:1] range: NSMakeRange(0, self.allPriceStr.length)];
    [attributedStr2 addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:24] range: NSMakeRange(1, self.allPriceStr.length-2)];
    [attributedStr2 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1] range: NSMakeRange(1, self.allPriceStr.length-2)];
    self.allPriceL.attributedText = attributedStr2;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listKeyArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ordercell = @"ordercell";
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ordercell];
    if (cell == nil) {
        cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ordercell];
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellIndex = indexPath.row;
    TalkingBrowse * tk = [self.orderListDict objectForKey:[self.listKeyArray objectAtIndex:indexPath.row]][0];
    cell.thumImageV.imageURL = [NSURL URLWithString:tk.thumbImgUrl];
    cell.titleL.text = tk.descriptionContent;
    cell.numL.text = [NSString stringWithFormat:@"%d",(int)[[self.orderListDict objectForKey:[self.listKeyArray objectAtIndex:indexPath.row]] count]];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        NSArray * array = [self.orderListDict objectForKey:[self.listKeyArray objectAtIndex:indexPath.row]];
        self.allNum = self.allNum-array.count;
        [self.orderListDict removeObjectForKey:[self.listKeyArray objectAtIndex:indexPath.row]];
        NSMutableArray * g = [NSMutableArray arrayWithArray:self.listKeyArray];
        [g removeObjectAtIndex:indexPath.row];
        self.listKeyArray = g;
        [self.listTableV deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self calBottomPrice];
        
    }
}

-(void)numChangedTo:(NSInteger)num Index:(NSInteger)index
{
//    NSLog(@"THENUM:%d,Index:%d",num,index);
    NSString * keyk = [self.listKeyArray objectAtIndex:index];
    TalkingBrowse * tk = [self.orderListDict objectForKey:keyk][0];
    NSMutableArray * d = [NSMutableArray array];
    for (int i = 0; i<num; i++) {
        [d addObject:tk];
    }
    [self.orderListDict setObject:d forKey:keyk];
    [self calPrice];
}
-(void)toConfirmPage
{
    OrderConfirmViewController * ov = [[OrderConfirmViewController alloc] init];
    [self.navigationController pushViewController:ov animated:YES];
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
