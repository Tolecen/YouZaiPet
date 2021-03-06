//
//  AddressDetailViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/6/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "AddressDetailViewController.h"
#import "ReceiptAddress.h"
#import "SVProgressHUD.h"
#import "TFileManager.h"
#import "IdentifyingString.h"

@interface OneViewCell : UITableViewCell
{
    UIView * line;
}
@property (nonatomic,readonly)UIView * view;
@property (nonatomic,retain)UILabel * titleL;
-(void)buildView:(UIView *)view;
@end
@implementation OneViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        _titleL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        _titleL.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_titleL];
        line = [[UIView alloc] initWithFrame:CGRectMake(10, 40-1, ScreenWidth-10, 1)];
        line.backgroundColor = [UIColor colorWithWhite:240/255.0 alpha:1];
        [self.contentView addSubview:line];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize  size = [_titleL.text sizeWithFont:_titleL.font constrainedToSize:CGSizeMake(ScreenWidth, 20) lineBreakMode:NSLineBreakByWordWrapping];
    _titleL.frame = CGRectMake(10, 10, size.width, size.height);
    line.frame = CGRectMake(10, self.contentView.frame.size.height-1, ScreenWidth-10, 1);
}
-(void)buildView:(UIView *)view
{
    if (_view) {
        [_view removeFromSuperview];
        _view = nil;
    }
    _view = view;
    [self.contentView addSubview:_view];
}
@end
@interface AddressDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UITextField * cityL;
    BOOL canSwitch;
    
    NSDictionary * addressDict;
    
    int cTag;
}
@property (nonatomic,retain)NSArray * titleArr;
@property (nonatomic,retain)ReceiptAddress * address;
@property (nonatomic,retain)NSMutableArray * provinceArray;
@property (nonatomic,retain)NSMutableArray * cityArray;
@property (nonatomic,retain)NSMutableArray * quArray;
@property (nonatomic,retain)UITableView * tableView;
@end
@implementation AddressDetailViewController
- (void)dealloc
{
    
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.address = [[ReceiptAddress alloc] init];
//        NSString *path =[[NSString alloc]initWithString:[[NSBundle mainBundle]pathForResource:@"city"ofType:@"txt"]];
//        NSData* data = [[NSData alloc]initWithContentsOfFile:path];
//        self.provinceArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        self.cityArray = [_provinceArray[0] objectForKey:@"city"];
        canSwitch = YES;
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    [self setBackButtonWithTarget:@selector(back)];
    
    
    self.provinceArray = [NSMutableArray array];
    
    self.titleArr = @[@"收货人:",@"联系电话:",@"所在区域:",@"详细地址:",@"身份证",@"设为默认收货地址:"];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height-navigationBarHeight-10-self.view.frame.size.width*98/750)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIButton * saveAddressB = [UIButton buttonWithType:UIButtonTypeCustom];
    saveAddressB.frame = CGRectMake(0, self.view.frame.size.height-navigationBarHeight-self.view.frame.size.width*98/750, self.view.frame.size.width, self.view.frame.size.width*98/750);
    [saveAddressB setTitleColor:CommonGreenColor forState:UIControlStateNormal];
    saveAddressB.backgroundColor = [UIColor whiteColor];
    [saveAddressB addTarget:self action:@selector(saveAddressB) forControlEvents:UIControlEventTouchUpInside];
    [saveAddressB setTitle:_finishTitle forState:UIControlStateNormal];
    [self.view addSubview:saveAddressB];
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    addressDict = [TFileManager getAddressDict];
    if (addressDict) {
        NSDictionary *lv1 = [addressDict objectForKey:@"lv1"];
        NSArray * allPkeys = [lv1 allKeys];
        NSArray * allPkey =[allPkeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([obj1 intValue] > [obj2 intValue]) {
                return NSOrderedDescending;
            }
            if ([obj1 intValue] < [obj2 intValue]) {
                return NSOrderedAscending;
            }
            return NSOrderedSame;
        }];
        for (int i = 0; i<allPkey.count; i++) {
            NSArray * d = [NSArray arrayWithObjects:[lv1 objectForKey:allPkey[i]],allPkey[i], nil];
            [self.provinceArray addObject:d];
        }
        NSDictionary *lv2 = [addressDict objectForKey:@"lv2"];
        NSLog(@"dddffsss:%@",[self.provinceArray firstObject]);
        self.cityArray = [lv2 objectForKey:[[self.provinceArray firstObject] lastObject]];
        NSDictionary * lv3 = [addressDict objectForKey:@"lv3"];
        self.quArray = [lv3 objectForKey:[[self.cityArray firstObject] lastObject]];
    }
}
-(NSString *)makeString:(id)key
{
    return [NSString stringWithFormat:@"%@",key];
}
-(void)updateReceiptAddress:(ReceiptAddress *) address
{
    self.address = address;
    if (address.action) {
        canSwitch = NO;
    }
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveAddressB
{
    if (_address.receiptName.length<=0) {
        [SVProgressHUD showErrorWithStatus:@"请输入收货人"];
        return;
    }
    if (_address.phoneNo.length<=0) {
        [SVProgressHUD showErrorWithStatus:@"请输入联系电话"];
        return;
    }
    if (_address.province.length<=0||_address.city.length<=0) {
        [SVProgressHUD showErrorWithStatus:@"请选择所在地区"];
        return;
    }
    if (_address.address.length<=0) {
        [SVProgressHUD showErrorWithStatus:@"请输入详细地址"];
        return;
    }
    if (_address.cardId.length>0) {
        if (![IdentifyingString checkUserIdCard:_address.cardId]) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的身份证"];
            return;
        }
    }
    if (_finish) {
        _finish(_address);
    }
}
-(void)setDefalutAddress:(UISwitch*)swh
{
    _address.action = swh.on;
}
-(void)cityFinishSelected:(UIBarButtonItem *)btn
{
    cTag = (int)btn.tag;
    for (OneViewCell * cell in _tableView.visibleCells) {
        [cell.view resignFirstResponder];
    }
    if (cTag==2) {
        cityL.text = [NSString stringWithFormat:@"%@%@%@",_address.province,_address.city,_address.qu];
    }

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (OneViewCell * cell in _tableView.visibleCells) {
        [cell.view resignFirstResponder];
    }
}
#pragma mark -
#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"tableViewCell";
    OneViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[OneViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.titleL.text = _titleArr[indexPath.row];
    switch (indexPath.row) {
        case 0:{
            UITextField * textF = [[UITextField alloc] init];
            textF.tag = 100;
            textF.returnKeyType = UIReturnKeyDone;
            textF.delegate = self;
            textF.text = _address.receiptName;
            textF.frame = CGRectMake(100, 10, 200, 20);
            [cell buildView:textF];
        }break;
        case 1:{
            UITextField * textF = [[UITextField alloc] init];
            textF.tag = 101;
            textF.inputAccessoryView =({
                UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
                toolbar.tintColor = [UIColor blackColor];
                UIBarButtonItem*rb = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(cityFinishSelected:)];
                rb.tag = 1;
                rb.tintColor = [UIColor blackColor];
                toolbar.items = @[rb];
                toolbar;
            });
            textF.keyboardType = UIKeyboardTypeNumberPad;
            textF.delegate = self;
            textF.text = _address.phoneNo;
            textF.frame = CGRectMake(100, 10, 200, 20);
            [cell buildView:textF];
        }break;
        case 2:{
            cityL = [[UITextField alloc] init];
            cityL.returnKeyType = UIReturnKeyDone;
            cityL.delegate = self;
            cityL.inputAccessoryView =({
                UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
                toolbar.tintColor = [UIColor blackColor];
                UIBarButtonItem*rb = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(cityFinishSelected:)];
                rb.tag = 2;
                rb.tintColor = [UIColor blackColor];
                toolbar.items = @[rb];
                toolbar;
            });
            cityL.inputView = ({
                UIPickerView * pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, 0, 0)];
                pickerView.dataSource = self;
                pickerView.delegate = self;
                pickerView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
                pickerView.showsSelectionIndicator = YES;
                pickerView;
            });
            cityL.text = [_address.province stringByAppendingString:_address.city];
            cityL.frame = CGRectMake(100, 10, 200, 20);
            [cell buildView:cityL];
        }break;
        case 3:{
            UITextView * textV = [[UITextView alloc] init];
            textV.text = _address.address;
            textV.font = [UIFont systemFontOfSize:13];
            textV.returnKeyType = UIReturnKeyDone;
            textV.delegate = self;
            textV.frame = CGRectMake(100, 10, 200, 60);
            [cell buildView:textV];
        }break;
        case 4:{
            UITextField * textF = [[UITextField alloc] init];
            textF.tag = 104;
            textF.keyboardType = UIKeyboardTypeNumberPad;
            textF.inputAccessoryView =({
                UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
                toolbar.tintColor = [UIColor blackColor];
                UIBarButtonItem*rb = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(cityFinishSelected:)];
                rb.tag=3;
                rb.tintColor = [UIColor blackColor];
                toolbar.items = @[rb];
                toolbar;
            });
            textF.delegate = self;
            textF.text = [self transStarOfIdCard];
            textF.frame = CGRectMake(100, 10, 200, 20);
            [cell buildView:textF];
        }break;
        case 5:{
            UISwitch * defalut = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenWidth-100, 6, 100, 28)];
            defalut.on = _address.action;
            [defalut addTarget:self action:@selector(setDefalutAddress:) forControlEvents:UIControlEventValueChanged];
            [cell buildView:defalut];
            defalut.enabled = canSwitch;
        }break;
        default:
            break;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        return 80;
    }
    return 40;
}

