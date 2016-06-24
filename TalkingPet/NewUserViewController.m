//
//  NewUserViewController.m
//  TalkingPet
//
//  Created by wangxr on 14-7-16.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "NewUserViewController.h"
#import "DatabaseServe.h"
#import "Pet.h"
#import "EGOImageButton.h"
#import "RootViewController.h"
#import "AddressManageViewController.h"

@interface NewUserViewController ()

@end

@implementation NewUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        self.genderArray = [NSArray arrayWithObjects:@"男孩",@"女孩",@"保密", nil];
        NSString *path =[[NSString alloc]initWithString:[[NSBundle mainBundle]pathForResource:@"city"ofType:@"txt"]];
        NSData* data = [[NSData alloc]initWithContentsOfFile:path];
        self.provinceArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.cityArray = [_provinceArray[0] objectForKey:@"city"];
        self.genderCode = @"0";
        self.userPlatform = @"0";
        self.avatarUrl = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.delegate) {
        self.title = [_delegate titleWithNewUserViewController:self];
    }else
    {
        self.title = @"完善信息";
    }
    if (self.fromUserCenter) {
        self.titleArray = [NSArray arrayWithObjects:@"昵称",@"性别",@"生日",@"品种",@"地区",@"收货地址", nil];
    }
    else
        self.titleArray = [NSArray arrayWithObjects:@"昵称",@"性别",@"生日",@"品种",@"地区", nil];
    // Do any additional setup after loading the view.
    [self setBackButtonWithTarget:@selector(back)];
    

    
    if (self.delegate) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[_delegate finishButtonWithWithNewUserViewController:self]];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:({
            UIButton * registerB = [UIButton buttonWithType:UIButtonTypeCustom];
            registerB.frame = CGRectMake(0.0, 0.0, 65, 32);
            [registerB setTitle:@"注册" forState:UIControlStateNormal];
            [registerB addTarget:self action:@selector(registerNewUser) forControlEvents:UIControlEventTouchUpInside];
            registerB;
        })];
    }
//    UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width - 10, self.view.frame.size.height - 10 - navigationBarHeight)];
////    imageV.image = [UIImage imageNamed:@"publishBg"];
//    [imageV setBackgroundColor:[UIColor clearColor]];
//    [self.view addSubview:imageV];
//    imageV.userInteractionEnabled = YES;
    
    self.bgV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - navigationBarHeight)];
    [_bgV setBackgroundColor:[UIColor clearColor]];
    [_bgV setContentSize:CGSizeMake(310, self.view.frame.size.height - navigationBarHeight)];
    _bgV.scrollEnabled = YES;
    _bgV.delegate = self;
    [self.view addSubview:_bgV];
    
    UIImageView * bgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, ScreenWidth>320?-30:0,  self.view.frame.size.width, self.view.frame.size.width*0.65)];
    [bgV setImage:[UIImage imageNamed:@"otherUsercenter_topbg"]];
    [self.bgV addSubview:bgV];
    
    if (!self.delegate) {
        UILabel * iL = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 20)];
        [iL setBackgroundColor:[UIColor clearColor]];
        [iL setTextColor:[UIColor grayColor]];
        [iL setTextAlignment:NSTextAlignmentCenter];
        [iL setText:@"完善一下宠物的信息吧"];
        [_bgV addSubview:iL];
    }
    
    self.headBtn = [[EGOImageButton alloc]init];
    [self.headBtn setBackgroundImage:[UIImage imageNamed:@"xuanzetouxiang"] forState:UIControlStateNormal];
    [_headBtn setFrame:CGRectMake(_bgV.center.x-62.5, 60, 125, 125)];
    _headBtn.layer.cornerRadius = 62.5;
    _headBtn.layer.masksToBounds = YES;
    _headBtn.layer.borderWidth = 5;
    _headBtn.layer.borderColor = [[UIColor colorWithWhite:240/255.0f alpha:1] CGColor];
    [_bgV addSubview:_headBtn];
    [_headBtn addTarget:self action:@selector(addPicBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
//    UIImageView * headMask = [[UIImageView alloc] initWithFrame:_headBtn.frame];
//    [headMask setImage:[UIImage imageNamed:@"selectHeadMask"]];
//    [_bgV addSubview:headMask];
    
    self.infoTableV = [[UITableView alloc] initWithFrame:CGRectMake(5, 235, ScreenWidth-10, self.fromUserCenter?270:235) style:UITableViewStylePlain];
    _infoTableV.delegate = self;
    _infoTableV.dataSource = self;
    _infoTableV.backgroundView = nil;
    _infoTableV.backgroundColor = [UIColor whiteColor];
    _infoTableV.scrollEnabled = NO;
    _infoTableV.rowHeight = 45;
    _infoTableV.showsVerticalScrollIndicator = NO;
    [_bgV addSubview:_infoTableV];

    [_bgV setContentSize:CGSizeMake(ScreenWidth-10, (self.fromUserCenter?290:235)+225)];
    
    self.pickerBGView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height, ScreenWidth, 244)];
    self.pickerBGView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
