//
//  QuanViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/7/20.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "QuanViewController.h"
#import "Common.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "QuanCell.h"
#import "BlankPageView.h"
@interface QuanViewController ()
{
    BlankPageView * blankPage;
}
@end

@implementation QuanViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.selectedId = -1;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.selectedId = -1;
    self.quanArray = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    self.title = @"优惠券";
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    
    UIView *g = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
    g.backgroundColor = [UIColor clearColor];
    [self.view addSubview:g];
    
    UIView * s = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 70)];
    s.backgroundColor = [UIColor whiteColor];
    [g addSubview:s];
    
    t = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, ScreenWidth-10-10-80-10, 30)];
    t.backgroundColor = [UIColor clearColor];
    t.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    t.font = [UIFont systemFontOfSize:16];
    t.layer.cornerRadius = 5;
    t.placeholder = @"输入兑换码";
    t.layer.borderColor = [[UIColor colorWithRed:133/255.0f green:203/255.0f blue:252/255.0f alpha:1] CGColor];
    t.layer.borderWidth = 1;
    t.layer.masksToBounds = YES;
    [s addSubview:t];
    t.keyboardType = UIKeyboardTypeAlphabet;
    
    CGRect frame = [t frame];
    frame.size.width = 7.0f;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    t.leftViewMode = UITextFieldViewModeAlways;
    t.leftView = leftview;
    
    UIButton * b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = CGRectMake(ScreenWidth-10-80, 20, 80, 30);
    b.backgroundColor = [UIColor colorWithRed:133/255.0f green:203/255.0f blue:252/255.0f alpha:1];
    b.layer.cornerRadius = 5;
    b.layer.masksToBounds = YES;
    [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [b setTitle:@"兑换" forState:UIControlStateNormal];
    [b.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [s addSubview:b];
    [b addTarget:self action:@selector(exchangeCoupon) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * tl = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 120, 20)];
    tl.backgroundColor = [UIColor clearColor];
    tl.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    tl.font = [UIFont systemFontOfSize:14];
    [g addSubview:tl];
    tl.text = @"我的优惠券";
    
    
//    UILabel * dd = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 120, 20)];
//    dd.backgroundColor = [UIColor clearColor];
//    dd.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
//    dd.font = [UIFont systemFontOfSize:14];
//    [g addSubview:dd];
//    dd.text = @"暂时没有可用优惠券";
//    dd.hidden = YES;
   
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight) style:UITableViewStylePlain];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.tableHeaderView = g;
    
    [self.view addSubview:self.tableview];
    
    
    if (self.pageType==1) {
        self.tableview.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
        UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureBtn setFrame:CGRectMake(0, self.view.frame.size.height-navigationBarHeight-40, ScreenWidth, 40)];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureBtn setBackgroundColor:[UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1]];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.view addSubview:sureBtn];
        [sureBtn addTarget:self action:@selector(confirmBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.tableview addHeaderWithTarget:self action:@selector(tableViewHeaderRereshing:)];
    [self.tableview addFooterWithTarget:self action:@selector(tableViewFooterRereshing:)];
    [self getAvailableList];
    // Do any additional setup after loading the view.
}
-(void)tableViewHeaderRereshing:(UITableView *)tableview
{
    [self getAvailableList];
}
-(void)tableViewFooterRereshing:(UITableView *)tableview
{
    [self getNextPage];
}
-(void)endRefresh
{
    [self.tableview headerEndRefreshing];
    [self.tableview footerEndRefreshing];
    if (self.selectedId!=-1&&self.pageType==1) {
        [self selectTheRow:self.selectedId];
    }
}
-(void)getAvailableList
{
    self.startId = @"";
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"coupon" forKey:@"command"];
    [mDict setObject:self.pageType==1?@"orderAvailableList":@"availableList" forKey:@"options"];
    if (self.pageType==1) {
        [mDict setObject:self.orderId forKey:@"orderId"];
    }
    [mDict setObject:@"20" forKey:@"pageSize"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.quanArray = [responseObject objectForKey:@"value"];
        self.startId = [[[responseObject objectForKey:@"value"] lastObject] objectForKey:@"id"];
        [self.tableview reloadData];
        [self endRefresh];
        if (!_quanArray.count) {
            if (!blankPage) {
                blankPage = [[BlankPageView alloc] initWithImage];
                [blankPage showWithView:self.view image:[UIImage imageNamed:@"quan_without"] buttonImage:nil action:nil];
            }
        }
        else if(blankPage){
            [blankPage removeFromSuperview];
            blankPage = nil;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
    }];
}
-(void)getNextPage
{
    if (self.quanArray.count<=0) {
        [self endRefresh];
        return;
    }
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"coupon" forKey:@"command"];
    [mDict setObject:self.pageType==1?@"orderAvailableList":@"availableList" forKey:@"options"];
    if (self.pageType==1) {
        [mDict setObject:self.orderId forKey:@"orderId"];
    }
    [mDict setObject:self.startId forKey:@"startId"];
    [mDict setObject:@"20" forKey:@"pageSize"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.quanArray addObjectsFromArray:[responseObject objectForKey:@"value"]];
        self.startId = [[[responseObject objectForKey:@"value"] lastObject] objectForKey:@"id"];
        [self.tableview reloadData];
        [self endRefresh];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefresh];
    }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [t resignFirstResponder];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.quanArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"quanCell";
    QuanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[QuanCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
//        cell.delegate = self;
    }
    cell.quanDict = self.quanArray[indexPath.row];
    cell.cellIndex = indexPath.row;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.backgroundColor = [UIColor redColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.pageType==0) {
        return;
    }
    [self selectTheRow:indexPath.row];
}
-(void)selectTheRow:(NSInteger)row
{
    for (int i = 0;i<self.quanArray.count; i++) {
        //        NSLog(@"1111%d",i);
        NSIndexPath * indexP = [NSIndexPath indexPathForRow:i inSection:0];
        QuanCell * cell = (QuanCell *)[self.tableview cellForRowAtIndexPath:indexP];
        cell.selectedIndex = row;
        if (indexP.row==row) {
            cell.isSelected = YES;
            if (cell.checmarkView.hidden) {
                cell.checmarkView.hidden = NO;
                self.selectedId = (int)row;
            }
            else{
                cell.checmarkView.hidden = YES;
                self.selectedId = -1;
            }
            
        }
        else{
            cell.isSelected = NO;
//            self.selectedId = -1;
            cell.checmarkView.hidden = YES;
        }
    }

}
-(void)confirmBtn
{
    if (self.selectedId==-1) {
        if ([self.delegate respondsToSelector:@selector(getQuanId:Selected:)]) {
            [self.delegate getQuanId:nil Selected:-1];
            [self.navigationController popViewControllerAnimated:YES];
        }
        return;
    }
    if ([self.delegate respondsToSelector:@selector(getQuanId:Selected:)]) {
        [self.delegate getQuanId:self.quanArray[self.selectedId] Selected:self.selectedId];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)exchangeCoupon
{
    if (!t.text||t.text.length<6) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的兑换码"];
        return;
    }
    [t resignFirstResponder];
    [SVProgressHUD showWithStatus:@"请稍后..."];
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"coupon" forKey:@"command"];
    [mDict setObject:@"getByCode" forKey:@"options"];
    [mDict setObject:t.text forKey:@"code"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:@"兑换成功"];
        [self getAvailableList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"兑换失败"];
    }];
}
-(void)backBtnDo:(id)sender
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
