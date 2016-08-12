//
//  ConfirmDogReceivedVC.m
//  TalkingPet
//
//  Created by Tolecen on 16/8/12.
//  Copyright © 2016年 wangxr. All rights reserved.
//

#import "ConfirmDogReceivedVC.h"
#import "SVProgressHUD.h"
@implementation ConfirmDogReceivedVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
     self.title = @"确认收货";
    [self setBackButtonWithTarget:@selector(inner_Pop:)];
    self.view.backgroundColor = [UIColor colorWithR:240 g:240 b:240 alpha:1];
    
    self.topv = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    self.topv.backgroundColor = [UIColor colorWithR:255 g:188 b:167 alpha:1];
    
    UILabel * hhh = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-20, 40)];
    hhh.backgroundColor = [UIColor clearColor];
    hhh.textColor = [UIColor whiteColor];
    hhh.font = [UIFont systemFontOfSize:14];
    hhh.numberOfLines = 2;
    hhh.lineBreakMode = NSLineBreakByCharWrapping;
    hhh.text = @"上传照片提交成功后，犬舍会在24小时内确认狗狗信息。\n信息核对成功后即可开启相对应质保哦~";
    [self.topv addSubview:hhh];
    
    
    self.bottv = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
    self.bottv.backgroundColor = self.view.backgroundColor;
    
   
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - navigationBarHeight-40) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    _tableView.tableHeaderView = self.topv;
    _tableView.tableFooterView = self.bottv;
    
    UILabel * hhh2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 120, 20)];
    hhh2.backgroundColor = [UIColor clearColor];
    hhh2.textColor = [UIColor lightGrayColor];
    hhh2.font = [UIFont systemFontOfSize:14];
    hhh2.text = @"上传狗狗照片";
    [self.bottv addSubview:hhh2];
    
    
    UILabel * hhh3 = [[UILabel alloc] initWithFrame:CGRectMake(130, 10, 200, 20)];
    hhh3.backgroundColor = [UIColor clearColor];
    hhh3.textColor = [UIColor orangeColor];
    hhh3.font = [UIFont systemFontOfSize:12];
    hhh3.text = @"请按要求上传高清的狗狗相片哦~";
    [self.bottv addSubview:hhh3];
    
    float sep = (ScreenWidth-40-270)/2;
    self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn1 setFrame:CGRectMake(20, 40, 90, 90)];
    [self.btn1 setBackgroundImage:[UIImage imageNamed:@"confirmdog1"] forState:UIControlStateNormal];
    self.btn1.tag = 1;
    [self.bottv addSubview:self.btn1];
    [self.btn1 addTarget:self action:@selector(selectPic:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn2 setFrame:CGRectMake(20+90+sep, 40, 90, 90)];
    [self.btn2 setBackgroundImage:[UIImage imageNamed:@"confirmdog2"] forState:UIControlStateNormal];
    self.btn2.tag = 2;
    [self.bottv addSubview:self.btn2];
    [self.btn1 addTarget:self action:@selector(selectPic:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn3 setFrame:CGRectMake(20+90*2+sep*2, 40, 90, 90)];
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"confirmdog3"] forState:UIControlStateNormal];
    self.btn3.tag = 3;
    [self.bottv addSubview:self.btn3];
    [self.btn1 addTarget:self action:@selector(selectPic:) forControlEvents:UIControlEventTouchUpInside];


    
    UIButton * submitBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setFrame:CGRectMake(0, ScreenHeight-40-navigationBarHeight , ScreenWidth, 40)];
    [submitBtn setBackgroundColor:CommonGreenColor];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:submitBtn];
    [submitBtn addTarget:self action:@selector(submitInfo:) forControlEvents:UIControlEventTouchUpInside];
    


}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void)inner_Pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)submitInfo:(UIButton *)sender
{
    if (self.btn1.tag<10) {
        [SVProgressHUD showErrorWithStatus:@"要选一张狗狗正面照片哦"];
        return;
    }
    if (self.btn2.tag<10) {
        [SVProgressHUD showErrorWithStatus:@"要选一张狗狗侧面照片哦"];
        return;
    }
    if (self.btn3.tag<10) {
        [SVProgressHUD showErrorWithStatus:@"要选一张抱着狗狗的照片哦"];
        return;
    }

    [SVProgressHUD showWithStatus:@"提交中..."];
    NSMutableArray * array = [NSMutableArray array];
    
    for (int i = 0; i<3; i++) {
        UIImage * m;
        if (i==0) {
            m = self.btn1.currentBackgroundImage;
        }
        else if(i==1){
            m = self.btn2.currentBackgroundImage;
        }
        else
            m = self.btn3.currentBackgroundImage;
            
        [NetServer uploadImage:m Type:@"avatar" Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        } Success:^(id responseObject, NSString *fileURL) {
            
            [array addObject:fileURL];
            if ([array count]==3) {
                [NetServer confirmReceviedGoodWithGoodUrl:self.myOrder.confirmUrl paras:array success:^(id result) {
                    [SVProgressHUD dismiss];
                    if (self.back) {
                        self.back();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
                    [SVProgressHUD dismiss];
                }];
            }
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            
        }];
    }
    
    

}

