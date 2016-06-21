//
//  ClothPetInfoViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/6/2.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "ClothPetInfoViewController.h"

@interface ClothPetInfoViewController ()

@end

@implementation ClothPetInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fitfulCode = @"1";
    self.fitful = @"合身";
    self.genderArray = [NSArray arrayWithObjects:@"男孩",@"女孩",@"保密", nil];
    self.view.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    self.title = @"爱宠信息";
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    
    self.bgScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(self.view.frame)-40-navigationBarHeight)];
    self.bgScrollV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bgScrollV];
    self.bgScrollV.contentSize = CGSizeMake(ScreenWidth, 2000);
    
    self.firstPartV = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 150)];
    self.firstPartV.backgroundColor = [UIColor whiteColor];
    [self.bgScrollV addSubview:self.firstPartV];
    
    UILabel * tl = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    tl.backgroundColor = [UIColor clearColor];
    tl.font = [UIFont boldSystemFontOfSize:14];
    tl.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    tl.text = @"基本信息";
    [self.firstPartV addSubview:tl];
    
    UIButton * howtoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [howtoBtn setFrame:CGRectMake(ScreenWidth-110, 0, 100, 30)];
    [howtoBtn setTitle:@"测量助手>>" forState:UIControlStateNormal];
    [howtoBtn setTitleColor:[UIColor colorWithRed:133/255.0f green:203/255.0f blue:252/255.0f alpha:1] forState:UIControlStateNormal];
    howtoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    howtoBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.firstPartV addSubview:howtoBtn];
    [howtoBtn addTarget:self action:@selector(howToMeasure) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * chestL = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 60, 30)];
    chestL.backgroundColor = [UIColor clearColor];
    chestL.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
    chestL.font = [UIFont systemFontOfSize:14];
    [self.firstPartV addSubview:chestL];
    chestL.text = @"胸围:";
    
    self.chestTF = [[UITextField alloc] initWithFrame:CGRectMake(60, 30, 120, 30)];
    self.chestTF.borderStyle = UITextBorderStyleRoundedRect;
    self.chestTF.backgroundColor = [UIColor whiteColor];
    [self.firstPartV addSubview:self.chestTF];
    self.chestTF.textAlignment = NSTextAlignmentRight;
    self.chestTF.keyboardType = UIKeyboardTypeNumberPad;
