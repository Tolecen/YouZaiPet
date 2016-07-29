//
//  AddressManageViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/6/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "AddressManageViewController.h"
#import "AddressDetailViewController.h"
#import "ReceiptAddress.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "NetServer+Payment.h"
@protocol WXRAddressCellDelegate <NSObject>
@optional
-(void)editAddress:(NSInteger)index;
@end
@interface WXRAddressCell : UITableViewCell
{
    UILabel * nameL;
    UILabel * phoneL;
    UILabel * addressL;
    UIImageView * addressView;
}
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,assign)id <WXRAddressCellDelegate> delegate;
-(void)buildWithReceiptAddress:(ReceiptAddress*)address;
@end
@implementation WXRAddressCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        addressView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 19.5, 27.5)];
        [self.contentView addSubview:addressView];
        nameL = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 160, 20)];
        nameL.font = [UIFont systemFontOfSize:14];
        nameL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        [self.contentView addSubview:nameL];
        phoneL = [[UILabel alloc] initWithFrame:CGRectMake(200, 10, 100, 20)];
        phoneL.font = [UIFont systemFontOfSize:12];
        phoneL.textColor = [UIColor colorWithWhite:140/255.0 alpha:1];
        [self.contentView addSubview:phoneL];
        addressL = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 240, 40)];
        addressL.font = [UIFont systemFontOfSize:12];
        addressL.textColor = [UIColor colorWithWhite:140/255.0 alpha:1];
        addressL.numberOfLines = 0;
        [self.contentView addSubview:addressL];
        UIButton * editB = [UIButton buttonWithType:UIButtonTypeCustom];
        [editB setImage:[UIImage imageNamed:@"editAddress"] forState:UIControlStateNormal];
        editB.frame = CGRectMake(ScreenWidth-32, 40, 22, 22);
        [editB addTarget:self action:@selector(editSelectedAddress) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:editB];
    }
    return self;
}
-(void)editSelectedAddress
{
    if (_delegate && [_delegate respondsToSelector:@selector(editAddress:)]) {
        [_delegate editAddress:_index];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
}
-(void)buildWithReceiptAddress:(ReceiptAddress*)address
{
    if (address.action) {
        addressView.image = [UIImage imageNamed:@"defaultAddress"];
    }else
    {
        addressView.image = [UIImage imageNamed:@"commonAddress"];
    }
    nameL.text = [@"收货人:" stringByAppendingString:address.receiptName];
    phoneL.text = address.phoneNo;
    addressL.text = [NSString stringWithFormat:@"%@%@%@",address.province,address.city,address.address];
}
@end
@interface AddressManageViewController ()<UITableViewDataSource,UITableViewDelegate,WXRAddressCellDelegate>
@property (nonatomic,retain)NSMutableArray * addressArr;
@property (nonatomic,retain)UITableView * tableView;
@end
@implementation AddressManageViewController
- (void)dealloc
{
    
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.addressArr = [NSMutableArray array];
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    self.title = @"地址管理";
    UIButton * addAddressB = [UIButton buttonWithType:UIButtonTypeCustom];
    addAddressB.frame = CGRectMake(0, self.view.frame.size.height-navigationBarHeight-self.view.frame.size.width*98/750, self.view.frame.size.width, self.view.frame.size.width*98/750);
    [addAddressB addTarget:self action:@selector(addNewAddress) forControlEvents:UIControlEventTouchUpInside];
    [addAddressB setImage:[UIImage imageNamed:@"address"] forState:UIControlStateNormal];
    [self.view addSubview:addAddressB];
    [self setBackButtonWithTarget:@selector(back)];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.view.frame.size.width*98/750-navigationBarHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView addHeaderWithTarget:self action:@selector(loadAddressList)];
    [_tableView headerBeginRefreshing];
}
-(void)loadAddressList
{
    __block NSMutableArray * blockArr = _addressArr;
    __block UITableView * blockView = _tableView;
    [SVProgressHUD showWithStatus:@"正在获取收货地址"];
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"shippingAddress" forKey:@"command"];
    [usersDict setObject:@"list" forKey:@"options"];
    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [blockArr removeAllObjects];
        [SVProgressHUD dismiss];
        [_tableView headerEndRefreshing];
        for (NSDictionary * dic in responseObject[@"value"]) {
            ReceiptAddress *address = [[ReceiptAddress alloc] init];
            address.addressID = dic[@"id"];
            address.receiptName = dic[@"name"];
            address.phoneNo = dic[@"mobile"];
            address.province = dic[@"province"];
            address.city = dic[@"city"];
            address.address = dic[@"address"];
            address.zipCode = dic[@"zipcode"];
            address.action = [dic[@"isDefault"] isEqualToString:@"true"];
            [blockArr addObject:address];
        }
        [blockView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView headerEndRefreshing];
        [SVProgressHUD showErrorWithStatus:@"获取收货地址失败"];
    }];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addNewAddress
{
    AddressDetailViewController * detailVC = [[AddressDetailViewController alloc] init];
    detailVC.title = @"新建收货地址";
    detailVC.finishTitle = _finishTitle;
    __block AddressManageViewController * bolckSelf = self;
    __block NSMutableArray * blockArr = _addressArr;
    __block UITableView * blockView = _tableView;
    detailVC.finish = ^(ReceiptAddress * address){
        [blockArr addObject:address];
        [blockView reloadData];
//        [SVProgressHUD showWithStatus:@"正在保存收货地址"];
//        NSMutableDictionary* usersDict = [NetServer commonDict];
//        [usersDict setObject:@"shippingAddress" forKey:@"command"];
//        [usersDict setObject:@"create" forKey:@"options"];
//        [usersDict setObject:address.address forKey:@"address"];
//        [usersDict setObject:address.phoneNo forKey:@"mobile"];
//        [usersDict setObject:address.city forKey:@"city"];
//        [usersDict setObject:address.province forKey:@"province"];
//        [usersDict setObject:address.receiptName forKey:@"name"];
//        [usersDict setObject:address.zipCode forKey:@"zipcode"];
//        [usersDict setObject:address.action?@"true":@"false" forKey:@"isDefault"];
//        [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            [SVProgressHUD dismiss];
//            if (bolckSelf.useAddress) {
//                bolckSelf.useAddress(address);
//            }else
//            {
//                [bolckSelf.navigationController popToViewController:bolckSelf animated:YES];
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [SVProgressHUD showErrorWithStatus:@"保存收货地址失败"];
//        }];
        
        
        [NetServer addAddressWithAdress:address success:^(id result) {
            
        } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
            
        }];
    };
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark -
#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _addressArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"tableViewCell";
    WXRAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[WXRAddressCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    [cell buildWithReceiptAddress:_addressArr[indexPath.section]];
    cell.delegate = self;
    cell.index = indexPath.section;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_useAddress) {
        _useAddress(_addressArr[indexPath.section]);
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        ReceiptAddress * address = _addressArr[indexPath.section];
        if (address.addressID) {
            NSMutableDictionary* usersDict = [NetServer commonDict];
            [usersDict setObject:@"shippingAddress" forKey:@"command"];
            [usersDict setObject:@"delete" forKey:@"options"];
            [usersDict setObject:address.addressID forKey:@"id"];
            [NetServer requestWithParameters:usersDict success:nil failure:nil];
        }
        [_addressArr removeObjectAtIndex:indexPath.section];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}
