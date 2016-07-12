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
@property (nonatomic,retain)EGOImageView * imageV;
@property (nonatomic,retain)EGOImageView * headView;
@property (nonatomic,retain) TalkingBrowse * talking;
@property (nonatomic,retain)UILabel * desL;
@property (nonatomic,retain)UIButton * tagButton;
@property (nonatomic,retain)UILabel * tagLabel;
@property (nonatomic,retain)UILabel * zanL;
@property (nonatomic,retain)UILabel *commentL;
@property (nonatomic,retain)UIButton *zanButton;
@property (nonatomic,retain)UILabel * nameL;
@property (nonatomic,retain)UILabel *gradeL;
@end
@implementation HotPetalkCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
//        self.petalkV  = [[PetalkView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
//        [self.contentView addSubview:_petalkV];
        
        self.imageV = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        self.imageV.backgroundColor = [UIColor colorWithR:245 g:245 b:245 alpha:1];
        [self.contentView addSubview:self.imageV];
        
        self.desL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.imageV.frame)+5, frame.size.width-20, 40)];
        self.desL.backgroundColor = [UIColor clearColor];
        self.desL.textColor = [UIColor colorWithR:150 g:150 b:150 alpha:1];
        self.desL.font = [UIFont systemFontOfSize:13];
        self.desL.numberOfLines = 2;
        self.desL.lineBreakMode = NSLineBreakByCharWrapping;
        self.desL.text = @"要在这里添加描述哦哈哈急急急预约啊啊";
        [self.contentView addSubview:self.desL];
        
        
        self.tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.tagButton.frame = CGRectMake(10, CGRectGetMaxY(self.desL.frame)+6, frame.size.width-20, 14);
        self.tagButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.tagButton];
        
        UIImageView * tagimgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 10, 10)];
        tagimgv.image = [UIImage imageNamed:@"biaoqian@2x"];
        [self.tagButton addSubview:tagimgv];
        
        self.tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, frame.size.width-30, 14)];
        self.tagLabel.backgroundColor = [UIColor clearColor];
        self.tagLabel.textColor = [UIColor colorWithR:200 g:200 b:200 alpha:1];
        self.tagLabel.font = [UIFont systemFontOfSize:10];
        self.tagLabel.text = @"萌宠大比拼";
        [self.tagButton addSubview:self.tagLabel];
        
        UIImageView * zanimgv = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-35-10-35-10, CGRectGetMaxY(self.tagButton.frame)+12, 10, 10)];
        zanimgv.image = [UIImage imageNamed:@"zan@2x"];
        [self.contentView addSubview:zanimgv];
        
        self.zanL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(zanimgv.frame)+5, CGRectGetMaxY(self.tagButton.frame)+10, 30, 14)];
        self.zanL.backgroundColor = [UIColor clearColor];
        self.zanL.textColor = [UIColor colorWithR:200 g:200 b:200 alpha:1];
        self.zanL.font = [UIFont systemFontOfSize:11];
        self.zanL.text = @"120";
        self.zanL.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.zanL];
        
        UIImageView * cimgv = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-35-10, CGRectGetMaxY(self.tagButton.frame)+12, 10, 10)];
        cimgv.image = [UIImage imageNamed:@"pinglun@2x"];
        [self.contentView addSubview:cimgv];
        
        self.commentL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cimgv.frame)+5, CGRectGetMaxY(self.tagButton.frame)+10, 30, 14)];
        self.commentL.backgroundColor = [UIColor clearColor];
        self.commentL.textColor = [UIColor colorWithR:200 g:200 b:200 alpha:1];
        self.commentL.font = [UIFont systemFontOfSize:11];
        self.commentL.text = @"23";
        self.commentL.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.commentL];
        
        UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.commentL.frame)+6, frame.size.width-10, 1)];
        lineV.backgroundColor = [UIColor colorWithR:245 g:245 b:245 alpha:1];
        [self.contentView addSubview:lineV];
        
        
        self.headView = [[EGOImageView alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(lineV.frame)+5, 36, 36)];
        _headView.backgroundColor = [UIColor colorWithR:245 g:245 b:245 alpha:1];
        _headView.layer.cornerRadius = 18;
        _headView.layer.masksToBounds=YES;
        [self.contentView addSubview:_headView];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headView.frame)+7, CGRectGetMinY(self.headView.frame), frame.size.width-46-40, 18)];
        _nameL.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
        _nameL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_nameL];
        _nameL.text = @"小泥河";
        
        self.gradeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headView.frame)+7, CGRectGetMaxY(self.nameL.frame), self.nameL.frame.size.width, 18)];
        self.gradeL.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
        self.gradeL.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:self.gradeL];
        self.gradeL.text = @"LV.12";
        
        self.zanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.zanButton.frame = CGRectMake(frame.size.width-10-28, CGRectGetMinY(self.headView.frame)+7, 24, 22);
        [self.zanButton setBackgroundImage:[UIImage imageNamed:@"xihuan-off@2x"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.zanButton];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.imageV setImageWithURL:[NSURL URLWithString:@"http://testimages.buybestpet.com/img/content/20160711/DB217CBD9DF647899C331D7355FB139C.jpg"]];
    [self.headView setImageWithURL:[NSURL URLWithString:@"http://xlimage.uzero.cn/img/avatar/20141227/3E76C2395A5644DCB29A1DD24602D16F.jpg"]];
}
@end

