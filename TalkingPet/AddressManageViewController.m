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
#import "FWAlertHelper.h"
@class WXRAddressCell;
//@protocol WXRAddressCellDelegate <NSObject>
//
//@optional
//#pragma mark编辑地址
//-(void)editAddress:(NSInteger)index;
//#pragma Mark 删除地址
//- (void)addressCellDelete:(WXRAddressCell *)addressCell;
//
//
//
//@end
@interface WXRAddressCell : UITableViewCell

{
    UILabel * nameL;
    UILabel * phoneL;
    UILabel * addressL;
    UIImageView * addressView;
    UIButton *defalutB;
    
}
@property (nonatomic,assign)NSInteger index;
//@property (nonatomic,assign)id <WXRAddressCellDelegate> delegate;
-(void)buildWithReceiptAddress:(ReceiptAddress*)address;
@property(nonatomic,strong)ReceiptAddress *addrss;
@property (nonatomic,copy)void(^deleteButtonClicked) (NSString * addressId);
@property (nonatomic,copy)void(^editButtonClicked) (ReceiptAddress* address);
@property (nonatomic,copy)void(^setDefaultAddress) (NSString * addressId);
@end
@implementation WXRAddressCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
#pragma Mark 地址图片
        
        //        addressView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 19.5, 27.5)];
        //        [self.contentView addSubview:addressView];
#pragma mark 姓名
        nameL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 160, 20)];
        nameL.font = [UIFont systemFontOfSize:14];
        nameL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        [self.contentView addSubview:nameL];
#pragma mark 电话号码
        phoneL = [[UILabel alloc] initWithFrame:CGRectMake(260, 10, 130, 20)];
        phoneL.font = [UIFont systemFontOfSize:14];
        
        phoneL.textColor = [UIColor colorWithWhite:140/255.0 alpha:1];
        [self.contentView addSubview:phoneL];
#pragma mark 地址管理
        addressL = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 240, 40)];
        addressL.font = [UIFont systemFontOfSize:14];
        addressL.textColor = [UIColor colorWithWhite:140/255.0 alpha:1];
        addressL.numberOfLines = 0;
        [self.contentView addSubview:addressL];
        
#pragma mark 编辑按钮
        UIButton * editB = [UIButton buttonWithType:UIButtonTypeCustom];
        [editB setImage:[UIImage imageNamed:@"bianji@2x"] forState:UIControlStateNormal];
        editB.frame = CGRectMake(ScreenWidth-72, 70, 30, 30);
        [editB addTarget:self action:@selector(editSelectedAddress) forControlEvents:UIControlEventTouchUpInside];
//        editB.backgroundColor =[UIColor redColor];
        //[editB  setTitle:@"编辑" forState:UIControlStateNormal];
        [self.contentView addSubview:editB];
#pragma mark 删除按钮
        
        UIButton * detelB = [UIButton buttonWithType:UIButtonTypeCustom];
        [ detelB  setImage:[UIImage imageNamed:@"shanchu@2x"] forState:UIControlStateNormal];
        detelB .frame = CGRectMake(ScreenWidth-42, 70, 30, 30);
        [ detelB  addTarget:self action:@selector(deSelectedAddress) forControlEvents:UIControlEventTouchUpInside];
//        detelB .backgroundColor =[UIColor blackColor];
        //[editB  setTitle:@"编辑" forState:UIControlStateNormal];
        [self.contentView addSubview:detelB ];
        
        
#pragma mark 默认按钮
        
        defalutB = [UIButton buttonWithType:UIButtonTypeCustom];
        [defalutB setBackgroundImage:[UIImage imageNamed:@"weixuanzhong2@2x"] forState:UIControlStateNormal];
        
        defalutB.frame = CGRectMake(ScreenWidth-370, 70, 22, 22);
        [defalutB addTarget:self action:@selector( defalutBSelectedAddress) forControlEvents:UIControlEventTouchUpInside];
