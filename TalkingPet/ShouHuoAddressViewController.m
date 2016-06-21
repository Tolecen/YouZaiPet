//
//  ShouHuoAddressViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/4/7.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "ShouHuoAddressViewController.h"

@interface ShouHuoAddressViewController ()

@end

@implementation ShouHuoAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArray = [NSMutableArray arrayWithObjects:@"收货姓名:",@"手机号码:",@"详细地址:",@"邮政编码:", nil];
    self.heightArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:50],[NSNumber numberWithFloat:50],[NSNumber numberWithFloat:50],[NSNumber numberWithFloat:50], nil];
    self.placeholderArray = [NSArray arrayWithObjects:@"填写您的名字",@"填写手机号码",@"省 市 区 街道 小区 门牌",@"填写邮政编码", nil];
    self.view.backgroundColor = [UIColor whiteColor];
     [self setBackButtonWithTarget:@selector(back)];
    [self setRightButtonWithName:@"保存" BackgroundImg:nil Target:@selector(saveAddress)];
    
    self.infoTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.infoTableV.delegate = self;
    self.infoTableV.dataSource = self;
//    self.infoTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.infoTableV];

    [self getAddress];
    // Do any additional setup after loading the view.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (int i = 0; i<4; i++) {
        ShouHuoInfoTableViewCell *cell = (ShouHuoInfoTableViewCell *)[_infoTableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell.textView resignFirstResponder];
    }
}
-(void)getAddress
{
    [SVProgressHUD showWithStatus:@"获取地址中..."];
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"shippingAddress" forKey:@"command"];
    [mDict setObject:@"one" forKey:@"options"];