//    self.pickerBGView.alpha = 0.7;
    [self.view addSubview:self.pickerBGView];
    
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    toolbar.tintColor = [UIColor blackColor];
    UIBarButtonItem*rb = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(didSelected)];
    rb.tintColor = [UIColor blackColor];
    toolbar.items = @[rb];
    [self.pickerBGView addSubview:toolbar];
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, 0, 0)];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    _pickerView.showsSelectionIndicator = YES;
    [self.pickerBGView addSubview:_pickerView];
    self.pickerView.hidden = YES;
    
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, 200)];
    _datePicker.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
    _datePicker.locale = locale;
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    [self.pickerBGView addSubview:_datePicker];
    _datePicker.hidden = YES;
    _datePicker.maximumDate = [NSDate date];
    
    self.petCategory = [[PetCategoryParser alloc] init];
    self.petCategoryArray = [self.petCategory getParentCategorys];
//
    self.nameTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 7.5, ScreenWidth-120, 30)];
    _nameTF.delegate = self;
    _nameTF.backgroundColor = [UIColor clearColor];
    _nameTF.placeholder = @"输入宠物昵称，2-15个字";
    _nameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.genderTL = [[UILabel alloc] initWithFrame:CGRectMake(0, 12.5, 140, 20)];
    [_genderTL setText:@"选择宠物性别"];
    [_genderTL setTextColor:[UIColor lightGrayColor]];
    self.birthTL = [[UILabel alloc] initWithFrame:CGRectMake(0, 12.5, 140, 20)];
    [_birthTL setText:@"选择宠物生日"];
    [_birthTL setTextColor:[UIColor lightGrayColor]];
    self.breedTL = [[UILabel alloc] initWithFrame:CGRectMake(0, 12.5, 140, 20)];
    [_breedTL setText:@"选择宠物品种"];
    [_breedTL setTextColor:[UIColor lightGrayColor]];
    self.regionTL = [[UILabel alloc] initWithFrame:CGRectMake(0, 12.5, 80, 20)];
    [_regionTL setText:@"选择地区"];
    [_regionTL setTextColor:[UIColor lightGrayColor]];
