//
//  HotViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/5/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "HotViewController.h"
#import "MJRefresh.h"
#import "TalkingBrowse.h"
#import "PetalkView.h"
#import "EGOImageView.h"
#import "TalkingDetailPageViewController.h"
//#import "BrowserTableHelper.h"
@interface HotPetalkCell : UICollectionViewCell
@property (nonatomic,retain)PetalkView * petalkV;
@property (nonatomic,retain)EGOImageView * headView;
@property (nonatomic,retain)UILabel * nameL;
@property (nonatomic,retain)UILabel *timesL;//次数
@end
@implementation HotPetalkCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.petalkV  = [[PetalkView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        [self.contentView addSubview:_petalkV];
        self.headView = [[EGOImageView alloc] initWithFrame:CGRectMake(5, 10+frame.size.width, 24, 24)];
        _headView.placeholderImage = [UIImage imageNamed:@"browser_avatarPlaceholder"];
        _headView.layer.cornerRadius = 12;
        _headView.layer.masksToBounds=YES;
        [self.contentView addSubview:_headView];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(35, 10+frame.size.width, frame.size.width-40, 12)];
        _nameL.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
        _nameL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_nameL];
        self.timesL = [[UILabel alloc] initWithFrame:CGRectMake(35, 22+frame.size.width, frame.size.width-40, 12)];
        _timesL.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
        _timesL.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_timesL];
    }
    return self;
}
@end
@interface HotViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    int page;
}
@property (nonatomic,retain)NSMutableArray * dataArr;




@end
@implementation HotViewController
-(void)viewDidLoad
{
    NSArray * baseArr = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"hotList%@",[UserServe sharedUserServe].userID]];
    self.dataArr = [NSMutableArray array];
    for (NSDictionary * dic in baseArr) {
        TalkingBrowse * petalk = [[TalkingBrowse alloc] initWithHostInfo:dic];
        [_dataArr addObject:petalk];
    }
//    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
//    float whith = (self.view.frame.size.width-15)/2;
//    layout.itemSize = CGSizeMake(whith,whith+44);
//    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
//    layout.minimumInteritemSpacing = 5;
//    layout.minimumLineSpacing = 5;
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    self.hotView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
//    _hotView.alwaysBounceVertical = YES;
//    _hotView.delegate = self;
//    _hotView.dataSource = self;
//    _hotView.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1];
//    [self.view addSubview:_hotView];
//    _hotView.showsHorizontalScrollIndicator = NO;
//    [_hotView registerClass:[HotPetalkCell class] forCellWithReuseIdentifier:@"HotPetalkCell"];
//    
//    [_hotView addHeaderWithTarget:self action:@selector(getHotListFirstPage)];
//    [_hotView addFooterWithTarget:self action:@selector(getHotListOtherPage)];
    
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight)];
    _contentTableView.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _contentTableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    [self.view addSubview:_contentTableView];
    
    self.tableViewHelper = [[BrowserTableHelper alloc] initWithController:self Tableview:_contentTableView SectionView:nil];
    _contentTableView.delegate = self.tableViewHelper;
    _contentTableView.dataSource = self.tableViewHelper;
    self.tableViewHelper.cellNeedShowPublishTime = NO;
//    self.tableViewHelper.tableViewType = TableViewTypeTagList;
    
    NSArray * hotArray = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"hotList%@",[UserServe sharedUserServe].userID]];
    NSDictionary * hotReqDict = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"hotListReqDict%@",[UserServe sharedUserServe].userID]];
    if (hotArray&&hotReqDict) {
        self.tableViewHelper.dataArray = [self.tableViewHelper getModelArray:hotArray];
        self.tableViewHelper.reqDict = [NSMutableDictionary dictionaryWithDictionary:hotReqDict];
        [self.contentTableView reloadData];
        
    }

    
    
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"petalk" forKey:@"command"];
    [mDict setObject:@"hotList" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"petId"];
    [mDict setObject:@"10" forKey:@"pageSize"];
    [mDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"pageIndex"];
    
    self.tableViewHelper.reqDict = mDict;
    
    [self.contentTableView headerBeginRefreshing];
//    [self.tableViewHelper loadFirstDataPageWithDict:mDict];
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.contentTableView setFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight)];
}
- (void)beginRefreshing
{
//    [_hotView headerBeginRefreshing];
    [self.contentTableView headerBeginRefreshing];
}
-(void)getHotListFirstPage
{
    page = 0;
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"petalk" forKey:@"command"];
    [mDict setObject:@"hotList" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"petId"];
    [mDict setObject:@"10" forKey:@"pageSize"];
    [mDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"pageIndex"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_dataArr removeAllObjects];
        [_hotView headerEndRefreshing];
        NSArray * array = [responseObject[@"value"] objectForKey:@"list"];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:[NSString stringWithFormat:@"hotList%@",[UserServe sharedUserServe].userID]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        for (NSDictionary * dic in array) {
            TalkingBrowse * petalk = [[TalkingBrowse alloc] initWithHostInfo:dic];
            [_dataArr addObject:petalk];
        }
        [_hotView reloadData];
        page++;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hotView headerEndRefreshing];
    }];
}
-(void)getHotListOtherPage
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"petalk" forKey:@"command"];
    [mDict setObject:@"hotList" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"petId"];
    [mDict setObject:@"10" forKey:@"pageSize"];
    [mDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"pageIndex"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_hotView footerEndRefreshing];
        NSArray * array = [responseObject[@"value"] objectForKey:@"list"];
        for (NSDictionary * dic in array) {
            TalkingBrowse * petalk = [[TalkingBrowse alloc] initWithHostInfo:dic];
            [_dataArr addObject:petalk];
        }
        [_hotView reloadData];
        page++;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hotView footerEndRefreshing];
    }];
}
#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TalkingBrowse * petalk = _dataArr[indexPath.row];
    static NSString *SectionCellIdentifier = @"HotPetalkCell";
    HotPetalkCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SectionCellIdentifier forIndexPath:indexPath];
    [cell.petalkV layoutSubviewsWithTalking:petalk];
    cell.headView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/50",petalk.petInfo.headImgURL]];
    cell.nameL.text = petalk.petInfo.nickname;
    cell.timesL.text = [NSString stringWithFormat:@"%@人浏览",petalk.browseNum];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TalkingDetailPageViewController * talkingDV = [[TalkingDetailPageViewController alloc] init];
    talkingDV.talking = _dataArr[indexPath.row];
    
    [self.parentViewController.navigationController pushViewController:talkingDV animated:YES];
}
@end