#pragma mark -
-(void)editAddress:(NSInteger)index
{
    AddressDetailViewController * detailVC = [[AddressDetailViewController alloc] init];
    detailVC.title = @"编辑收货地址";
    detailVC.finishTitle = _finishTitle;
    [detailVC updateReceiptAddress:_addressArr[index]];
    __block AddressManageViewController * bolckSelf = self;
    __block NSMutableArray * blockArr = _addressArr;
    __block UITableView * blockView = _tableView;
    [self.navigationController pushViewController:detailVC animated:YES];
    detailVC.finish = ^(ReceiptAddress * address){
        [blockArr replaceObjectAtIndex:index withObject:address];
        [blockView reloadData];
        [SVProgressHUD showWithStatus:@"正在保存收货地址"];
        NSMutableDictionary* usersDict = [NetServer commonDict];
        [usersDict setObject:@"shippingAddress" forKey:@"command"];
        [usersDict setObject:@"update" forKey:@"options"];
        [usersDict setObject:address.address forKey:@"address"];
        [usersDict setObject:address.phoneNo forKey:@"mobile"];
        [usersDict setObject:address.city forKey:@"city"];
        [usersDict setObject:address.province forKey:@"province"];
        [usersDict setObject:address.receiptName forKey:@"name"];
        [usersDict setObject:address.zipCode forKey:@"zipcode"];
        [usersDict setObject:address.addressID forKey:@"id"];
        [usersDict setObject:address.action?@"true":@"false" forKey:@"isDefault"];
        [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            if (bolckSelf.useAddress) {
                bolckSelf.useAddress(address);
            }else
            {
                [bolckSelf.navigationController popToViewController:bolckSelf animated:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"保存收货地址失败"];
        }];
    };
}
@end