//
    if (self.delegate&&[_delegate respondsToSelector:@selector(petWithWithNewUserViewController:)]) {
        Pet * pet = [_delegate petWithWithNewUserViewController:self];
        if (pet) {
            self.nameTF.text = pet.nickname;
            self.genderCode = pet.gender;
            switch ([pet.gender intValue]) {
                case 0:{
                    self.genderTL.text = @"女孩";
                }break;
                case 1:{
                    self.genderTL.text = @"男孩";
                }break;
                default:{
                    self.genderTL.text = @"保密";
                }
                    break;
            }
            self.breedCode = pet.breed;
            self.breedTL.text = [_petCategory breedWithIDcode:[pet.breed integerValue]];
            self.regionTL.text = pet.region;
            _selectedBirthday = [pet.birthday timeIntervalSince1970];
            NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
            dateF.dateFormat = @"yyyy-MM-dd";
            NSString *messageDateStr = [dateF stringFromDate:pet.birthday];
            [self.birthTL setText:messageDateStr];
            self.nameTF.textColor = [UIColor blackColor];
            self.genderTL.textColor = [UIColor blackColor];
            self.breedTL.textColor = [UIColor blackColor];
            self.regionTL.textColor = [UIColor blackColor];
            self.birthTL.textColor = [UIColor blackColor];
            self.avatarUrl =pet.headImgURL;
            _headBtn.imageURL = [NSURL URLWithString:pet.headImgURL];
        }
    }
    else if (self.nickname){
        self.nameTF.text = self.nickname;
    }
    
    [self buildViewWithSkintype];
}
-(void)uploadUserHeadImg
{
    [SVProgressHUD showWithStatus:@"设置头像..."];
    [NetServer uploadImage:self.headIMG Type:@"avatar" Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    } Success:^(id responseObject, NSString *fileURL) {
        self.avatarUrl = fileURL;
        [SVProgressHUD dismiss];
        [self goToRegister];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self showAlertWithMessage:@"头像上传失败，请稍后重试"];
    }];
}
-(void)goToRegister
{
    [SVProgressHUD showWithStatus:@"设置个人资料..."];
    NSMutableDictionary * regDict = [NetServer commonDict];
    [regDict setObject:@"register" forKey:@"command"];
    [regDict setObject:@"register" forKey:@"options"];
    [regDict setObject:self.username forKey:@"username"];
    [regDict setObject:self.password forKey:@"password"];
    if (!self.userPlatform) {
        [regDict setObject:self.username forKey:@"mobile"];
    }
    [regDict setObject:self.userPlatform?self.userPlatform:@"0" forKey:@"source"];
    [regDict setObject:[self.nameTF.text CutSpacing] forKey:@"nickname"];
    [regDict setObject:self.avatarUrl forKey:@"head"];
    [regDict setObject:self.genderCode forKey:@"gender"];
    [regDict setObject:self.breedCode forKey:@"type"];
    [regDict setObject:[NSString stringWithFormat:@"%.0f",_selectedBirthday*1000] forKey:@"birthday"];
    [regDict setObject:self.regionTL.text forKey:@"address"];
    [NetServer requestWithParameters:regDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * petDic = ((responseObject[@"value"])[@"petList"])[0];
        UserServe * userServe = [UserServe sharedUserServe];
        [SystemServer sharedSystemServer].metionTokenOutTime = NO;
        userServe.userName = _username;
        userServe.userID = (responseObject[@"value"])[@"id"];
        userServe.petArr = nil;
        
        [SFHFKeychainUtils storeUsername:[NSString stringWithFormat:@"%@%@SToken",DomainName,userServe.userID] andPassword:(responseObject[@"value"])[@"sessionToken"] forServiceName:CHONGWUSHUOTOKENSTORESERVICE updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:[NSString stringWithFormat:@"%@%@SKey",DomainName,userServe.userID] andPassword:(responseObject[@"value"])[@"sessionKey"] forServiceName:CHONGWUSHUOTOKENSTORESERVICE updateExisting:YES error:nil];
        
        userServe.currentPet = ({
            Pet * pet = [[Pet alloc] init];
            pet.petID = petDic[@"id"];
            pet.nickname = petDic[@"nickName"];
            pet.headImgURL = petDic[@"headPortrait"];
            pet.gender = petDic[@"gender"];
            pet.breed = petDic[@"type"];
            pet.region = petDic[@"address"];
            pet.birthday = [NSDate dateWithTimeIntervalSince1970:[petDic[@"birthday"] doubleValue]/1000];
            pet.fansNo = (petDic[@"counter"])[@"fans"];
            pet.attentionNo = (petDic[@"counter"])[@"focus"];
            pet.issue = (petDic[@"counter"])[@"issue"];
            pet.relay = (petDic[@"counter"])[@"relay"];
            pet.comment = (petDic[@"counter"])[@"comment"];
            pet.favour = (petDic[@"counter"])[@"favour"];
            pet.grade = [petDic[@"grade"] stringByReplacingOccurrencesOfString:@"DJ" withString:@""];
            pet.score = petDic[@"score"];
            pet.coin = petDic[@"coin"];
            pet;
        });
        
        Account * acc = [[Account alloc]init];
        acc.username = _username;
        acc.userID = userServe.userID;
        acc.password = _password;
        [DatabaseServe activateUeserWithAccount:acc];
        [DatabaseServe activatePet:userServe.currentPet WithUsername:acc.username];

//        [SVProgressHUD dismiss];
        if ([responseObject objectForKey:@"message"]) {
            [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRLoginSucceed" object:self userInfo:nil];
        [self dismissViewControllerAnimated:YES completion:^{
            [[RootViewController sharedRootViewController] showHotUserViewController];
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"register failed info:%@",error);
        [SVProgressHUD dismiss];
        [self showAlertWithMessage:error.domain];

    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==5) {
        AddressManageViewController * sv = [[AddressManageViewController alloc] init];
        sv.finishTitle = @"保存";
        [self.navigationController pushViewController:sv animated:YES];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"infoCell";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
    UILabel * nameTL = [[UILabel alloc] initWithFrame:CGRectMake(10, 12.5, 80, 20)];
    [nameTL setText:_titleArray[indexPath.row]];
    [cell.contentView addSubview:nameTL];
    
    switch (indexPath.row) {
        case 0:
        {
            [cell.contentView addSubview:_nameTF];
        }
            break;
        case 1:
        {
            UIButton * selectGenderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [selectGenderBtn setFrame:CGRectMake(90, 0, ScreenWidth-120, 45)];
            selectGenderBtn.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:selectGenderBtn];
            [selectGenderBtn addTarget:self action:@selector(selectGenderBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [selectGenderBtn addSubview:_genderTL];
            
        }
            break;
        case 2:
        {
            UIButton * selectBirthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [selectBirthBtn setFrame:CGRectMake(90, 0, ScreenWidth-120, 45)];
            selectBirthBtn.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:selectBirthBtn];
            [selectBirthBtn addTarget:self action:@selector(selectBirthdayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [selectBirthBtn addSubview:_birthTL];
        }
            break;
        case 3:
        {
            UIButton * selectBreedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [selectBreedBtn setFrame:CGRectMake(90, 0, ScreenWidth-120, 45)];
            selectBreedBtn.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:selectBreedBtn];
            [selectBreedBtn addTarget:self action:@selector(selectCategoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [selectBreedBtn addSubview:_breedTL];
        }
            break;
        case 4:
        {
            UIButton * selectRegionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [selectRegionBtn setFrame:CGRectMake(90, 0, ScreenWidth-120, 45)];
            selectRegionBtn.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:selectRegionBtn];
            [selectRegionBtn addTarget:self action:@selector(selectRegionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [selectRegionBtn addSubview:_regionTL];
        }
            break;
            
        default:
            break;
    }
    if (indexPath.row==5) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

//    cell.textLabel.text = @"waiting to edit...";
    return cell;
}
-(void)dateChanged:(UIDatePicker *)dateP
{
    NSDate* _date = dateP.date;
    _selectedBirthday = [_date timeIntervalSince1970];
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyy-MM-dd";
    NSString *messageDateStr = [dateF stringFromDate:_date];
    [self.birthTL setText:messageDateStr];
    self.birthTL.textColor = [UIColor blackColor];
    NSLog(@"%@",_date);
}
-(void)didSelected
{
    if (self.pickerViewType==PickerViewTypeGender) {
        [self.genderTL setText:[self.genderArray objectAtIndex:[self.pickerView selectedRowInComponent:0]]];
        if ([self.pickerView selectedRowInComponent:0]==0) {
            self.genderCode = @"1";
        }
        else if ([self.pickerView selectedRowInComponent:0]==1) {
            self.genderCode = @"0";
        }
        else if ([self.pickerView selectedRowInComponent:0]==2) {
            self.genderCode = @"2";
        }
        [self.genderTL setTextColor:[UIColor blackColor]];
        
    }
    else if(self.pickerViewType==PickerViewTypeBreed){
        self.breedTL.text = ((PetCategory*)self.petBreedArray[[self.pickerView selectedRowInComponent:1]]).name;
        self.breedCode = ((PetCategory*)self.petBreedArray[[self.pickerView selectedRowInComponent:1]]).code;
        [self.breedTL setTextColor:[UIColor blackColor]];
    }
    else if (self.pickerViewType==PickerViewTypeRegion) {
        [self.regionTL setText:[self.cityArray objectAtIndex:[self.pickerView selectedRowInComponent:1]]];
        [self.regionTL setTextColor:[UIColor blackColor]];
    }
    else if (self.pickerViewType==PickerViewTypeBirthday){
        NSDate* _date = self.datePicker.date;
        _selectedBirthday = [_date timeIntervalSince1970];
        NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
        dateF.dateFormat = @"yyyy-MM-dd";
        NSString *messageDateStr = [dateF stringFromDate:_date];
        [self.birthTL setText:messageDateStr];
        self.birthTL.textColor = [UIColor blackColor];
    }

    [self.nameTF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        [self.bgV setContentOffset:CGPointMake(0, 0)];
        [self.pickerBGView setFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height, ScreenWidth, 244)];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)selectGenderBtnClicked:(UIButton *)sender
{
    [self.nameTF resignFirstResponder];
    self.pickerViewType = PickerViewTypeGender;
    self.pickerView.hidden = NO;
    self.datePicker.hidden = YES;
    [self.pickerView reloadAllComponents];
    [UIView animateWithDuration:0.3 animations:^{
        [self.bgV setContentOffset:CGPointMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height<500?140:60)];
        [self.pickerBGView setFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height-320, ScreenWidth, 244)];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)selectBirthdayBtnClicked:(UIButton *)sender
{
    [self.nameTF resignFirstResponder];
    self.pickerViewType = PickerViewTypeBirthday;
    self.datePicker.hidden = NO;
    self.pickerView.hidden = YES;
    [self.pickerView reloadAllComponents];
    [UIView animateWithDuration:0.3 animations:^{
        [self.bgV setContentOffset:CGPointMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height<500?140:60)];
        [self.pickerBGView setFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height-320, ScreenWidth, 244)];
    } completion:^(BOOL finished) {
        if (_selectedBirthday && _selectedBirthday!=0) {
            NSDate * gd = [NSDate dateWithTimeIntervalSince1970:_selectedBirthday];
            [self.datePicker setDate:gd];
        }
    }];
}

-(void)selectCategoryBtnClicked:(UIButton *)sender
{
    [self.nameTF resignFirstResponder];
    self.pickerViewType = PickerViewTypeBreed;
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    self.petBreedArray = [self.petCategory getBreedsForIndex:0];
    self.datePicker.hidden = YES;
    self.pickerView.hidden = NO;
    [self.pickerView reloadAllComponents];
    [UIView animateWithDuration:0.3 animations:^{
        [self.bgV setContentOffset:CGPointMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height<500?140:60)];
        [self.pickerBGView setFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height-320, ScreenWidth, 244)];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)selectRegionBtnClicked:(UIButton *)sender
{
    [self.nameTF resignFirstResponder];
    self.pickerViewType = PickerViewTypeRegion;
    self.datePicker.hidden = YES;
    self.pickerView.hidden = NO;
    [self.pickerView reloadAllComponents];
    [UIView animateWithDuration:0.3 animations:^{
        [self.bgV setContentOffset:CGPointMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height<500?140:60)];
        [self.pickerBGView setFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height-320, ScreenWidth, 244)];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.bgV setContentOffset:CGPointMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height<500?140:60)];
        [self.pickerBGView setFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height, ScreenWidth, 244)];
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    if ([[touch view] isEqual:self.pickerView]||[[touch view] isKindOfClass:[UITableViewCell class]]) {
        return;
    }
    [self.nameTF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        [self.bgV setContentOffset:CGPointMake(0, 0)];
        [self.pickerBGView setFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height, ScreenWidth, 244)];
    } completion:^(BOOL finished) {
        
    }];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.pickerView]) {
        return;
    }
    [self.nameTF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        [self.bgV setContentOffset:CGPointMake(0, 0)];
        [self.pickerBGView setFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height, ScreenWidth, 244)];
    } completion:^(BOOL finished) {
        
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerViewType==PickerViewTypeGender) {
        return 1;
    }
    else if (self.pickerViewType==PickerViewTypeBreed){
        return 2;
    }
    else if (self.pickerViewType==PickerViewTypeRegion){
        return 2;
    }
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.pickerViewType==PickerViewTypeGender) {
        return 3;
    }
    else if(self.pickerViewType==PickerViewTypeBreed)
    {
        if (component==0) {
            return self.petCategoryArray.count;
        }
        else
            return self.petBreedArray.count;
    }
    else if (self.pickerViewType==PickerViewTypeRegion) {
        if (component == 0) {
            return self.provinceArray.count;
        }
        return self.cityArray.count;
    }
    return 10;
}
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger) row forComponent:(NSInteger) component
{
    if (self.pickerViewType==PickerViewTypeGender) {
        return [self.genderArray objectAtIndex:row];
    }
    else if(self.pickerViewType==PickerViewTypeBreed){
        if (component==0) {
            return self.petCategoryArray[row];
        }
        else
        {
            return ((PetCategory*)self.petBreedArray[row]).name;
        }
    }
    else if (self.pickerViewType==PickerViewTypeRegion) {
        if (component == 0) {
            return [self.provinceArray[row] objectForKey:@"Province"];
        }
        return self.cityArray[row];
    }
    return @"lksdahlkja";
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickerViewType==PickerViewTypeGender) {
        [self.genderTL setText:[self.genderArray objectAtIndex:row]];
        [self.genderTL setTextColor:[UIColor blackColor]];
        if (row==0) {
            self.genderCode = @"1";
        }
        else if (row==1) {
            self.genderCode = @"0";
        }
        else if (row==2) {
            self.genderCode = @"2";
        }
    }
    else if (self.pickerViewType==PickerViewTypeBreed){
        if (component==0) {
            self.petBreedArray = [self.petCategory getBreedsForIndex:row];
            [self.pickerView reloadComponent:1];
        }
        else if(component==1){
            self.breedTL.text = ((PetCategory*)self.petBreedArray[[self.pickerView selectedRowInComponent:1]]).name;
            self.breedCode = ((PetCategory*)self.petBreedArray[[self.pickerView selectedRowInComponent:1]]).code;
            [_breedTL setTextColor:[UIColor blackColor]];
        }
    }
    else if (self.pickerViewType==PickerViewTypeRegion) {
        if (component == 0) {
            self.cityArray = [self.provinceArray[row] objectForKey:@"city"];
            [self.pickerView reloadComponent:1];
        }
        else
        {
            [_regionTL setText:self.cityArray[row]];
            [_regionTL setTextColor:[UIColor blackColor]];
        }
    }

}