//    self.chestTF.returnKeyType = UIReturnKeyDone;
    self.chestTF.delegate = self;
    
    UILabel * chestLN = [[UILabel alloc] initWithFrame:CGRectMake(185, 30, 60, 30)];
    chestLN.backgroundColor = [UIColor clearColor];
    chestLN.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
    chestLN.font = [UIFont systemFontOfSize:16];
    [self.firstPartV addSubview:chestLN];
    chestLN.text = @"cm";
    
    UILabel * neckL = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 60, 30)];
    neckL.backgroundColor = [UIColor clearColor];
    neckL.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
    neckL.font = [UIFont systemFontOfSize:14];
    [self.firstPartV addSubview:neckL];
    neckL.text = @"颈围:";
    
    self.neckTF = [[UITextField alloc] initWithFrame:CGRectMake(60, 70, 120, 30)];
    self.neckTF.borderStyle = UITextBorderStyleRoundedRect;
    self.neckTF.backgroundColor = [UIColor whiteColor];
    [self.firstPartV addSubview:self.neckTF];
    self.neckTF.textAlignment = NSTextAlignmentRight;
    self.neckTF.keyboardType = UIKeyboardTypeNumberPad;
    self.neckTF.delegate = self;
    
    UILabel * neckLN = [[UILabel alloc] initWithFrame:CGRectMake(185, 70, 60, 30)];
    neckLN.backgroundColor = [UIColor clearColor];
    neckLN.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
    neckLN.font = [UIFont systemFontOfSize:16];
    [self.firstPartV addSubview:neckLN];
    neckLN.text = @"cm";
    
    UILabel * bodyL = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, 60, 30)];
    bodyL.backgroundColor = [UIColor clearColor];
    bodyL.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
    bodyL.font = [UIFont systemFontOfSize:14];
    [self.firstPartV addSubview:bodyL];
    bodyL.text = @"身长:";
    
    self.bodyTF = [[UITextField alloc] initWithFrame:CGRectMake(60, 110, 120, 30)];
    self.bodyTF.borderStyle = UITextBorderStyleRoundedRect;
    self.bodyTF.backgroundColor = [UIColor whiteColor];
    [self.firstPartV addSubview:self.bodyTF];
    self.bodyTF.textAlignment = NSTextAlignmentRight;
    self.bodyTF.keyboardType = UIKeyboardTypeNumberPad;
    self.bodyTF.delegate = self;
    
    UILabel * bodyLN = [[UILabel alloc] initWithFrame:CGRectMake(185, 110, 60, 30)];
    bodyLN.backgroundColor = [UIColor clearColor];
    bodyLN.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
    bodyLN.font = [UIFont systemFontOfSize:16];
    [self.firstPartV addSubview:bodyLN];
    bodyLN.text = @"cm";
    
    
    
    self.secondPartV = [[UIView alloc] initWithFrame:CGRectMake(0, self.firstPartV.frame.origin.y+self.firstPartV.frame.size.height+10, ScreenWidth, 150)];
    self.secondPartV.backgroundColor = [UIColor whiteColor];
    [self.bgScrollV addSubview:self.secondPartV];
    
    UILabel * tl2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    tl2.backgroundColor = [UIColor clearColor];
    tl2.font = [UIFont boldSystemFontOfSize:14];
    tl2.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    tl2.text = @"继续完善信息";
    [self.secondPartV addSubview:tl2];
    
    UILabel * breedL = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 100, 30)];
    breedL.backgroundColor = [UIColor clearColor];
    breedL.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
    breedL.font = [UIFont systemFontOfSize:14];
    [self.secondPartV addSubview:breedL];
    breedL.text = @"爱宠品种:";
    
    self.breedTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 30, 160, 30)];
    self.breedTF.borderStyle = UITextBorderStyleRoundedRect;
    self.breedTF.backgroundColor = [UIColor whiteColor];
    [self.secondPartV addSubview:self.breedTF];
    self.breedTF.textAlignment = NSTextAlignmentRight;