//        defalutB .backgroundColor =[UIColor greenColor];
        //[editB  setTitle:@"编辑" forState:UIControlStateNormal];
        [self.contentView addSubview:defalutB];
        
        
    }
    return self;
}
#pragma mark 点击默认按钮
-(void)defalutBSelectedAddress
{
    
    if (self.setDefaultAddress) {
        self.setDefaultAddress(self.addrss.addressID);
    }
    
}


#pragma mark 点击删除按钮

-(void)deSelectedAddress
{
    [FWAlertHelper alertWithTitle:@"提示" message:@"确定要删除这个地址吗？删除了就不可恢复了哦" completion:^(NSInteger buttonIndex, NSString *title) {
        if ([title isEqualToString:@"确定"]) {
            if (self.deleteButtonClicked) {
                self.deleteButtonClicked(self.addrss.addressID);
            }
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
//    if ([self.delegate respondsToSelector:@selector(addressCellDelete:)]) {
//        
//        [self.delegate addressCellDelete:self];
//        
//    }
}




-(void)editSelectedAddress
{
    if (self.editButtonClicked) {
        self.editButtonClicked(self.addrss);
    }
//    if (_delegate && [_delegate respondsToSelector:@selector(editAddress:)]) {
//        [_delegate editAddress:_index];
//    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
}
-(void)buildWithReceiptAddress:(ReceiptAddress*)address
{
    self.addrss = address;
    if (address.action) {
//        addressView.image = [UIImage imageNamed:@"defaultAddress"];
        [defalutB setBackgroundImage:[UIImage imageNamed:@"moren@2x"] forState:UIControlStateNormal];
    }else
    {
//        addressView.image = [UIImage imageNamed:@"commonAddress"];
        [defalutB setBackgroundImage:[UIImage imageNamed:@"weixuanzhong2@2x"] forState:UIControlStateNormal];
    }
    nameL.text = [@"" stringByAppendingString:address.receiptName];
    phoneL.text = address.phoneNo;
    addressL.text = [NSString stringWithFormat:@"%@%@%@",address.province,address.city,address.address];
}
@end
@interface AddressManageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    WXRAddressCell *deletdeCell;
    
    
}
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
    self.title = @"收货地址管理";
    UIButton * addAddressB = [UIButton buttonWithType:UIButtonTypeCustom];
    addAddressB.frame = CGRectMake(0, self.view.frame.size.height-navigationBarHeight-self.view.frame.size.width*98/750, self.view.frame.size.width, self.view.frame.size.width*98/750);
    [addAddressB addTarget:self action:@selector(addNewAddress) forControlEvents:UIControlEventTouchUpInside];
    addAddressB.backgroundColor = CommonGreenColor;
    [addAddressB setTitle:@"添加新地址" forState:UIControlStateNormal       ];
    //    [addAddressB setImage:[UIImage imageNamed:@"address"] forState:UIControlStateNormal];
    
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
//    [SVProgressHUD showWithStatus:@"正在获取收货地址"];
    //    NSMutableDictionary* usersDict = [NetServer commonDict];
    //    [usersDict setObject:@"shippingAddress" forKey:@"command"];
    //    [usersDict setObject:@"list" forKey:@"options"];
    //    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        [blockArr removeAllObjects];
    //        [SVProgressHUD dismiss];
    //        [_tableView headerEndRefreshing];
    //        for (NSDictionary * dic in responseObject[@"value"]) {
    //            ReceiptAddress *address = [[ReceiptAddress alloc] init];
    //            address.addressID = dic[@"id"];
    //            address.receiptName = dic[@"name"];
    //            address.phoneNo = dic[@"mobile"];
    //            address.province = dic[@"province"];
    //            address.city = dic[@"city"];
    //            address.address = dic[@"address"];
    //            address.zipCode = dic[@"zipcode"];
    //            address.action = [dic[@"isDefault"] isEqualToString:@"true"];
    //            [blockArr addObject:address];
    //        }
    //        [blockView reloadData];
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        [_tableView headerEndRefreshing];
    //        [SVProgressHUD showErrorWithStatus:@"获取收货地址失败"];
    //    }];
    
    [NetServer fentchAddressListsuccess:^(id result) {
        if ([result[@"code"] intValue]==200) {
            [blockArr removeAllObjects];
            [SVProgressHUD dismiss];
            [_tableView headerEndRefreshing];
            for (NSDictionary * dic in result[@"data"]) {
                ReceiptAddress *address = [[ReceiptAddress alloc] init];
                address.addressID = dic[@"id"];
                address.receiptName = dic[@"consignee"];
                address.phoneNo = dic[@"telphone"];
                address.province = dic[@"area_zh"];
                address.city = @"";
                address.address = dic[@"address"];
                address.zipCode = @"100000";
                address.action = [dic[@"is_default"] isEqualToString:@"1"];
                [blockArr addObject:address];
            }
            [blockView reloadData];
        }
        else
        {
            [_tableView headerEndRefreshing];
            [SVProgressHUD showErrorWithStatus:@"获取收货地址失败"];
            
        }
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
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
            [SVProgressHUD dismiss];
            if ([result[@"code"] intValue]==200) {
                if (bolckSelf.useAddress) {
                    bolckSelf.useAddress(address);
                }else
                {
                    [bolckSelf.navigationController popToViewController:bolckSelf animated:YES];
                }
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"保存收货地址失败"];
            }
            
            
        } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
            [SVProgressHUD showErrorWithStatus:@"保存收货地址失败"];
        }];
    };
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)setDefaultAddressWithId:(NSString * )addressId
{
    [SVProgressHUD showWithStatus:@"设置默认收货地址..."];
    [NetServer setDefaultAddressWithAdressId:addressId success:^(id result) {
        [SVProgressHUD showSuccessWithStatus:@"已设置为默认地址"];
        [_tableView headerBeginRefreshing];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [SVProgressHUD showErrorWithStatus:@"设置默认地址失败"];
    }];
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
    cell.deleteButtonClicked = ^(NSString * addressId){
        [self deleteOneAddressWithAddressId:addressId Index:indexPath.section];
    };
    cell.editButtonClicked = ^(ReceiptAddress* address){
        [self editAddress:indexPath.section];
    };
    cell.setDefaultAddress = ^(NSString * addressId){
        [self setDefaultAddressWithId:addressId];
    };
    
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
            [NetServer deleteAddressWithAdressId:address.addressID success:^(id result) {
                
            } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
                
            }];
        }
        [_addressArr removeObjectAtIndex:indexPath.section];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

