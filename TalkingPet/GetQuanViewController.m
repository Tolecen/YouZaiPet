//
//  GetQuanViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/7/23.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "GetQuanViewController.h"
#import "QuanCell.h"
#import "SVProgressHUD.h"
@implementation GetQuanViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0f green:239/255.0f blue:178/255.0f alpha:1];
    self.title = @"领取优惠券";
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    
    UIImageView * a = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*0.88)];
    [a setImage:[UIImage imageNamed:@"getquanheader"]];
    

    UILabel * o = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, ScreenWidth, 20)];
    o.textColor = [UIColor whiteColor];
    o.backgroundColor = [UIColor clearColor];
    o.textAlignment = NSTextAlignmentCenter;
    o.text = @"你太棒了，都滑到这了！";
    [self.view addSubview:o];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight) style:UITableViewStylePlain];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = [UIColor colorWithRed:255/255.0f green:239/255.0f blue:178/255.0f alpha:1];
    self.tableview.backgroundView = nil;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.tableview.tableHeaderView = a;
//    self.tableview.tableFooterView = b;
    
    [self.view addSubview:self.tableview];
    
    [self getQuanlist];
}
-(void)getQuanlist
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"coupon" forKey:@"command"];
    [mDict setObject:@"activity" forKey:@"options"];
    [mDict setObject:self.activityId forKey:@"id"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.quanArray = [[responseObject objectForKey:@"value"] objectForKey:@"settings"];
        [self.tableview reloadData];
        [self addfooterWithDes:[[responseObject objectForKey:@"value"] objectForKey:@"desc"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)addfooterWithDes:(NSString *)des
{
    UIImageView * b = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*0.5)];
    [b setImage:[UIImage imageNamed:@"quanwei"]];
    
    UILabel * t = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 20)];
    t.textColor = [UIColor orangeColor];
    t.font = [UIFont systemFontOfSize:16];
    t.textAlignment = NSTextAlignmentCenter;
    [b addSubview:t];
    t.text = @"------------- 使用规则 ---------------";
    
    UILabel * n = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, ScreenWidth-20, b.frame.size.height-40-5)];
    n.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
    n.lineBreakMode = NSLineBreakByCharWrapping;
    n.numberOfLines = 0;
    n.font = [UIFont systemFontOfSize:14];
    //    n.textAlignment = NSTextAlignmentCenter;
    [b addSubview:n];
    n.text = des;
    CGSize u = [n.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenWidth-20, b.frame.size.height-40-5)];
    [n setFrame:CGRectMake(10, 40, ScreenWidth-20, u.height)];
    
    self.tableview.tableFooterView = b;
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
    if ([[[self.quanArray objectAtIndex:indexPath.row] objectForKey:@"isTaken"] isEqualToString:@"true"]||[[self.quanArray objectAtIndex:indexPath.row][@"couponLimitCount"] integerValue]==[[self.quanArray objectAtIndex:indexPath.row][@"couponSendCount"] integerValue]) {
        return;
    }
    [self getQuanById:[[self.quanArray objectAtIndex:indexPath.row] objectForKey:@"id"] index:indexPath.row];
}
-(void)getQuanById:(NSString *)quanId index:(NSInteger)index
{
    [SVProgressHUD showWithStatus:@"领取中..."];
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"coupon" forKey:@"command"];
    [mDict setObject:@"getByActivity" forKey:@"options"];
    [mDict setObject:quanId forKey:@"id"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:self.quanArray[index]];
        [dict setObject:@"true" forKey:@"isTaken"];
        [self.quanArray replaceObjectAtIndex:index withObject:dict];
        
        [self.tableview reloadData];
        [SVProgressHUD showSuccessWithStatus:@"领取成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"领取失败"];
    }];
}
-(void)backBtnDo:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