//    self.breedTF.keyboardType = UIKeyboardTypeNumberPad;
    
    self.breedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.breedBtn.frame = self.breedTF.frame;
    self.breedBtn.backgroundColor = [UIColor clearColor];
    [self.secondPartV addSubview:self.breedBtn];
    [self.breedBtn addTarget:self action:@selector(selectBreed) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel * genderL = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 100, 30)];
    genderL.backgroundColor = [UIColor clearColor];
    genderL.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
    genderL.font = [UIFont systemFontOfSize:14];
    [self.secondPartV addSubview:genderL];
    genderL.text = @"爱宠性别:";
    
    self.genderTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 70, 160, 30)];
    self.genderTF.borderStyle = UITextBorderStyleRoundedRect;
    self.genderTF.backgroundColor = [UIColor whiteColor];
    [self.secondPartV addSubview:self.genderTF];
    self.genderTF.textAlignment = NSTextAlignmentRight;
    self.genderTF.keyboardType = UIKeyboardTypeNumberPad;
    
    self.genderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.genderBtn.frame = self.genderTF.frame;
    self.genderBtn.backgroundColor = [UIColor clearColor];
    [self.secondPartV addSubview:self.genderBtn];
    [self.genderBtn addTarget:self action:@selector(selectGender) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * weightL = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, 100, 30)];
    weightL.backgroundColor = [UIColor clearColor];
    weightL.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
    weightL.font = [UIFont systemFontOfSize:14];
    [self.secondPartV addSubview:weightL];
    weightL.text = @"爱宠体重:";
    
    self.weightTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 110, 160, 30)];
    self.weightTF.borderStyle = UITextBorderStyleRoundedRect;
    self.weightTF.backgroundColor = [UIColor whiteColor];
    [self.secondPartV addSubview:self.weightTF];
    self.weightTF.textAlignment = NSTextAlignmentRight;
    self.weightTF.keyboardType = UIKeyboardTypeDecimalPad;
    self.weightTF.delegate = self;
    
    UILabel * weightLN = [[UILabel alloc] initWithFrame:CGRectMake(255, 110, 60, 30)];
    weightLN.backgroundColor = [UIColor clearColor];
    weightLN.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
    weightLN.font = [UIFont systemFontOfSize:16];
    [self.secondPartV addSubview:weightLN];
    weightLN.text = @"kg";
    
    self.thirdPartV = [[UIView alloc] initWithFrame:CGRectMake(0, self.secondPartV.frame.origin.y+self.secondPartV.frame.size.height+10, ScreenWidth, 140)];
    self.thirdPartV.backgroundColor = [UIColor whiteColor];
    [self.bgScrollV addSubview:self.thirdPartV];
    
    UILabel * tl3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    tl3.backgroundColor = [UIColor clearColor];
    tl3.font = [UIFont boldSystemFontOfSize:14];
    tl3.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    tl3.text = @"选择版式";
    [self.thirdPartV addSubview:tl3];
    
    
    
    UIButton * sb1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [sb1 setFrame:CGRectMake(20, 40, 80, 80)];
    sb1.backgroundColor = [UIColor colorWithRed:133/255.0f green:203/255.0f blue:252/255.0f alpha:1];
    sb1.layer.cornerRadius = 40;
    sb1.layer.borderColor = [[UIColor colorWithRed:133/255.0f green:203/255.0f blue:252/255.0f alpha:1] CGColor];
    sb1.layer.borderWidth = 1;
    sb1.layer.masksToBounds = YES;
    sb1.tag = 1;
    [self.thirdPartV addSubview:sb1];
    [sb1 setTitle:@"修身" forState:UIControlStateNormal];
    [sb1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sb1 addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * sb2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [sb2 setFrame:CGRectMake(ScreenWidth/2-40, 40, 80, 80)];
    sb2.backgroundColor = [UIColor whiteColor];
    sb2.layer.cornerRadius = 40;
    sb2.layer.borderColor = [[UIColor colorWithWhite:140/255.0f alpha:1] CGColor];
    sb2.layer.borderWidth = 1;
    sb2.layer.masksToBounds = YES;
    sb2.tag = 2;
    [self.thirdPartV addSubview:sb2];
    [sb2 setTitle:@"合身" forState:UIControlStateNormal];
    [sb2 setTitleColor:[UIColor colorWithWhite:140/255.0f alpha:1] forState:UIControlStateNormal];
    [sb2 addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * sb3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [sb3 setFrame:CGRectMake(ScreenWidth-20-80, 40, 80, 80)];
    sb3.backgroundColor = [UIColor whiteColor];
    sb3.layer.cornerRadius = 40;
    sb3.layer.borderColor = [[UIColor colorWithWhite:140/255.0f alpha:1] CGColor];
    sb3.layer.borderWidth = 1;
    sb3.layer.masksToBounds = YES;
    sb3.tag = 3;
    [self.thirdPartV addSubview:sb3];
    [sb3 setTitle:@"宽松" forState:UIControlStateNormal];
    [sb3 setTitleColor:[UIColor colorWithWhite:140/255.0f alpha:1] forState:UIControlStateNormal];
    [sb3 addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setBackgroundColor:[UIColor colorWithRed:255/255.0f green:115/255.0f blue:113/255.0f alpha:1]];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setFrame:CGRectMake(ScreenWidth/2, CGRectGetHeight(self.view.frame)-40-navigationBarHeight, ScreenWidth/2, 40)];
    [self.view addSubview:saveBtn];
    [saveBtn addTarget:self action:@selector(saveInfo) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setBackgroundColor:[UIColor colorWithWhite:220/255.0f alpha:1]];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-40-navigationBarHeight, ScreenWidth/2, 40)];
    [self.view addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(backBtnDo:) forControlEvents:UIControlEventTouchUpInside];
    
    self.bgScrollV.contentSize = CGSizeMake(ScreenWidth, self.thirdPartV.frame.size.height+self.thirdPartV.frame.origin.y+10);
    
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

    self.petCategory = [[PetCategoryParser alloc] init];
    self.petCategoryArray = [self.petCategory getParentCategorys];
    
    [self loadInfo];
    // Do any additional setup after loading the view.
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerViewType==2) {
        return 1;
    }
    else if (self.pickerViewType==1){
        return 2;
    }
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.pickerViewType==2) {
        return 3;
    }
    else if(self.pickerViewType==1)
    {
        if (component==0) {
            return self.petCategoryArray.count;
        }
        else
            return self.petBreedArray.count;
    }
    return 10;
}
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger) row forComponent:(NSInteger) component
{
    if (self.pickerViewType==2) {
        return [self.genderArray objectAtIndex:row];
    }
    else if(self.pickerViewType==1){
        if (component==0) {
            return self.petCategoryArray[row];
        }
        else
        {
            return ((PetCategory*)self.petBreedArray[row]).name;
        }
    }
    return @"lksdahlkja";
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickerViewType==2) {
        [self.genderTF setText:[self.genderArray objectAtIndex:row]];
//        [self.genderTL setTextColor:[UIColor blackColor]];
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
    else if (self.pickerViewType==1){
        if (component==0) {
            self.petBreedArray = [self.petCategory getBreedsForIndex:row];
            [self.pickerView reloadComponent:1];
        }
        else if(component==1){
            self.breedTF.text = ((PetCategory*)self.petBreedArray[[self.pickerView selectedRowInComponent:1]]).name;
            self.breedCode = ((PetCategory*)self.petBreedArray[[self.pickerView selectedRowInComponent:1]]).code;
//            [b setTextColor:[UIColor blackColor]];
        }
    }

    
}
-(void)didSelected
{
    if (self.pickerViewType==2) {
        [self.genderTF setText:[self.genderArray objectAtIndex:[self.pickerView selectedRowInComponent:0]]];
        if ([self.pickerView selectedRowInComponent:0]==0) {
            self.genderCode = @"1";
        }
        else if ([self.pickerView selectedRowInComponent:0]==1) {
            self.genderCode = @"0";
        }
        else if ([self.pickerView selectedRowInComponent:0]==2) {
            self.genderCode = @"2";
        }
        
    }
    else if(self.pickerViewType==1){
        self.breedTF.text = ((PetCategory*)self.petBreedArray[[self.pickerView selectedRowInComponent:1]]).name;
        self.breedCode = ((PetCategory*)self.petBreedArray[[self.pickerView selectedRowInComponent:1]]).code;
        [self.breedTF setTextColor:[UIColor blackColor]];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.bgScrollV setContentOffset:CGPointMake(0, 0)];
        [self.pickerBGView setFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height, ScreenWidth, 244)];
    } completion:^(BOOL finished) {
        
    }];

}
-(void)selectBreed
{
    [self.currentTF resignFirstResponder];
    self.pickerViewType = 1;
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    self.petBreedArray = [self.petCategory getBreedsForIndex:0];
//    self.datePicker.hidden = YES;
    self.pickerView.hidden = NO;
    [self.pickerView reloadAllComponents];
    [UIView animateWithDuration:0.3 animations:^{
        [self.bgScrollV setContentOffset:CGPointMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height<500?140:60)];
        [self.pickerBGView setFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height-320, ScreenWidth, 244)];
    } completion:^(BOOL finished) {
        
    }];

}