-(void)deleteOneAddressWithAddressId:(NSString *)addressId Index:(NSInteger)index
{
    [NetServer deleteAddressWithAdressId:addressId success:^(id result) {
        [_addressArr removeObjectAtIndex:index];
        [_tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        
    }];
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
        //        NSMutableDictionary* usersDict = [NetServer commonDict];
        //        [usersDict setObject:@"shippingAddress" forKey:@"command"];
        //        [usersDict setObject:@"update" forKey:@"options"];
        //        [usersDict setObject:address.address forKey:@"address"];
        //        [usersDict setObject:address.phoneNo forKey:@"mobile"];
        //        [usersDict setObject:address.city forKey:@"city"];
        //        [usersDict setObject:address.province forKey:@"province"];
        //        [usersDict setObject:address.receiptName forKey:@"name"];
        //        [usersDict setObject:address.zipCode forKey:@"zipcode"];
        //        [usersDict setObject:address.addressID forKey:@"id"];
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
        
        [NetServer editAddressWithAdress:address success:^(id result) {
            if ([result[@"code"] intValue]==200) {
                [SVProgressHUD dismiss];
                if (bolckSelf.useAddress) {
                    bolckSelf.useAddress(address);
                }else
                {
                    [bolckSelf.navigationController popToViewController:bolckSelf animated:YES];
                }
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"保存收货地址失败"];
            }
        } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
            [SVProgressHUD showErrorWithStatus:@"保存收货地址失败"];
        }];
    };
}
@end
