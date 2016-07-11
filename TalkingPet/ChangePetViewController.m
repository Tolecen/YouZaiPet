//
//  ChangePetViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/2/10.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "ChangePetViewController.h"
#import "EGOImageView.h"
@interface ChangePetcell : UITableViewCell
@property (nonatomic,strong) EGOImageView * headV;
@property (nonatomic,strong) UILabel * nameL;
@end
@implementation ChangePetcell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headV = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
//        view.image = [UIImage imageNamed:@"add"];
        [self.contentView addSubview:self.headV];
        self.headV.layer.cornerRadius = 25;
        self.headV.layer.masksToBounds = YES;
        self.headV.placeholderImage = [UIImage imageNamed:@"placeholderHead"];
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(70, 25, self.frame.size.width-70-50, 20)];
//        label.text = @"添加宠物";
        self.nameL.font = [UIFont systemFontOfSize:15];
        self.nameL.textColor = [UIColor colorWithWhite:120/255.0 alpha:1];
        [self.contentView addSubview:self.nameL];
        
        UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(10, 69, ScreenWidth-10, 1)];
        [lineV setBackgroundColor:[UIColor colorWithWhite:230/255.0f alpha:1]];
        [self.contentView addSubview:lineV];
        
    }
    return self;
}
@end
@interface ChangePetViewController ()

@end

@implementation ChangePetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
   
    
//    self.dataArray = [NSMutableArray arrayWithArray:[UserServe sharedUserServe].petArr];
    int y = 0;
    for (int i = 0; i<self.dataArray.count; i++) {
        Pet *p = [self.dataArray objectAtIndex:i];
        if ([p.petID isEqualToString:[UserServe sharedUserServe].userID]) {
            y = 1;
            currentInddex = i;
        }
    }
    if (y==0) {
        [self.dataArray insertObject:[UserServe sharedUserServe].account atIndex:0];
    }
    
    
    self.tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - navigationBarHeight);
    _tableView.backgroundView = nil;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    _tableView.rowHeight = 70;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    if (self.dataArray.count>=3) {
        
    }
    else
    {
         [self setRightButtonWithName:@"添加宠物" BackgroundImg:nil Target:@selector(addBtnClicked)];
    }
    

    
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"addpetcelll";
    ChangePetcell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ChangePetcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Pet * pet = self.dataArray[indexPath.row];
    [cell.headV setImageURL:[NSURL URLWithString:pet.headImgURL]];
    cell.nameL.text = pet.nickname;
    
    if (indexPath.row==currentInddex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self actionPetSynchronousWithIndex:indexPath.row];
}
- (void)actionPetSynchronousWithIndex:(NSInteger)index
{
    [SVProgressHUD showWithStatus:@"切换中..."];
    Pet * p = [self.dataArray objectAtIndex:index];
    NSMutableDictionary * regDict = [NetServer commonDict];
    [regDict setObject:@"pet" forKey:@"command"];
    [regDict setObject:@"active" forKey:@"options"];
    [regDict setObject:p.petID forKey:@"id"];
    [NetServer requestWithParameters:regDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"已切换"];
        currentInddex = index;
        [self.tableView reloadData];
        
        
        [UserServe sharedUserServe].account = [self.dataArray objectAtIndex:index];
        NSLog(@"currentPet:%@",[UserServe sharedUserServe].userID);
        NSMutableArray * as = [NSMutableArray array];
        for (int i = 0; i<self.dataArray.count; i++) {
            if (i!=index) {
                [as addObject:self.dataArray[i]];
            }
        }
//        [UserServe sharedUserServe].petArr = as;
//        [DatabaseServe activatePet:[UserServe sharedUserServe].account WithUsername:[UserServe sharedUserServe].userName];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRLoginSucceed" object:self userInfo:nil];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"不好意思，切换失败哦，稍后再试吧，如果一直不行，请重新登录"];
    }];
}
-(void)addBtnClicked
{
    self.addNewPetVC = [[NewUserViewController alloc] init];
    _addNewPetVC.delegate = self;
    [self.navigationController pushViewController:_addNewPetVC animated:YES];
}

