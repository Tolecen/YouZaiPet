//
//  SquareViewController.m
//  TalkingPet
//
//  Created by wangxr on 14/11/17.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "SquareViewController.h"
#import "PetalkalkListViewController.h"
#import "MJRefresh.h"
#import "EGOImageView.h"
#import "EGOImageButton.h"
#import "PagedFlowView.h"
#import "SquareListViewController.h"
#import "SquareIteam.h"
#import "PersonProfileViewController.h"
#import "WebContentViewController.h"
#import "TagTalkListViewController.h"
#import "TalkingDetailPageViewController.h"


#define UpdateTime @"WXRUpdateTime"
#define SquareHotPet @"WXRSquareRankPet"
#define SquareIteamStructure @"WXRSquareIteamStructure"

@interface TextCell : UICollectionViewCell
@property (nonatomic,retain) UILabel * label;
@end
@implementation TextCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _label.font = [UIFont systemFontOfSize:15];
        _label.backgroundColor = [UIColor clearColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor colorWithWhite:130/255.0 alpha:1];
        [self.contentView addSubview:_label];
    }
    return self;
}
@end
@interface SquareViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,PagedFlowViewDataSource,PagedFlowViewDelegate>
{
    PagedFlowView*flowView;
//    UIButton * todayTopicB;
//    UILabel * todayTopicL;
//    UIButton * petalkB;
//    UIButton * userB;
//    UIButton * presentB;
    UICollectionView * textCollection;
}
@property (nonatomic,retain)UIView * sameView;
@property (nonatomic,retain)UIView * tagView;
@property (nonatomic,retain)UIView * textView;
@property (nonatomic,retain)NSMutableArray * imageList;
@property (nonatomic,retain)NSMutableArray * textList;
@property (nonatomic,retain)NSMutableArray * picList;
//@property (nonatomic,retain)NSDictionary * todayTopicDic;
@end
@implementation SquareViewController
- (void)viewDidLoad
{
    self.title = @"热门活动";
    [self setBackButtonWithTarget:@selector(goBack)];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-navigationBarHeight-50)];
    self.scrollView.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1];
    self.scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.alwaysBounceVertical = YES;
    [self.scrollView addHeaderWithTarget:self action:@selector(getSquareContent)];
    [self.view addSubview:_scrollView];
    self.sameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.width-10)/3+10)];
    _sameView.backgroundColor = [UIColor whiteColor];
    _sameView.hidden = YES;
    [self.scrollView addSubview:_sameView];
    flowView = [[PagedFlowView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width - 10, (self.view.frame.size.width-10)/3)];
    flowView.delegate = self;
    flowView.dataSource = self;
    [_sameView addSubview:flowView];
    UIPageControl * page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.width-10)/3-20, self.view.frame.size.width, 20)];
    page.currentPageIndicatorTintColor = [UIColor colorWithRed:135/255.0 green:130/255.0 blue:250/255.0 alpha:1];
    page.pageIndicatorTintColor = [UIColor colorWithWhite:200/255.0 alpha:1];
    flowView.pageControl = page;
    [flowView addSubview:page];
    
    self.tagView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    _tagView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:_tagView];
    UILabel * tagL = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, self.view.frame.size.width-20, 30)];
    tagL.text = @"热门活动";
    tagL.font = [UIFont systemFontOfSize:22];
    tagL.textColor = [UIColor redColor];
    [_tagView addSubview:tagL];
    
    self.textView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_tagView.frame)+18, self.view.frame.size.width, 50)];
    _textView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:_textView];
    UILabel * textL = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, self.view.frame.size.width-20, 30)];
    textL.text = @"热门话题";
    textL.font = [UIFont systemFontOfSize:22];
    textL.textColor = [UIColor redColor];
    [_textView addSubview:textL];
    
    UICollectionViewFlowLayout* textLayout = [[UICollectionViewFlowLayout alloc]init];
    textLayout.itemSize = CGSizeMake((self.view.frame.size.width-11)/2,30);
    textLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    textLayout.minimumLineSpacing = 1;
    textLayout.minimumInteritemSpacing = 1;
    textCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 50, self.view.frame.size.width-10, 0) collectionViewLayout:textLayout];
    textCollection.delegate = self;
    textCollection.dataSource = self;
    textCollection.scrollsToTop = NO;
    textCollection.bounces = NO;
    textCollection.backgroundColor = [UIColor clearColor];
    [_textView addSubview:textCollection];
    textCollection.showsHorizontalScrollIndicator = NO;
    [textCollection registerClass:[TextCell class] forCellWithReuseIdentifier:@"textCell"];
    textCollection.showsVerticalScrollIndicator = NO;
    [self buildViewWithUserDefaults];
    [self getSquareContent];
}
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)endRefreshing
{
    [self.scrollView headerEndRefreshing];
}
- (void)beginRefreshing
{
    [self.scrollView headerBeginRefreshing];
}
- (void)buildViewWithUserDefaults
{
//    self.todayTopicDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"WXRTodayTopic"];
//    todayTopicL.text = _todayTopicDic[@"content"];
    self.imageList = [NSMutableArray array];
    self.textList = [NSMutableArray array];
    self.picList = [NSMutableArray array];
    for (NSDictionary * dic in [[NSUserDefaults standardUserDefaults] objectForKey:SquareIteamStructure]) {
        SquareIteam * iteam = [[SquareIteam alloc] init];
        iteam.handleType = dic[@"handleType"];
        iteam.iconUrl = dic[@"iconUrl"];
        iteam.title = dic[@"title"];
        iteam.key = dic[@"key"];
        if ([dic[@"displayType"] integerValue] == 2) {
            [_imageList addObject:iteam];
        }
        if ([dic[@"displayType"] integerValue] == 3) {
            [_textList addObject:iteam];
        }
        if ([dic[@"displayType"] integerValue] == 4) {
            [_picList addObject:iteam];
        }
    }
}
- (void)getSquareContent
{
    NSMutableDictionary* updateDict = [NetServer commonDict];
    [updateDict setObject:@"layout" forKey:@"command"];
    [updateDict setObject:@"intro" forKey:@"options"];
    [updateDict setObject:@"1" forKey:@"code"];
    [NetServer requestWithParameters:updateDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString * updateTime = [responseObject[@"value"] objectForKey:@"updateTime"];
        if ([updateTime doubleValue] != [[[NSUserDefaults standardUserDefaults] objectForKey:UpdateTime] doubleValue]) {
            NSMutableDictionary* square = [NetServer commonDict];
            [square setObject:@"layout" forKey:@"command"];
            [square setObject:@"datum" forKey:@"options"];
            [square setObject:@"1" forKey:@"code"];
            [NetServer requestWithParameters:square success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [[NSUserDefaults standardUserDefaults] setObject:updateTime forKey:UpdateTime];
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"value"] forKey:SquareIteamStructure];
                self.imageList = [NSMutableArray array];
                self.textList = [NSMutableArray array];
                self.picList = [NSMutableArray array];
                for (NSDictionary * dic in responseObject[@"value"]) {
                    SquareIteam * iteam = [[SquareIteam alloc] init];
                    iteam.handleType = dic[@"handleType"];
                    iteam.iconUrl = dic[@"iconUrl"];
                    iteam.title = dic[@"title"];
                    iteam.key = dic[@"key"];
                    if ([dic[@"displayType"] integerValue] == 2) {
                        [_imageList addObject:iteam];
                    }
                    if ([dic[@"displayType"] integerValue] == 3) {
                        [_textList addObject:iteam];
                    }
                    if ([dic[@"displayType"] integerValue] == 4) {
                        [_picList addObject:iteam];
                    }
                }
                [self reBuildSquareView];
                [textCollection reloadData];
                [self endRefreshing];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self reBuildSquareView];
                [textCollection reloadData];
                [self endRefreshing];
            }];
        }
        else{
            [textCollection reloadData];
            [self reBuildSquareView];
            [self endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self reBuildSquareView];
        [textCollection reloadData];
        [self endRefreshing];
    }];
}
- (void)reBuildSquareView
{
    for (UIView * view in [_tagView subviews]) {
        if ([view isKindOfClass:[EGOImageButton class]]) {
            [view removeFromSuperview];
        }
    }
    if (_picList.count) {
        _sameView.hidden = NO;
        [flowView reloadData];
        _tagView.frame = CGRectMake(0, CGRectGetMaxY(_sameView.frame)+18, self.view.frame.size.width, 50);
        _textView.frame = CGRectMake(0, CGRectGetMaxY(_tagView.frame)+18, self.view.frame.size.width, 50);
        
    }else
    {
        _sameView.hidden = YES;
        _tagView.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
        _textView.frame = CGRectMake(0, CGRectGetMaxY(_tagView.frame)+18, self.view.frame.size.width, 50);
    }
    for (int i = 0; i<[_imageList count]; i++) {
        EGOImageButton * button = [EGOImageButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
        button.imageURL = [NSURL URLWithString:((SquareIteam *)_imageList[i]).iconUrl];
        button.tag = 100+i;
        [button addTarget:self action:@selector(tagButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        switch (i) {
            case 0:{
                button.frame = CGRectMake(5, 50, (self.view.frame.size.width-10), (self.view.frame.size.width-10)/3);
            }break;
            case 1:{
                button.frame = CGRectMake(5, (self.view.frame.size.width-10)/3+55, (self.view.frame.size.width-20)/3, (self.view.frame.size.width-20)/3);
            }break;
            case 2:{
                button.frame = CGRectMake(10 + (self.view.frame.size.width-20)/3, (self.view.frame.size.width-10)/3+55, (self.view.frame.size.width-20)/3, (self.view.frame.size.width-20)/3);
            }break;
            case 3:{
                button.frame = CGRectMake(15+(self.view.frame.size.width-20)*2/3, (self.view.frame.size.width-10)/3+55, (self.view.frame.size.width-20)/3, (self.view.frame.size.width-20)/3);
            }break;
            case 4:{
                button.frame = CGRectMake(5, (self.view.frame.size.width-10)/3+60+(self.view.frame.size.width-20)/3, (self.view.frame.size.width-20)*2/3+5, (self.view.frame.size.width-20)*2/3+5);
            }break;
            case 5:{
                button.frame = CGRectMake((self.view.frame.size.width-20)*2/3+15, (self.view.frame.size.width-10)/3+60+(self.view.frame.size.width-20)/3, (self.view.frame.size.width-20)/3, (self.view.frame.size.width-20)/3);
            }break;
            case 6:{
                button.frame = CGRectMake((self.view.frame.size.width-20)*2/3+15, (self.view.frame.size.width-10)/3+65+(self.view.frame.size.width-20)*2/3, (self.view.frame.size.width-20)/3, (self.view.frame.size.width-20)/3);
            }break;
            case 7:{
                button.frame = CGRectMake(5, (self.view.frame.size.width-10)/3+70+(self.view.frame.size.width-20), (self.view.frame.size.width-10), (self.view.frame.size.width-10)/3);
            }break;
            case 8:{
                button.frame = CGRectMake(5, (self.view.frame.size.width-10)*2/3+75+(self.view.frame.size.width-20), (self.view.frame.size.width-20)/3, (self.view.frame.size.width-20)/3);
            }break;
            case 9:{
                button.frame = CGRectMake(10+(self.view.frame.size.width-20)/3, (self.view.frame.size.width-10)*2/3+75+(self.view.frame.size.width-20), (self.view.frame.size.width-20)*2/3+5, (self.view.frame.size.width-20)/3);
            }break;
            case 10:{
                button.frame = CGRectMake(5, (self.view.frame.size.width-10)*2/3+80+(self.view.frame.size.width-20)*4/3, (self.view.frame.size.width-20)/3, (self.view.frame.size.width-20)/3);
            }break;
            case 11:{
                button.frame = CGRectMake(5, (self.view.frame.size.width-10)*2/3+85+(self.view.frame.size.width-20)*5/3, (self.view.frame.size.width-20)/3, (self.view.frame.size.width-20)/3);
            }break;
            case 12:{
                button.frame = CGRectMake(10+(self.view.frame.size.width-20)/3, (self.view.frame.size.width-10)*2/3+80+(self.view.frame.size.width-20)*4/3, (self.view.frame.size.width-20)*2/3+5, (self.view.frame.size.width-20)*2/3+5);
            }break;
            default:{
                button.frame = CGRectMake(5, (self.view.frame.size.width-10)*2/3+90+(self.view.frame.size.width-20)*2+(i-13)*((self.view.frame.size.width-10)/3+5), (self.view.frame.size.width-10), (self.view.frame.size.width-10)/3);
            }break;
        }
        [_tagView addSubview:button];
    }
    switch (_imageList.count) {
        case 0:{
            _tagView.frame = CGRectMake(0, _tagView.frame.origin.y, self.view.frame.size.width, 50);
        }break;
        case 1:{
            _tagView.frame = CGRectMake(0, _tagView.frame.origin.y, self.view.frame.size.width, 50+(self.view.frame.size.width-10)/3+10);
        }break;
        case 2:
        case 3:
        case 4:{
            _tagView.frame = CGRectMake(0, _tagView.frame.origin.y, self.view.frame.size.width, 50+(self.view.frame.size.width-10)/3+(self.view.frame.size.width-20)/3+15);
        }break;
        case 5:
        case 6:
        case 7:{
            _tagView.frame = CGRectMake(0, _tagView.frame.origin.y, self.view.frame.size.width, 50+(self.view.frame.size.width-10)/3+(self.view.frame.size.width-20)+25);
        }break;
        case 8:{
            _tagView.frame = CGRectMake(0, _tagView.frame.origin.y, self.view.frame.size.width, 50+(self.view.frame.size.width-10)*2/3+(self.view.frame.size.width-20)+30);
        }break;
        case 9:
        case 10:{
            _tagView.frame = CGRectMake(0, _tagView.frame.origin.y, self.view.frame.size.width, 50+(self.view.frame.size.width-10)+(self.view.frame.size.width-20)+30);
        }break;
        case 11:{
            _tagView.frame = CGRectMake(0, _tagView.frame.origin.y, self.view.frame.size.width, 50+(self.view.frame.size.width-10)*2/3+(self.view.frame.size.width-20)*5/3+35);
        }break;
        case 12:
        case 13:{
            _tagView.frame = CGRectMake(0, _tagView.frame.origin.y, self.view.frame.size.width, 50+(self.view.frame.size.width-10)*2/3+(self.view.frame.size.width-20)*2+40);
        }break;
        default:{
            _tagView.frame = CGRectMake(0, _tagView.frame.origin.y, self.view.frame.size.width, 50+(self.view.frame.size.width-10)*2/3+(self.view.frame.size.width-20)*2+40+(self.view.frame.size.width-10)/3*(_imageList.count-13)+5*(_imageList.count-13));
        }break;
    }
    textCollection.frame = CGRectMake(5, 50, self.view.frame.size.width-10,ceilf(_textList.count/2.0)*31);
    _textView.frame = CGRectMake(0, CGRectGetMaxY(_tagView.frame)+18, self.view.frame.size.width, 50+textCollection.frame.size.height+10);
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(_textView.frame)+20);
}

-(void)tagButtonTouched:(UIButton*)button
{
    SquareIteam * iteam = nil;
    if (button.tag<200) {
        iteam = _imageList[button.tag-100];
    }else
    {
        iteam = _picList[button.tag-200];
    }
    [self actionSquareIteam:iteam];
}
-(void)actionSquareIteam:(SquareIteam*)iteam
{
    [SquareListViewController actionTheSquareIteam:iteam withNavigationController:self.navigationController];
}
#pragma mark - UICollectionView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SquareIteam * iteam = _textList[indexPath.row];
    [self actionSquareIteam:iteam];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _textList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SectionCellIdentifier = @"textCell";
    TextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SectionCellIdentifier forIndexPath:indexPath];
    SquareIteam * iteam = _textList[indexPath.row];
    cell.label.text = iteam.title;
    return cell;
}
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView
{
    return CGSizeMake(self.view.frame.size.width-10, (self.view.frame.size.width-10)/3);
}
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView
{
    if (_picList.count) {
        return _picList.count;
    }
    return 1;
}
- (UIView *)flowView:(PagedFlowView *)myflowView cellForPageAtIndex:(NSInteger)index
{
    if (!_picList.count) {
        return [[UIView alloc]init];
    }
    EGOImageButton * imageV = (EGOImageButton*)[myflowView dequeueReusableCell];
    if (!imageV) {
        imageV = [[EGOImageButton alloc] init];
    }
    imageV.tag = 200+index;
    [imageV addTarget:self action:@selector(tagButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    imageV.imageURL = [NSURL URLWithString:((SquareIteam*)_picList[index]).iconUrl];
    return imageV;
}
@end