-(void)selectGender
{
    [self.currentTF resignFirstResponder];
    self.pickerViewType = 2;
    self.pickerView.hidden = NO;
//    self.datePicker.hidden = YES;
    [self.pickerView reloadAllComponents];
    [UIView animateWithDuration:0.3 animations:^{
        [self.bgScrollV setContentOffset:CGPointMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height<500?140:60)];
        [self.pickerBGView setFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height-320, ScreenWidth, 244)];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    if ([[touch view] isEqual:self.pickerView]||[[touch view] isKindOfClass:[UITableViewCell class]]) {
        return;
    }
    [self.currentTF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        [self.bgScrollV setContentOffset:CGPointMake(0, 0)];
        [self.pickerBGView setFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height, ScreenWidth, 244)];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTF = textField;
    [UIView animateWithDuration:0.3 animations:^{
        [self.bgScrollV setContentOffset:CGPointMake(0, 0)];
        [self.pickerBGView setFrame:CGRectMake(0, [UIApplication sharedApplication].keyWindow.frame.size.height, ScreenWidth, 244)];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)bottomBtnClicked:(UIButton *)sender
{
    [self selectWhichBtn:(int)sender.tag button:sender];
}

-(void)selectWhichBtn:(int)tag button:(UIButton *)sender
{
    for (int i = 0; i<3; i++) {
        UIButton * d = (UIButton *)[self.thirdPartV viewWithTag:i+1];
        if (d.tag==tag) {
            d.layer.borderColor = [[UIColor colorWithRed:133/255.0f green:203/255.0f blue:252/255.0f alpha:1] CGColor];
            d.backgroundColor = [UIColor colorWithRed:133/255.0f green:203/255.0f blue:252/255.0f alpha:1];
            [d setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            d.layer.borderColor = [[UIColor colorWithWhite:140/255.0f alpha:1] CGColor];
            d.backgroundColor = [UIColor whiteColor];
            [d setTitleColor:[UIColor colorWithWhite:140/255.0f alpha:1] forState:UIControlStateNormal];
        }
    }
    if (sender) {
        self.fitful = sender.currentTitle;
        self.fitfulCode = [NSString stringWithFormat:@"%d",(int)sender.tag];
        
    }
    NSLog(@"touch %d",tag);
}

-(void)loadInfo
{
    if ([self.infoDict objectForKey:@"chestLength"]) {
        self.chestTF.text = [self.infoDict objectForKey:@"chestLength"];
        self.neckTF.text = [self.infoDict objectForKey:@"neckLength"];
        self.bodyTF.text = [self.infoDict objectForKey:@"bodyLength"];
        self.breedTF.text = [self.infoDict objectForKey:@"breed"];
        self.genderTF.text = [self.infoDict objectForKey:@"gender"];
        self.weightTF.text = [self.infoDict objectForKey:@"weight"];
        int g = [[self.infoDict objectForKey:@"fitfulCode"] intValue];
        [self selectWhichBtn:g button:nil];
    }
}

-(void)saveInfo
{
    if (self.chestTF.text.length<1) {
        [SVProgressHUD showErrorWithStatus:@"胸围没填呢^_^"];
        return;
    }
    if (self.neckTF.text.length<1) {
        [SVProgressHUD showErrorWithStatus:@"颈围没填呢^_^"];
        return;
    }
    if (self.bodyTF.text.length<1) {
        [SVProgressHUD showErrorWithStatus:@"身长没填呢^_^"];
        return;
    }
    if (self.breedTF.text.length<1) {
        [SVProgressHUD showErrorWithStatus:@"品种选一下吧^_^"];
        return;
    }
    if (self.genderTF.text.length<1) {
        [SVProgressHUD showErrorWithStatus:@"性别选一下吧^_^"];
        return;
    }
    if (self.weightTF.text.length<1) {
        [SVProgressHUD showErrorWithStatus:@"体重填一下吧^_^"];
        return;
    }
    [self.infoDict setObject:self.chestTF.text forKey:@"chestLength"];
    [self.infoDict setObject:self.neckTF.text forKey:@"neckLength"];
    [self.infoDict setObject:self.bodyTF.text forKey:@"bodyLength"];
    [self.infoDict setObject:self.breedTF.text forKey:@"breed"];
    [self.infoDict setObject:self.genderTF.text forKey:@"gender"];
    [self.infoDict setObject:self.weightTF.text forKey:@"weight"];
    [self.infoDict setObject:self.fitful forKey:@"fitful"];
    [self.infoDict setObject:self.fitfulCode forKey:@"fitfulCode"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)howToMeasure
{
    WebContentViewController * vb = [[WebContentViewController alloc] init];
    vb.urlStr =[@"http://mp.weixin.qq.com/s?__biz=MjM5MDM1ODExMQ==&mid=209186738&idx=1&sn=97c57238821ad14d18ba0986ff34e05f#rd" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    vb.title = @"怎样测量";
    [self.navigationController pushViewController:vb animated:YES];
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