-(void)addPicBtnClicked
{
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
        self.headIMG = [TTImageHelper compressImageDownToPhoneScreenSize:tempImg targetSizeX:200 targetSizeY:200];
        //    _headBtn.placeholderImage = _headIMG;
        [_headBtn setImage:_headIMG forState:UIControlStateNormal];
    }];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)registerNewUser
{
    if ([self.nameTF.text CutSpacing].length<2||[self.nameTF.text CutSpacing].length>15) {
        [SVProgressHUD showErrorWithStatus:@"昵称要填哦，2-15个字"];
        return;
    }
    if (self.genderTL.textColor==[UIColor lightGrayColor]) {
        [SVProgressHUD showErrorWithStatus:@"性别要选呀"];
        return;
    }
    if (self.birthTL.textColor==[UIColor lightGrayColor]) {
        [SVProgressHUD showErrorWithStatus:@"生日要选呀"];
        return;
    }
    if (self.breedTL.textColor==[UIColor lightGrayColor]) {
        [SVProgressHUD showErrorWithStatus:@"你的种族得让人家知道呀"];
        return;
    }
    if (self.regionTL.textColor==[UIColor lightGrayColor]) {
        [SVProgressHUD showErrorWithStatus:@"填一下你在哪吧"];
        return;
    }
    if (self.headIMG) {
        [self uploadUserHeadImg];
    }
    else
        [self goToRegister];
//    [self.navigationController dismissViewControllerAnimated:YES completion:^{
//        
//    }];
}
-(void)showAlertWithMessage:(NSString *)message
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [alert show];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