-(void)selectPic:(UIButton *)sender
{
    _currentBTn = sender;
    UIActionSheet *actionSheetTemp = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"相册选择",@"拍照", nil];
    actionSheetTemp.tag = 1;
    [actionSheetTemp showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1) {
        UIImagePickerController * imagePicker;
        if (buttonIndex==1)
        {
            if (imagePicker==nil) {
                imagePicker=[[UIImagePickerController alloc]init];
                imagePicker.delegate=self;
                imagePicker.allowsEditing = YES;
            }
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:^{
                    
                }];
            }
            else {
                UIAlertView *cameraAlert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备不支持相机" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
                [cameraAlert show];
            }
        }
        else if (buttonIndex==0) {
            if (imagePicker==nil) {
                imagePicker=[[UIImagePickerController alloc]init];
                imagePicker.delegate=self;
                imagePicker.allowsEditing = YES;
            }
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                //                [self presentModalViewController:imagePicker animated:YES];
                [self presentViewController:imagePicker animated:YES completion:^{
                    
                }];
            }
            else {
                UIAlertView *libraryAlert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备不支持相册" delegate:self cancelButtonTitle:@"了解" otherButtonTitles:nil];
                [libraryAlert show];
            }
        }
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@",info);
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage * tempImg = (UIImage *)[info objectForKey:@"UIImagePickerControllerEditedImage"];
        UIImage * img = [TTImageHelper compressImageDownToPhoneScreenSize:tempImg targetSizeX:500 targetSizeY:500];
        //    _headBtn.placeholderImage = _headIMG;
        if (_currentBTn.tag<10) {
            _currentBTn.tag = _currentBTn.tag*100;
        }
        [_currentBTn setBackgroundImage:img forState:UIControlStateNormal];
    }];
    
}


#pragma mark - UITableView
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 45.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    self.footerV.backgroundColor = [UIColor whiteColor];
    
    self.orderNoL = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, ScreenWidth-40, 20)];
    self.orderNoL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
    self.orderNoL.font = [UIFont systemFontOfSize:14];
    self.orderNoL.text = [NSString stringWithFormat:@"订单编号：%@",self.myOrder.order_no];
    [self.footerV addSubview:self.orderNoL];
    
    self.orderTimeL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-130, 20, 120, 20)];
    self.orderTimeL.textAlignment = NSTextAlignmentRight;
    self.orderTimeL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
    self.orderTimeL.font = [UIFont systemFontOfSize:14];
    NSString *dingdanString = [NSString stringWithFormat:@"%@",self.myOrder.time];
    
    //    NSRange start =[dingdanString rangeOfString:@"-"];
    //    NSRange end =[dingdanString rangeOfString:@":"];
    //    NSString  *b =[dingdanString substringWithRange:NSMakeRange(start.location+1, end.location-2)];
    self.orderTimeL.text =dingdanString;
    [self.footerV addSubview:self.orderTimeL];
    [tableView addSubview:self.footerV];
    return self.footerV;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    static NSString * header = @"footer";
    OrderFooterView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header];
    if (view == nil) {
        view = [[OrderFooterView alloc] initWithReuseIdentifier:header WithButton:NO];
    }
    OrderYZList * listModel = self.myOrder;
    view.desL.text = [NSString stringWithFormat:@"共 %@ 件 合计：￥%@（含运费 ￥%@）",listModel.total_amount,listModel.total_money,listModel.shippingfee];
        return view;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myOrder.goods.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"WXRLabelsCell";
    OrderListSingleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[OrderListSingleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.goodInfo = self.myOrder.goods[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
}


@end