-(NSString *)transStarOfIdCard
{
    if (self.address.cardId && self.address.cardId.length>0) {
        return [self.address.cardId stringByReplacingCharactersInRange:NSMakeRange(3, self.address.cardId.length-6) withString:@"**********"];
    }
    return @"";
}
#pragma mark -
#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 100:{
            _address.receiptName = textField.text;
        }break;
        case 101:{
            _address.phoneNo = textField.text;
        }break;
        case 104:{
            _address.cardId = textField.text;
        }break;
        default:
            break;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:cityL]) {
        if (!_address.province&&!_address.city&&!_address.qu) {
            _address.province = [self.provinceArray[0] firstObject];
            _address.provinceCode = [self.provinceArray[0] lastObject];
            _address.city = [self.cityArray[0] firstObject];
            _address.cityCode = [self.cityArray[0] lastObject];
            _address.qu = [self.quArray[0] firstObject];
            _address.quCode = [self.quArray[0] lastObject];
//            cityL.text = [NSString stringWithFormat:@"%@%@%@",_address.province,_address.city,_address.qu];
        }
    }
}
#pragma mark -
#pragma mark - UITextView
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqual:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{

    _address.address = textView.text;
}
#pragma mark -
#pragma mark - UITextField
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return self.provinceArray.count;
    }
    else if(component==1)
        return self.cityArray.count;
    else
        return self.quArray.count;
}
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger) row forComponent:(NSInteger) component
{
    if (component == 0) {
        return [self.provinceArray[row] firstObject];
    }
    else if (component==1){
        return [self.cityArray[row] firstObject];
    }
    return [self.quArray[row] firstObject];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
//        self.cityArray = [self.provinceArray[row] objectForKey:@"city"];
//        [pickerView reloadComponent:1];
//        _address.province = [self.provinceArray[row] objectForKey:@"Province"];
//        _address.city = self.cityArray[[pickerView selectedRowInComponent:1]];
        
        
        NSDictionary *lv2 = [addressDict objectForKey:@"lv2"];
        self.cityArray = [lv2 objectForKey:[self.provinceArray[row] lastObject]];
        NSDictionary * lv3 = [addressDict objectForKey:@"lv3"];
        self.quArray = [lv3 objectForKey:[self.cityArray[[pickerView selectedRowInComponent:1]] lastObject]];
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        
        _address.province = [self.provinceArray[row] firstObject];
        _address.provinceCode = [self.provinceArray[row] lastObject];
        _address.city = [self.cityArray[[pickerView selectedRowInComponent:1]] firstObject];
        _address.cityCode = [self.cityArray[[pickerView selectedRowInComponent:1]] lastObject];
        _address.qu = [self.quArray[[pickerView selectedRowInComponent:2]] firstObject];
        _address.quCode = [self.quArray[[pickerView selectedRowInComponent:2]] lastObject];
        
    }
    else if (component==1){
        NSDictionary * lv3 = [addressDict objectForKey:@"lv3"];
        self.quArray = [lv3 objectForKey:[self.cityArray[row] lastObject]];
        
        [pickerView reloadComponent:2];
        
        _address.city = [self.cityArray[row] firstObject];
        _address.cityCode = [self.cityArray[row] lastObject];
        _address.qu = [self.quArray[[pickerView selectedRowInComponent:2]] firstObject];
        _address.quCode = [self.quArray[[pickerView selectedRowInComponent:2]] lastObject];
    }
    else
    {
        _address.qu = [self.quArray[row] firstObject];
        _address.quCode = [self.quArray[row] lastObject];
    }

}
@end