//    [mDict setObject:@"9" forKey:@"pageSize"];
    [mDict setObject:[UserServe sharedUserServe].currentPet.petID forKey:@"petId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ShouHuoInfoTableViewCell *cell1 = (ShouHuoInfoTableViewCell *)[_infoTableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell1.textView.text = [[[responseObject objectForKey:@"value"] objectForKey:@"name"] isEqualToString:@" "]?@"":[[responseObject objectForKey:@"value"] objectForKey:@"name"];
        if (!cell1.placeHolderL.hidden&&cell1.textView.text.length>0) {
            cell1.placeHolderL.hidden = YES;
        }
        if (cell1.placeHolderL.hidden&&cell1.textView.text.length<=0) {
            cell1.placeHolderL.hidden = NO;
        }
        
        ShouHuoInfoTableViewCell *cell2 = (ShouHuoInfoTableViewCell *)[_infoTableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell2.textView.text = [[[responseObject objectForKey:@"value"] objectForKey:@"mobile"] isEqualToString:@" "]?@"":[[responseObject objectForKey:@"value"] objectForKey:@"mobile"];
        if (!cell2.placeHolderL.hidden&&cell2.textView.text.length>0) {
            cell2.placeHolderL.hidden = YES;
        }
        if (cell2.placeHolderL.hidden&&cell2.textView.text.length<=0) {
            cell2.placeHolderL.hidden = NO;
        }
        
        ShouHuoInfoTableViewCell *cell3 = (ShouHuoInfoTableViewCell *)[_infoTableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        cell3.textView.text = [[[responseObject objectForKey:@"value"] objectForKey:@"address"] isEqualToString:@" "]?@"":[[responseObject objectForKey:@"value"] objectForKey:@"address"];
        if (!cell3.placeHolderL.hidden&&cell3.textView.text.length>0) {
            cell3.placeHolderL.hidden = YES;
        }
        if (cell3.placeHolderL.hidden&&cell3.textView.text.length<=0) {
            cell3.placeHolderL.hidden = NO;
        }
        
        ShouHuoInfoTableViewCell *cell4 = (ShouHuoInfoTableViewCell *)[_infoTableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        cell4.textView.text = [[[responseObject objectForKey:@"value"] objectForKey:@"zipcode"] isEqualToString:@" "]?@"":[[responseObject objectForKey:@"value"] objectForKey:@"zipcode"];
        if (!cell4.placeHolderL.hidden&&cell4.textView.text.length>0) {
            cell4.placeHolderL.hidden = YES;
        }
        if (cell4.placeHolderL.hidden&&cell4.textView.text.length<=0) {
            cell4.placeHolderL.hidden = NO;
        }
        
        if ([[[responseObject objectForKey:@"value"] objectForKey:@"name"] isEqualToString:@" "]||[[[responseObject objectForKey:@"value"] objectForKey:@"name"] isEqualToString:@""]) {
            self.title = @"新增收货地址";
        }
        else
            self.title = @"编辑收货地址";
        
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取失败"];
    }];
}
-(void)saveAddress
{

    ShouHuoInfoTableViewCell *cell1 = (ShouHuoInfoTableViewCell *)[_infoTableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    ShouHuoInfoTableViewCell *cell2 = (ShouHuoInfoTableViewCell *)[_infoTableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    ShouHuoInfoTableViewCell *cell3 = (ShouHuoInfoTableViewCell *)[_infoTableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    ShouHuoInfoTableViewCell *cell4 = (ShouHuoInfoTableViewCell *)[_infoTableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];

   
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"shippingAddress" forKey:@"command"];
    [mDict setObject:@"save" forKey:@"options"];
    if (!cell1.textView.text||[cell1.textView.text isEqualToString:@""]||[cell1.textView.text isEqualToString:@" "]) {
        [SVProgressHUD showErrorWithStatus:@"请输入名字"];
        return;
    }
    else
        [mDict setObject:cell1.textView.text forKey:@"name"];
    
    if (!cell2.textView.text||[cell2.textView.text isEqualToString:@""]||[cell2.textView.text isEqualToString:@" "]) {
        [SVProgressHUD showErrorWithStatus:@"请输入电话"];
        return;
    }
    else
        [mDict setObject:cell2.textView.text forKey:@"mobile"];
    
    if (!cell3.textView.text||[cell3.textView.text isEqualToString:@""]||[cell3.textView.text isEqualToString:@" "]) {
        [SVProgressHUD showErrorWithStatus:@"请输入地址"];
        return;
    }
    else
        [mDict setObject:cell3.textView.text forKey:@"address"];
    
    
    if (!cell4.textView.text||[cell4.textView.text isEqualToString:@""]||[cell4.textView.text isEqualToString:@" "]) {
        [SVProgressHUD showErrorWithStatus:@"请输入邮编"];
        return;
    }
    else
        [mDict setObject:cell4.textView.text forKey:@"zipcode"];
    //    [mDict setObject:@"9" forKey:@"pageSize"];
    [mDict setObject:[UserServe sharedUserServe].currentPet.petID forKey:@"petId"];
     [SVProgressHUD showWithStatus:@"保存地址中..."];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"提交失败"];
    }];
}
-(void)heightChanged:(CGFloat)height text:(NSString *)text cellIndex:(int)cellIndex
{
    [self.heightArray replaceObjectAtIndex:cellIndex withObject:[NSNumber numberWithFloat:(height+15)]];
//    fromHeightChanged = YES;
//
//    [self.titleArray replaceObjectAtIndex:cellIndex withObject:text];
    [self.infoTableV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    ShouHuoInfoTableViewCell *cell = (ShouHuoInfoTableViewCell *)[_infoTableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cellIndex inSection:0]];
////    NSLog(@"%@",cell.textView.text);
    [cell.textView becomeFirstResponder];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.heightArray objectAtIndex:indexPath.row] floatValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"shouhuoinfocell";
    ShouHuoInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[ShouHuoInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellIndex = (int)indexPath.row;
    cell.titleL.text = self.titleArray[indexPath.row];
    cell.placeHolderL.text = self.placeholderArray[indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            cell.textView.keyboardType = UIKeyboardTypeDefault;
        }
            break;
        case 1:
        {
            cell.textView.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case 2:
        {
            cell.textView.keyboardType = UIKeyboardTypeDefault;
        }
            break;
        case 3:
        {
            cell.textView.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
            
        default:
            break;
    }
//    cell.textView.placeholder = self.placeholderArray[indexPath.row];
    return cell;
}
- (void)back
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
