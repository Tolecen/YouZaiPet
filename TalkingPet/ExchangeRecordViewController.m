//
//  ExchangeRecordViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/1/14.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "ExchangeRecordViewController.h"
#import "MJRefresh.h"
#import "EGOImageView.h"
#import "Common.h"
@interface RecordCell : UITableViewCell
@property (nonatomic,retain)UILabel * ntitleLabel;
@property (nonatomic,retain)EGOImageView * imageV;
@property (nonatomic,retain)UILabel * desLabel;
@property (nonatomic,retain)UIImageView * freeFreight;
@property (nonatomic,retain)UILabel * timeL;
@property (nonatomic,retain)UILabel * codeL;
@property (nonatomic,retain)UILabel * supplierL;
@end
@implementation RecordCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.imageV = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        self.imageV.placeholderImage = [UIImage imageNamed:@"package_holder"];
        [self.contentView addSubview:self.imageV];
        
        self.ntitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, ScreenWidth-110, 40)];
        [self.ntitleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.ntitleLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.ntitleLabel];
        self.ntitleLabel.numberOfLines = 0;
        self.ntitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.ntitleLabel.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        
        UIImageView * petPeaIV = [[UIImageView alloc] initWithFrame:CGRectMake(100, 50, 15, 15)];
        petPeaIV.image = [UIImage imageNamed:@"peaicon"];
        [self.contentView addSubview:petPeaIV];
        
        self.desLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 50, 90, 15)];
        [self.desLabel setFont:[UIFont systemFontOfSize:15]];
        [self.desLabel setBackgroundColor:[UIColor clearColor]];
        self.desLabel.textColor = [UIColor colorWithRed:247/255.0 green:98/255.0 blue:192/255.0 alpha:1];
        [self.contentView addSubview:self.desLabel];
        
        self.freeFreight = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-15-55, 97, 55, 23)];
        _freeFreight.image = [UIImage imageNamed:@"geted"];
        [self.contentView addSubview:self.freeFreight];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-110, 50, 110, 15)];
        [self.timeL setFont:[UIFont systemFontOfSize:15]];
        [self.timeL setBackgroundColor:[UIColor clearColor]];
        self.timeL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        [self.contentView addSubview:self.timeL];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 60, 15)];
        [label setFont:[UIFont systemFontOfSize:15]];
        [label setBackgroundColor:[UIColor clearColor]];
        label.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        label.text = @"领取码:";
        [self.contentView addSubview:label];
        
        self.codeL = [[UILabel alloc] initWithFrame:CGRectMake(70, 100, 250, 15)];
        [_codeL setFont:[UIFont systemFontOfSize:15]];
        [_codeL setBackgroundColor:[UIColor clearColor]];
        _codeL.textColor = [UIColor colorWithRed:135/255.0 green:130/255.0 blue:250/255.0 alpha:1];
        [self.contentView addSubview:_codeL];
        
        self.supplierL = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, ScreenWidth-20, 40)];
        [_supplierL setFont:[UIFont systemFontOfSize:15]];
        [_supplierL setBackgroundColor:[UIColor clearColor]];
        _supplierL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        _supplierL.numberOfLines = 0;
        [self.contentView addSubview:_supplierL];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 169, ScreenWidth, 1)];
        [lineView setBackgroundColor:[UIColor colorWithWhite:220/255.0 alpha:1]];
        [self.contentView addSubview:lineView];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = [_ntitleLabel.text sizeWithFont:_ntitleLabel.font constrainedToSize:CGSizeMake(ScreenWidth-110, 50)];
    _ntitleLabel.frame = CGRectMake(100, 10, size.width, size.height);
}
@end;
@interface ExchangeRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int page;
    UILabel * unRecordL;
}
@property (nonatomic, strong)UITableView * packageTableview;
@property (nonatomic, strong)NSMutableArray * recordArr;
@end

@implementation ExchangeRecordViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"兑换记录";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonWithTarget:@selector(backBtnDo)];
    [self buildViewWithSkintype];
    
    self.packageTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight)];
    _packageTableview.delegate = self;
    _packageTableview.dataSource = self;
    _packageTableview.backgroundColor = [UIColor colorWithWhite:230/255.0 alpha:1];
    _packageTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _packageTableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_packageTableview];
    
    [self.packageTableview addHeaderWithTarget:self action:@selector(getFristRecordList)];
    [self.packageTableview addFooterWithTarget:self action:@selector(getRecordList)];
    
    [_packageTableview headerBeginRefreshing];
    
    unRecordL = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 40)];
    unRecordL.backgroundColor = [UIColor clearColor];
    unRecordL.text = @"没有兑换记录";
    unRecordL.font = [UIFont systemFontOfSize:20];
    unRecordL.textAlignment = NSTextAlignmentCenter;
    unRecordL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
    unRecordL.hidden = YES;
    [self.view addSubview:unRecordL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backBtnDo
{
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}
- (void)getFristRecordList
{
    page = 0;
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"goods" forKey:@"command"];
    [mDict setObject:@"orderList" forKey:@"options"];
    [mDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"pageIndex"];
    [mDict setObject:@"10" forKey:@"pageSize"];
    [mDict setObject:[UserServe sharedUserServe].currentPet.petID forKey:@"petId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        page++;
        [_packageTableview headerEndRefreshing];
        self.recordArr = [NSMutableArray arrayWithArray:responseObject[@"value"]];
        if (!_recordArr.count) {
            unRecordL.hidden = NO;
            return ;
        }
        [_packageTableview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_packageTableview headerEndRefreshing];
    }];
}
- (void)getRecordList
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"goods" forKey:@"command"];
    [mDict setObject:@"orderList" forKey:@"options"];
    [mDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"pageIndex"];
    [mDict setObject:@"10" forKey:@"pageSize"];
    [mDict setObject:[UserServe sharedUserServe].currentPet.petID forKey:@"petId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        page++;
        [_packageTableview footerEndRefreshing];
        [_recordArr addObjectsFromArray:responseObject[@"value"]];
        [_packageTableview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_packageTableview footerEndRefreshing];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recordArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *goodsCellIdentifier = @"recordCell";
    NSDictionary * dic = _recordArr[indexPath.row];
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCellIdentifier];
    if (cell == nil) {
        cell = [[RecordCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:goodsCellIdentifier];
    }
    cell.imageV.imageURL = [NSURL URLWithString:dic[@"goodsCoverUrl"]];
    cell.ntitleLabel.text = dic[@"goodsDescription"];
    cell.desLabel.text = dic[@"goodsPrice"];
    cell.codeL.text = dic[@"receiveKey"];
    cell.supplierL.text = dic[@"goodsSupplier"];
    NSString * text = [Common getDateStringWithTimestamp:dic[@"createTime"]];
    cell.timeL.text = text;
    if ([dic[@"state"] intValue] == 44||[dic[@"state"] intValue] == 32) {
        cell.freeFreight.hidden = NO;
    }else{
        cell.freeFreight.hidden = YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