@interface HotJingYanCell : UICollectionViewCell
//@property (nonatomic,retain)PetalkView * petalkV;
@property (nonatomic,retain)EGOImageView * imageV;
@property (nonatomic,retain)EGOImageView * headView;
@property (nonatomic,retain)UILabel * nameL;
@property (nonatomic,retain)UILabel *timesL;//次数
@end
@implementation HotJingYanCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    
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

@property (nonatomic,strong)UIView * topSelV;
@property (nonatomic,strong)UIImageView * zhiV;


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
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
    float whith = (self.view.frame.size.width-30)/2;
    layout.itemSize = CGSizeMake(whith,whith+5+40+10+10+10+10+10+40+10);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.hotView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight) collectionViewLayout:layout];
    _hotView.alwaysBounceVertical = YES;
    _hotView.delegate = self;
    _hotView.dataSource = self;
    _hotView.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1];
    [self.view addSubview:_hotView];
    _hotView.showsHorizontalScrollIndicator = NO;
    [_hotView registerClass:[HotPetalkCell class] forCellWithReuseIdentifier:@"HotPetalkCell"];
    
    [_hotView addHeaderWithTarget:self action:@selector(getHotListFirstPage)];
    [_hotView addFooterWithTarget:self action:@selector(getHotListOtherPage)];
    
    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight)];
    _contentTableView.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _contentTableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    [self.view addSubview:_contentTableView];
    _contentTableView.hidden = YES;
    
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
    
    [self addTopSelView];
//    [self.tableViewHelper loadFirstDataPageWithDict:mDict];
}

-(void)addTopSelView
{
    self.topSelV = [[UIView alloc] initWithFrame:CGRectMake(0, -70, ScreenWidth, 100)];
    self.topSelV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.topSelV];
    
    UIView * bgav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
    bgav.backgroundColor = [UIColor whiteColor];
    [self.topSelV addSubview:bgav];
    
    UIButton * buttonSel = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonSel setBackgroundImage:[UIImage imageNamed:@"shouye_more@2x"] forState:UIControlStateNormal];
    [buttonSel setFrame:CGRectMake(ScreenWidth/2-40, CGRectGetMaxY(bgav.frame), 80, 25)];
    [self.topSelV addSubview:buttonSel];
    [buttonSel addTarget:self action:@selector(showOrHideTopSelV) forControlEvents:UIControlEventTouchUpInside];
    
    self.zhiV = [[UIImageView alloc] initWithFrame:CGRectMake(65/2, 5, 15, 5)];
    self.zhiV.image = [UIImage imageNamed:@"shouqi@2x"];
    [buttonSel addSubview:self.zhiV];
    self.zhiV.userInteractionEnabled = NO;
    
}
-(void)showOrHideTopSelV
{
    if (self.topSelV.frame.origin.y==0) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.topSelV setFrame:CGRectMake(0, -70, ScreenWidth, 100)];
        } completion:^(BOOL finished) {
            self.zhiV.image = [UIImage imageNamed:@"xiala@2x"];
        }];
        
    }
    else if(self.topSelV.frame.origin.y==-70){
        [UIView animateWithDuration:0.3 animations:^{
            [self.topSelV setFrame:CGRectMake(0, 0, ScreenWidth, 100)];
        } completion:^(BOOL finished) {
            self.zhiV.image = [UIImage imageNamed:@"shouqi@2x"];
        }];
    }
        
        
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
    return 20;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    TalkingBrowse * petalk = _dataArr[indexPath.row];
    static NSString *SectionCellIdentifier = @"HotPetalkCell";
    HotPetalkCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SectionCellIdentifier forIndexPath:indexPath];
//    [cell.petalkV layoutSubviewsWithTalking:petalk];
//    cell.headView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/50",petalk.petInfo.headImgURL]];
//    cell.nameL.text = petalk.petInfo.nickname;
//    cell.timesL.text = [NSString stringWithFormat:@"%@人浏览",petalk.browseNum];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TalkingDetailPageViewController * talkingDV = [[TalkingDetailPageViewController alloc] init];
    talkingDV.talking = _dataArr[indexPath.row];
    
    [self.parentViewController.navigationController pushViewController:talkingDV animated:YES];
}
@end