- (NSString *)titleWithNewUserViewController:(NewUserViewController*)controller
{
    if (controller == _addNewPetVC) {
        return @"添加宠物";
    }
    return @"编辑资料";
}
- (UIButton *)finishButtonWithWithNewUserViewController:(NewUserViewController*)controller
{
    UIButton * registerB = [UIButton buttonWithType:UIButtonTypeCustom];
    registerB.frame = CGRectMake(0.0, 0.0, 65, 32);
    if (controller == _addNewPetVC) {
        [registerB setTitle:@"添加" forState:UIControlStateNormal];
        [registerB addTarget:self action:@selector(addNewPet) forControlEvents:UIControlEventTouchUpInside];
    }else
    {
        [registerB setTitle:@"保存" forState:UIControlStateNormal];
        [registerB addTarget:self action:@selector(saveCurrentPet) forControlEvents:UIControlEventTouchUpInside];
    }
    return registerB;
}
- (Pet*)petWithWithNewUserViewController:(NewUserViewController*)controller
{
    if (controller == _editCurrentPetVC) {
        return [UserServe sharedUserServe].account;
    }
    return nil;
}


- (void)addNewPet
{
    if ([_addNewPetVC.nameTF.text CutSpacing].length<2||[_addNewPetVC.nameTF.text CutSpacing].length>15) {
        [SVProgressHUD showErrorWithStatus:@"昵称要填哦，2-15个字"];
        return;
    }
    if (_addNewPetVC.genderTL.textColor==[UIColor lightGrayColor]) {
        [SVProgressHUD showErrorWithStatus:@"性别要选呀"];
        return;
    }
    if (_addNewPetVC.birthTL.textColor==[UIColor lightGrayColor]) {
        [SVProgressHUD showErrorWithStatus:@"生日要选呀"];
        return;
    }
    if (_addNewPetVC.breedTL.textColor==[UIColor lightGrayColor]) {
        [SVProgressHUD showErrorWithStatus:@"你的种族得让人家知道呀"];
        return;
    }
    if (_addNewPetVC.regionTL.textColor==[UIColor lightGrayColor]) {
        [SVProgressHUD showErrorWithStatus:@"填一下你在哪吧"];
        return;
    }
    if (_addNewPetVC.headIMG) {
        [SVProgressHUD showWithStatus:@"设置头像..."];
        [NetServer uploadImage:_addNewPetVC.headIMG Type:@"avatar" Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        } Success:^(id responseObject, NSString *fileURL) {
            _addNewPetVC.avatarUrl = fileURL;
            [SVProgressHUD dismiss];
            [self saveEditNewPet];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [_addNewPetVC showAlertWithMessage:@"头像上传失败，请稍后重试"];
        }];
    }
    else{
        [self saveEditNewPet];
    }
}
- (void)saveCurrentPet
{
    if ([_editCurrentPetVC.nameTF.text CutSpacing].length<2||[_editCurrentPetVC.nameTF.text CutSpacing].length>15) {
        [SVProgressHUD showErrorWithStatus:@"昵称要填哦，2-15个字"];
        return;
    }
    if (_editCurrentPetVC.headIMG) {
        [SVProgressHUD showWithStatus:@"设置头像..."];
        [NetServer uploadImage:_editCurrentPetVC.headIMG Type:@"avatar" Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            
        } Success:^(id responseObject, NSString *fileURL) {
            _editCurrentPetVC.avatarUrl = fileURL;
            [SVProgressHUD dismiss];
            [self saveEditCurrentPet];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [_editCurrentPetVC showAlertWithMessage:@"头像上传失败，请稍后重试"];
        }];
    }
    else{
        [self saveEditCurrentPet];
    }
}
- (void)saveEditCurrentPet
{
    [SVProgressHUD showWithStatus:@"设置个人资料..."];
    NSMutableDictionary * regDict = [NetServer commonDict];
    [regDict setObject:@"pet" forKey:@"command"];
    [regDict setObject:@"update" forKey:@"options"];
    [regDict setObject:[UserServe sharedUserServe].userID forKey:@"id"];
    [regDict setObject:[UserServe sharedUserServe].userID forKey:@"userId"];
    [regDict setObject:[_editCurrentPetVC.nameTF.text CutSpacing] forKey:@"nickName"];
    [regDict setObject:_editCurrentPetVC.avatarUrl forKey:@"headPortrait"];
    [regDict setObject:_editCurrentPetVC.genderCode forKey:@"gender"];
    [regDict setObject:_editCurrentPetVC.breedCode forKey:@"type"];
    [regDict setObject:[NSString stringWithFormat:@"%.0f",_editCurrentPetVC.selectedBirthday*1000] forKey:@"birthday"];
    [regDict setObject:_editCurrentPetVC.regionTL.text forKey:@"address"];
    [NetServer requestWithParameters:regDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UserServe sharedUserServe].account = ({
            Pet * pet = [UserServe sharedUserServe].account;
            pet.nickname = [_editCurrentPetVC.nameTF.text CutSpacing];
            pet.headImgURL = _editCurrentPetVC.avatarUrl;
            pet.gender = _editCurrentPetVC.genderCode;
            pet.breed = _editCurrentPetVC.breedCode;
            pet.region = _editCurrentPetVC.regionTL.text;
            pet.birthday = [NSDate dateWithTimeIntervalSince1970:_editCurrentPetVC.selectedBirthday];
            pet;
        });
        [DatabaseServe activatePet:[UserServe sharedUserServe].account WithUsername:[UserServe sharedUserServe].userName];
        
        [SVProgressHUD dismiss];
//        [self loadViewContent];
        [_editCurrentPetVC back];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"register failed info:%@",error);
        [SVProgressHUD dismiss];
        [_editCurrentPetVC showAlertWithMessage:error.domain];
    }];
}
- (void)saveEditNewPet
{
    /*
    [SVProgressHUD showWithStatus:@"设置个人资料..."];
    NSMutableDictionary * regDict = [NetServer commonDict];
    [regDict setObject:@"pet" forKey:@"command"];
    [regDict setObject:@"create" forKey:@"options"];
    [regDict setObject:[UserServe sharedUserServe].userID forKey:@"userId"];
    [regDict setObject:[_addNewPetVC.nameTF.text CutSpacing] forKey:@"nickName"];
    [regDict setObject:_addNewPetVC.avatarUrl forKey:@"headPortrait"];
    [regDict setObject:_addNewPetVC.genderCode forKey:@"gender"];
    [regDict setObject:_addNewPetVC.breedCode forKey:@"type"];
    [regDict setObject:[NSString stringWithFormat:@"%.0f",_addNewPetVC.selectedBirthday*1000] forKey:@"birthday"];
    [regDict setObject:_addNewPetVC.regionTL.text forKey:@"address"];
    [NetServer requestWithParameters:regDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * petDic = responseObject[@"value"];
        Pet * pet = [[Pet alloc] init];
        pet.petID = petDic[@"id"];
        pet.nickname = petDic[@"nickName"];
        pet.headImgURL = petDic[@"headPortrait"];
        pet.gender = petDic[@"gender"];
        pet.breed = petDic[@"type"];
        pet.region = petDic[@"address"];
        pet.birthday = [NSDate dateWithTimeIntervalSince1970:[petDic[@"birthday"] doubleValue]/1000];
        pet.fansNo = @"0";
        pet.attentionNo = @"0";
        pet.issue = @"0";
        pet.relay = @"0";
        pet.comment = @"0";
        pet.favour = @"0";
        pet.grade = [petDic[@"grade"] stringByReplacingOccurrencesOfString:@"DJ" withString:@""];;
        pet.score = petDic[@"score"];
        pet.coin = petDic[@"coin"];
        pet.ifDaren = [petDic[@"star"] isEqualToString:@"1"]?YES:NO;
        [UserServe sharedUserServe].petArr = [NSMutableArray arrayWithArray:[UserServe sharedUserServe].petArr];
        [[UserServe sharedUserServe].petArr addObject:pet];
        [DatabaseServe savePet:pet WithUsername:[UserServe sharedUserServe].userName];
        [SVProgressHUD dismiss];
//        [self loadViewContent];
        [_addNewPetVC back];
        self.dataArray = [UserServe sharedUserServe].petArr;
        [self.dataArray insertObject:[UserServe sharedUserServe].account atIndex:0];
        currentInddex = 0;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"register failed info:%@",error);
        [SVProgressHUD dismiss];
        [_addNewPetVC showAlertWithMessage:error.domain];
    }];
     */
}
//-()
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
