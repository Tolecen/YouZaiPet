//
//  MJDetailViewController.m
//  MJPopupViewControllerDemo
//
//  Created by Martin Juhasz on 24.06.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import "MJDetailViewController.h"
#import "SVProgressHUD.h"
@protocol PackageDelegate2 <NSObject>
@optional
-(void)setStatusHaveGetToIndex:(NSInteger)index;
@end
@interface GiftPreviewCell : UITableViewCell
{
    UIImageView * view;
}
@property (nonatomic,retain)UILabel * ntitleLabel;
//@property (nonatomic,assign)id<PetCellDelegate>delegate;
@property (nonatomic,retain)UIButton * actionBtn;
@property (nonatomic,retain)UILabel * desLabel;
@property (nonatomic,strong)PackageInfo * packageInfo;
@property (nonatomic,assign)NSInteger cellIndex;
@property (nonatomic,assign)id <PackageDelegate2>delegate;
@end
@implementation GiftPreviewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.ntitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 230, 20)];
        [self.ntitleLabel setText:@"这是标题"];
        [self.ntitleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.ntitleLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.ntitleLabel];
        
        self.actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.actionBtn setFrame:CGRectMake(260-10-53, 12, 53, 25)];
        [self.actionBtn setBackgroundColor:[UIColor colorWithRed:162/255.f green:158/255.f blue:255/255.f alpha:1]];
        self.actionBtn.layer.cornerRadius = 5;
        self.actionBtn.layer.masksToBounds = YES;
//        [self.actionBtn setBackgroundImage:[UIImage imageNamed:@"package_getBtn"]forState:UIControlStateNormal];
        [self.actionBtn setTitle:@"领取" forState:UIControlStateNormal];
        [self.actionBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.actionBtn];
        [self.actionBtn addTarget:self action:@selector(getButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(5, 50, 250, 1)];
        [lineV setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
        [self.contentView addSubview:lineV];
        
        self.desLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 240, 20)];
        [self.desLabel setText:@"这是标题"];
        [self.desLabel setFont:[UIFont systemFontOfSize:13]];
        [self.desLabel setBackgroundColor:[UIColor clearColor]];
        self.desLabel.numberOfLines = 0;
        self.desLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.desLabel];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.ntitleLabel.text = self.packageInfo.packageTitle;
    self.desLabel.text = self.packageInfo.packageInfo;
    CGSize theSize = [self.packageInfo.packageInfo sizeWithFont:self.desLabel.font constrainedToSize:CGSizeMake(240, 800) lineBreakMode:NSLineBreakByWordWrapping];
    [self.desLabel setFrame:CGRectMake(10, 60, 240, theSize.height)];
    if (self.packageInfo.canGet&&!self.packageInfo.haveGot) {
        self.actionBtn.hidden = NO;
    }
    else
        self.actionBtn.hidden = YES;
}

-(void)getButtonClicked
{
    //    if ([self.delegate respondsToSelector:@selector(getPackageWithId:)]) {
    //        [self.delegate getPackageWithId:self.packageInfo.packageId];
    //    }
    self.actionBtn.enabled = NO;
    [SVProgressHUD showWithStatus:@"领取中"];
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"giftBag" forKey:@"command"];
    [mDict setObject:@"draw" forKey:@"options"];
    [mDict setObject:self.packageInfo.packageId forKey:@"code"];
    [mDict setObject:[UserServe sharedUserServe].currentPet.petID?[UserServe sharedUserServe].currentPet.petID:@"no" forKey:@"petId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"error"] isEqualToString:@"200"]) {
            [SVProgressHUD showSuccessWithStatus:@"领取成功"];
            self.packageInfo.haveGot = YES;
            
            self.actionBtn.hidden = YES;
            [SystemServer sharedSystemServer].shouldReNewTree = YES;
            if ([self.delegate respondsToSelector:@selector(setStatusHaveGetToIndex:)]) {
                [self.delegate setStatusHaveGetToIndex:self.cellIndex];
            }
        }
        else
        {
            [SVProgressHUD dismiss];
        }
        self.actionBtn.enabled = YES;
        //        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"领取失败"];
        self.actionBtn.enabled = YES;
    }];
}
@end;
@interface MJDetailViewController ()<PackageDelegate2>

@end
@implementation MJDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.haveGot = NO;
    self.dArray = [NSMutableArray array];
    self.view.frame = CGRectMake(0, 0, 260, 300);
    self.view.layer.cornerRadius = 5;
    self.view.layer.masksToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.bgScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 260, 160)];
    [self.view addSubview:_bgScrollV];
    _bgScrollV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"samplebg.png"]];
    _bgScrollV.delegate = self;
    _bgScrollV.layer.cornerRadius = 5;
    _bgScrollV.layer.masksToBounds = YES;
    _bgScrollV.showsHorizontalScrollIndicator = YES;
    _bgScrollV.showsVerticalScrollIndicator = NO;
//    _bgScrollV.backgroundColor = [UIColor clearColor];
    _bgScrollV.contentSize = CGSizeMake(_bgScrollV.frame.size.width, _bgScrollV.frame.size.height);
//    _bgScrollV.pagingEnabled = YES;
    _bgScrollV.bounces = YES;
    
    self.loadingAct = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingAct.center = _bgScrollV.center;
    [self.bgScrollV addSubview:self.loadingAct];
    [self.loadingAct startAnimating];
    
    UIView * bgv = [[UIView alloc] initWithFrame:CGRectMake(0, 155, 260, 5)];
    [bgv setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bgv];
    
    self.cTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 160, 260, 300-155-5-5)];
    _cTableView.delegate = self;
    _cTableView.dataSource = self;
//    _cTableView.backgroundView = uu;
    _cTableView.scrollsToTop = YES;
    _cTableView.backgroundColor = [UIColor whiteColor];
    _cTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _notiTableView.rowHeight = 90;
    //    _notiTableView.contentInset = UIEdgeInsetsMake(0, 0, 59, 0);
    _cTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_cTableView];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(260-40, 0, 40, 40)];
    [btn setImage:[UIImage imageNamed:@"close_cha"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(closePopup:) forControlEvents:UIControlEventTouchUpInside];
    [self getPackageInfo];
}
-(void)getPackageInfo
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"giftBag" forKey:@"command"];
    [mDict setObject:@"detail" forKey:@"options"];
    [mDict setObject:self.packageInfo.packageId forKey:@"code"];

    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.loadingAct stopAnimating];
        NSLog(@"get package info succedd:%@",responseObject);
        self.dArray = [responseObject objectForKey:@"value"];
        [self.bgScrollV setContentSize:CGSizeMake(self.dArray.count*80+(self.dArray.count+1)*10, 160)];
        [self setContentForPackage];
                //        [self.packageTableview headerEndRefreshing];
        //        [self cellPlayAni:self.tableV];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get package info error:%@",error);
        [self.loadingAct stopAnimating];
    }];
    

}
-(void)setContentForPackage
{
    for (int i = 0; i<self.dArray.count; i++) {
        EGOImageView * ddV = [[EGOImageView alloc] initWithFrame:CGRectMake(10*(i+1)+80*i, 40, 80, 80)];
        [ddV setImageWithURL:[NSURL URLWithString:[self.dArray[i] objectForKey:@"thumbnail"]]];
        [self.bgScrollV addSubview:ddV];
    }

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize theSize = [self.packageInfo.packageInfo sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(240, 800) lineBreakMode:NSLineBreakByWordWrapping];
    return 50+theSize.height+25;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier = @"talkingCell";
    GiftPreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[GiftPreviewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellIndex = self.cellIndex;
    cell.packageInfo = self.packageInfo;
    return cell;
}
-(void)setStatusHaveGetToIndex:(NSInteger)index
{
    self.haveGot = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"111111");
    if (!self.haveGot) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(alsoResetStatusHaveGotToIndex:)]) {
        [self.delegate alsoResetStatusHaveGotToIndex:self.cellIndex];
    }

}
- (void)closePopup:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [self.delegate cancelButtonClicked:self];
    }
}

@end
