//
//  SquareNewViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/7/1.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "SquareNewViewController.h"
#import "MJRefresh.h"
#import "TuijianTagTableViewCell.h"
#import "SquareViewController.h"
#import "RankingViewController.h"
#import "PrizeListViewController.h"
#import "PetRankingViewController.h"
#import "RootViewController.h"
#import "InteractionBarViewController.h"
#import "SquareListViewController.h"
@interface TextCell2 : UICollectionViewCell
@property (nonatomic,retain) UILabel * label;
@end
@implementation TextCell2
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

@interface SquareNewViewController ()<PagedFlowViewDataSource,PagedFlowViewDelegate>
{
    PagedFlowView*flowView;
    float forthTableVH;
}
@property (nonatomic,retain)UIView * sameView;
@property (nonatomic,strong)UIView * middleView;
@property (nonatomic,strong)NSArray * topAdArray;
@property (nonatomic,retain)NSDictionary * todayTopicDic;
@property (nonatomic,retain)NSMutableArray * gudinggcArray;//友仔固定6个频道
@end

@implementation SquareNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tuijianArray = [NSMutableArray array];
    self.hotTagArray = [NSMutableArray array];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1];
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView addHeaderWithTarget:self action:@selector(beginRefreshing)];
    [self.view addSubview:_scrollView];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, 1300);
    
    self.sameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.width)/2)];
    _sameView.backgroundColor = [UIColor whiteColor];
//    _sameView.hidden = YES;
    [self.scrollView addSubview:_sameView];
    
    
    
    /*
    self.firstV = [[UIView alloc] initWithFrame:CGRectMake(10, 10+self.sameView.frame.size.height+10, ScreenWidth-20, (ScreenWidth-20)/3.0f)];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoTodayTopic)];
    [_firstV addGestureRecognizer:tap];
    self.firstV.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.firstV];
    
    UIImageView * firstIconV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 32, 32)];
    [firstIconV setImage:[UIImage imageNamed:@"meirihuati"]];
    [self.firstV addSubview:firstIconV];
    
    UILabel * t = [[UILabel alloc] initWithFrame:CGRectMake(52, 10, 100, 32)];
    t.backgroundColor = [UIColor clearColor];
    t.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    t.font = [UIFont systemFontOfSize:18];
    t.text = @"每日话题";
    [self.firstV addSubview:t];
     
     */
    
  
    flowView = [[PagedFlowView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.width)/2)];
    flowView.delegate = self;
    flowView.dataSource = self;
    [_sameView addSubview:flowView];
    UIPageControl * page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.width)/2-20, self.view.frame.size.width, 20)];
    page.currentPageIndicatorTintColor = [UIColor colorWithRed:135/255.0 green:130/255.0 blue:250/255.0 alpha:1];
    page.pageIndicatorTintColor = [UIColor colorWithWhite:200/255.0 alpha:1];
    flowView.pageControl = page;
    [flowView addSubview:page];
    
    [self addGuangChangView];
    
    
    [self makeSquareItem];
    
    
    /*
    self.topicImageV = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 52, (self.firstV.frame.size.height-10-32-10-10)*5/3, self.firstV.frame.size.height-10-32-10-10)];
    [self.topicImageV setBackgroundColor:[UIColor colorWithWhite:240/255.0f alpha:1]];
    [self.firstV addSubview:self.topicImageV];
    
    self.topicTitleL = [[UILabel alloc] initWithFrame:CGRectMake(10+self.topicImageV.frame.size.width+10, 52, ScreenWidth-20-(10+self.topicImageV.frame.size.width+10+10), 20)];
    self.topicTitleL.backgroundColor = [UIColor clearColor];
    self.topicTitleL.numberOfLines = 0;
    self.topicTitleL.lineBreakMode = NSLineBreakByCharWrapping;
    self.topicTitleL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    self.topicTitleL.font = [UIFont systemFontOfSize:14];
    [self.firstV addSubview:self.topicTitleL];
    self.topicTitleL.text = @"加载今日话题ing...";
    
    self.topicDiscussNumL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-20-10-120, self.firstV.frame.size.height-30, 120, 20)];
    self.topicDiscussNumL.backgroundColor = [UIColor clearColor];
    self.topicDiscussNumL.font = [UIFont systemFontOfSize:12];
    self.topicDiscussNumL.adjustsFontSizeToFitWidth = YES;
    self.topicDiscussNumL.textColor = [UIColor colorWithWhite:160/255.0f alpha:1];
    self.topicDiscussNumL.textAlignment = NSTextAlignmentRight;
    [self.firstV addSubview:self.topicDiscussNumL];
    self.topicDiscussNumL.text = @"加载讨论人数ing...";
    
    
    self.secondV = [[UIView alloc] initWithFrame:CGRectMake(10, self.firstV.frame.size.height+self.firstV.frame.origin.y+10, ScreenWidth-20, 157)];
    self.secondV.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.secondV];
    
    UIImageView * secondIconV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 34, 30)];
    [secondIconV setImage:[UIImage imageNamed:@"paihangbang"]];
    [self.secondV addSubview:secondIconV];
    
    UILabel * t2 = [[UILabel alloc] initWithFrame:CGRectMake(52, 10, 100, 32)];
    t2.backgroundColor = [UIColor clearColor];
    t2.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    t2.font = [UIFont systemFontOfSize:18];
    t2.text = @"最火排行榜";
    [self.secondV addSubview:t2];
    
    UIButton * paihang1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [paihang1 setFrame:CGRectMake((ScreenWidth-20)/2/2-30, 42+15, 60, 60)];
    [paihang1 setImage:[UIImage imageNamed:@"shuoshuopaihang"] forState:UIControlStateNormal];
    [self.secondV addSubview:paihang1];
    [paihang1 addTarget:self action:@selector(toShuoshuoPaihangPage) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * paihangL1 = [[UILabel alloc] initWithFrame:CGRectMake(paihang1.frame.origin.x, 42+15+60+10, 60, 20)];
    paihangL1.backgroundColor = [UIColor clearColor];
    paihangL1.text = @"说说排行";
    paihangL1.adjustsFontSizeToFitWidth = YES;
    paihangL1.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    paihangL1.textAlignment = NSTextAlignmentCenter;
    paihangL1.font = [UIFont systemFontOfSize:14];
    [self.secondV addSubview:paihangL1];
    
    UIButton * paihang2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [paihang2 setFrame:CGRectMake((ScreenWidth-20)/2+(ScreenWidth-20)/2/2-30, 42+15, 60, 60)];
    [paihang2 setImage:[UIImage imageNamed:@"mengchongpaihang"] forState:UIControlStateNormal];
    [self.secondV addSubview:paihang2];
    [paihang2 addTarget:self action:@selector(toPetPaihangPage) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * paihangL2 = [[UILabel alloc] initWithFrame:CGRectMake(paihang2.frame.origin.x, 42+15+60+10, 60, 20)];
    paihangL2.backgroundColor = [UIColor clearColor];
    paihangL2.text = @"萌宠排行";
    paihangL2.adjustsFontSizeToFitWidth = YES;
    paihangL2.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    paihangL2.textAlignment = NSTextAlignmentCenter;
    paihangL2.font = [UIFont systemFontOfSize:14];
    [self.secondV addSubview:paihangL2];
    
//    UIButton * paihang3 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [paihang3 setFrame:CGRectMake(ScreenWidth-20-30-60, 42+15, 60, 60)];
//    [paihang3 setImage:[UIImage imageNamed:@"dashangpaihang"] forState:UIControlStateNormal];
//    [self.secondV addSubview:paihang3];
//    [paihang3 addTarget:self action:@selector(toShangPaihangPage) forControlEvents:UIControlEventTouchUpInside];
//    
//    UILabel * paihangL3 = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-20-30-60, 42+15+60+10, 60, 20)];
//    paihangL3.backgroundColor = [UIColor clearColor];
//    paihangL3.text = @"打赏排行";
//    paihangL3.adjustsFontSizeToFitWidth = YES;
//    paihangL3.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
//    paihangL3.textAlignment = NSTextAlignmentCenter;
//    paihangL3.font = [UIFont systemFontOfSize:14];
//    [self.secondV addSubview:paihangL3];
    
    
    self.thirdV = [[UIView alloc] initWithFrame:CGRectMake(10, self.secondV.frame.size.height+self.secondV.frame.origin.y+10, ScreenWidth-20, 87)];
    self.thirdV.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.thirdV];

//    UIButton * libtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [libtn setFrame:CGRectMake(0, 0, (ScreenWidth-20-10)/2, 87)];
//    [libtn setBackgroundColor:[UIColor whiteColor]];
//    [self.thirdV addSubview:libtn];
//    [libtn addTarget:self action:@selector(toLiWuPage) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIImageView * liimagev = [[UIImageView alloc] initWithFrame:CGRectMake(libtn.frame.size.width/2-16, 15, 32, 32)];
//    [liimagev setImage:[UIImage imageNamed:@"haojiang"]];
//    [libtn addSubview:liimagev];
//    
//    UILabel * liL = [[UILabel alloc] initWithFrame:CGRectMake(0, 15+32+10, libtn.frame.size.width, 20)];
//    liL.backgroundColor = [UIColor clearColor];
//    liL.textAlignment = NSTextAlignmentCenter;
//    liL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
//    liL.font = [UIFont systemFontOfSize:14];
//    liL.text = @"好礼奖不停";
//    [libtn addSubview:liL];
//    
//    UIButton * actbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [actbtn setFrame:CGRectMake((ScreenWidth-20-10)/2+10, 0, (ScreenWidth-20-10)/2, 87)];
//    [actbtn setBackgroundColor:[UIColor whiteColor]];
//    [self.thirdV addSubview:actbtn];
//    [actbtn addTarget:self action:@selector(toTagPage) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIImageView * actimagev = [[UIImageView alloc] initWithFrame:CGRectMake(libtn.frame.size.width/2-16, 15, 32, 32)];
//    [actimagev setImage:[UIImage imageNamed:@"remenhuodong"]];
//    [actbtn addSubview:actimagev];
//    
//    UILabel * actL = [[UILabel alloc] initWithFrame:CGRectMake(0, 15+32+10, libtn.frame.size.width, 20)];
//    actL.backgroundColor = [UIColor clearColor];
//    actL.textAlignment = NSTextAlignmentCenter;
//    actL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
//    actL.font = [UIFont systemFontOfSize:14];
//    actL.text = @"热门活动";
//    [actbtn addSubview:actL];
    
    self.thirdV_part1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.thirdV.frame.size.width,42+10+(ScreenWidth-40)/3+10+(ScreenWidth-40-20)/3+10)];
    self.thirdV_part1.backgroundColor = [UIColor whiteColor];
    [self.thirdV addSubview:self.thirdV_part1];
    
    UIImageView * t1i = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 32, 32)];
    [t1i setImage:[UIImage imageNamed:@"remenhuodong"]];
    [self.thirdV_part1 addSubview:t1i];
    
    UILabel * t1l = [[UILabel alloc] initWithFrame:CGRectMake(52, 10, 100, 32)];
    t1l.backgroundColor = [UIColor clearColor];
    t1l.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    t1l.font = [UIFont systemFontOfSize:18];
    t1l.text = @"热门活动";
    [self.thirdV_part1 addSubview:t1l];
    
    EGOImageButton * tt1 = [[EGOImageButton alloc] initWithFrame:CGRectMake(10, 42+10, ScreenWidth-40, (ScreenWidth-40)/3)];
    tt1.tag = 1;
    tt1.backgroundColor = [UIColor colorWithWhite:240/255.0F alpha:1];
    [self.thirdV_part1 addSubview:tt1];
    [tt1 addTarget:self action:@selector(towhichActPage:) forControlEvents:UIControlEventTouchUpInside];
    EGOImageButton * tt2 = [[EGOImageButton alloc] initWithFrame:CGRectMake(10, (ScreenWidth-40)/3+42+10+10, (ScreenWidth-40-20)/3, (ScreenWidth-40-20)/3)];
    tt2.tag = 2;
    tt2.backgroundColor = [UIColor colorWithWhite:240/255.0F alpha:1];
    [self.thirdV_part1 addSubview:tt2];
    [tt2 addTarget:self action:@selector(towhichActPage:) forControlEvents:UIControlEventTouchUpInside];
    EGOImageButton * tt3 = [[EGOImageButton alloc] initWithFrame:CGRectMake(10+(ScreenWidth-40-20)/3+10, (ScreenWidth-40)/3+42+10+10, (ScreenWidth-40-20)/3, (ScreenWidth-40-20)/3)];
    tt3.tag = 3;
    tt3.backgroundColor = [UIColor colorWithWhite:240/255.0F alpha:1];
    [self.thirdV_part1 addSubview:tt3];
    [tt3 addTarget:self action:@selector(towhichActPage:) forControlEvents:UIControlEventTouchUpInside];
    EGOImageButton * tt4 = [[EGOImageButton alloc] initWithFrame:CGRectMake(10+((ScreenWidth-40-20)/3)*2+10+10, (ScreenWidth-40)/3+42+10+10, (ScreenWidth-40-20)/3, (ScreenWidth-40-20)/3)];
    [tt4 setImage:[UIImage imageNamed:@"moreactive"] forState:UIControlStateNormal];
    [self.thirdV_part1 addSubview:tt4];
    [tt4 addTarget:self action:@selector(toTagPage) forControlEvents:UIControlEventTouchUpInside];
    
    self.thirdV_part2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.thirdV_part1.frame.size.height+self.thirdV_part1.frame.origin.y+10, self.thirdV.frame.size.width,42+10+(ScreenWidth-40)/3+10)];
    self.thirdV_part2.backgroundColor = [UIColor whiteColor];
    [self.thirdV addSubview:self.thirdV_part2];
    
    UIImageView * t2i = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 32, 32)];
    [t2i setImage:[UIImage imageNamed:@"haojiang"]];
    [self.thirdV_part2 addSubview:t2i];
    
    UILabel * t2l = [[UILabel alloc] initWithFrame:CGRectMake(52, 10, 100, 32)];
    t2l.backgroundColor = [UIColor clearColor];
    t2l.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    t2l.font = [UIFont systemFontOfSize:18];
    t2l.text = @"好礼奖不停";
    [self.thirdV_part2 addSubview:t2l];
    
    EGOImageButton * ll1 = [[EGOImageButton alloc] initWithFrame:CGRectMake(10, 42+10, ScreenWidth-40, (ScreenWidth-40)/3)];
    ll1.tag = 1;
    ll1.backgroundColor = [UIColor colorWithWhite:240/255.0F alpha:1];
    [self.thirdV_part2 addSubview:ll1];
    [ll1 addTarget:self action:@selector(toLiWuPage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.thirdV setFrame:CGRectMake(self.thirdV.frame.origin.x, self.thirdV.frame.origin.y, self.thirdV.frame.size.width, self.thirdV_part2.frame.size.height+self.thirdV_part2.frame.origin.y)];
    
    float imgH = (ScreenWidth-60)/3.0f;
 
    forthTableVH = (52+imgH+10+10)*self.tuijianArray.count;
    self.forthTV = [[UITableView alloc] initWithFrame:CGRectMake(0, self.thirdV.frame.size.height+self.thirdV.frame.origin.y, ScreenWidth, forthTableVH) style:UITableViewStylePlain];
    self.forthTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.forthTV.backgroundColor = [UIColor clearColor];
    self.forthTV.backgroundView = nil;
    self.forthTV.delegate = self;
    self.forthTV.dataSource = self;
    self.forthTV.scrollEnabled = NO;
    self.forthTV.scrollsToTop = NO;
    [self.scrollView addSubview:self.forthTV];
    
    
    self.textView = [[UIView alloc]initWithFrame:CGRectMake(10, self.forthTV.frame.origin.y+self.forthTV.frame.size.height+10, self.view.frame.size.width-20, 50)];
    _textView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:_textView];
    
    UIImageView * fifthIconV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 32, 32)];
    [fifthIconV setImage:[UIImage imageNamed:@"biaoqian"]];
    [_textView addSubview:fifthIconV];
    
    UILabel * textL = [[UILabel alloc] initWithFrame:CGRectMake(52, 10, 100, 32)];
    textL.text = @"精华标签";
    textL.font = [UIFont systemFontOfSize:18];
    textL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    [_textView addSubview:textL];
    
    UICollectionViewFlowLayout* textLayout = [[UICollectionViewFlowLayout alloc]init];
    textLayout.itemSize = CGSizeMake((self.view.frame.size.width-22)/2,30);
    textLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    textLayout.minimumLineSpacing = 1;
    textLayout.minimumInteritemSpacing = 1;
    self.textCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width-20, 0) collectionViewLayout:textLayout];
    self.textCollection.delegate = self;
    self.textCollection.dataSource = self;
    self.textCollection.scrollsToTop = NO;
    self.textCollection.bounces = NO;
    self.textCollection.backgroundColor = [UIColor clearColor];
    [_textView addSubview:self.textCollection];
    self.textCollection.showsHorizontalScrollIndicator = NO;
    [self.textCollection registerClass:[TextCell2 class] forCellWithReuseIdentifier:@"textCell2"];
    self.textCollection.showsVerticalScrollIndicator = NO;

//    int textviewtextCount = 10;
    self.textCollection.frame = CGRectMake(0, 50, self.view.frame.size.width-20,ceilf(self.hotTagArray.count/2.0)*31);
    _textView.frame = CGRectMake(10, self.forthTV.frame.origin.y+self.forthTV.frame.size.height+10, self.view.frame.size.width-20, 50+self.textCollection.frame.size.height+10);
    
    [self getTuijianList];
    [self getTopAd];
    // Do any additional setup after loading the view.
     
     
     
     
     
     */
    
    
    [self getTopAd];
}
-(void)addGuangChangView
{
    self.middleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_sameView.frame), ScreenWidth, 85)];
    self.middleView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.middleView];
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setBackgroundImage:[UIImage imageNamed:@"quanshezhuanfang@2x"] forState:UIControlStateNormal];
    [button1 setFrame:CGRectMake(ScreenWidth/4-20-20, 15, 40, 40)];
    [self.middleView addSubview:button1];
    button1.tag = 1;
    [button1 addTarget:self action:@selector(middleBtnDo:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * bL1 = [[UILabel alloc] initWithFrame:CGRectMake(button1.frame.origin.x-10, CGRectGetMaxY(button1.frame), button1.frame.size.width+20, 20)];
    bL1.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
    bL1.font = [UIFont systemFontOfSize:12];
    bL1.text = @"犬舍专访";
    bL1.textAlignment = NSTextAlignmentCenter;
    [self.middleView addSubview:bL1];
    
    
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setBackgroundImage:[UIImage imageNamed:@"huodongquwen@2x"] forState:UIControlStateNormal];
    [button2 setFrame:CGRectMake(2*(ScreenWidth/4)-20, 15, 40, 40)];
    [self.middleView addSubview:button2];
    button2.tag = 2;
    [button2 addTarget:self action:@selector(middleBtnDo:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * bL2 = [[UILabel alloc] initWithFrame:CGRectMake(button2.frame.origin.x-10, CGRectGetMaxY(button2.frame), button2.frame.size.width+20, 20)];
    bL2.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
    bL2.font = [UIFont systemFontOfSize:12];
    bL2.text = @"活动趣闻";
    bL2.textAlignment = NSTextAlignmentCenter;
    [self.middleView addSubview:bL2];
    
    
    UIButton * button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setBackgroundImage:[UIImage imageNamed:@"xunlianfuwu@2x"] forState:UIControlStateNormal];
    [button3 setFrame:CGRectMake(3*(ScreenWidth/4)-20+20, 15, 40, 40)];
    [self.middleView addSubview:button3];
    button3.tag = 3;
    [button3 addTarget:self action:@selector(middleBtnDo:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * bL3 = [[UILabel alloc] initWithFrame:CGRectMake(button3.frame.origin.x-10, CGRectGetMaxY(button3.frame), button3.frame.size.width+20, 20)];
    bL3.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
    bL3.font = [UIFont systemFontOfSize:12];
    bL3.text = @"训练服务";
    bL3.textAlignment = NSTextAlignmentCenter;
    [self.middleView addSubview:bL3];
    
    float h = ScreenWidth * 0.4;
    for (int i = 0; i<3; i++) {
        EGOImageButton * guangchangbottomv = [[EGOImageButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.middleView.frame)+10*(i+1)+h*i, ScreenWidth, h)];
        [guangchangbottomv setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"guangchang0%d",i+1]] forState:UIControlStateNormal];
        guangchangbottomv.tag = 4+i;
        [self.scrollView addSubview:guangchangbottomv];
        [guangchangbottomv addTarget:self action:@selector(middleBtnDo:) forControlEvents:UIControlEventTouchUpInside];
        self.scrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(guangchangbottomv.frame)+10);
    }
    
    
    
}
-(void)middleBtnDo:(UIButton *)sender
{
    NSInteger index = sender.tag;
    [SquareListViewController actionTheSquareIteam:self.gudinggcArray[index-1] withNavigationController:self.navigationController];
}
-(void)getTopAd
{
//    NSMutableArray * da = [NSMutableArray array];
//    for (int i = 0;i<2 ;i++) {
//
//            SquareIteam * iteam = [[SquareIteam alloc] init];
//            iteam.handleType = @"";
//            iteam.iconUrl = @"http://xlimage.uzero.cn/dacfd675c59f9c9bc5021f84e64d5ff7.jpg";
//            iteam.title = @"";
//            iteam.key = @"";
//            [da addObject:iteam];
//
//        
//    }
//    self.topAdArray = da;
//    [flowView reloadData];
//    
//    
//    return;

    NSMutableDictionary* updateDict = [NetServer commonDict];
    [updateDict setObject:@"layout" forKey:@"command"];
    [updateDict setObject:@"datum" forKey:@"options"];
    [updateDict setObject:@"1" forKey:@"code"];
    [NetServer requestWithParameters:updateDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"GGGGGGGGGG:%@",responseObject);
        NSMutableArray * da = [NSMutableArray array];
        for (NSDictionary * dic in responseObject[@"value"]) {
            if ([dic[@"displayType"] isEqualToString:@"4"]) {
                SquareIteam * iteam = [[SquareIteam alloc] init];
                iteam.handleType = dic[@"handleType"];
                iteam.iconUrl = dic[@"iconUrl"];
                iteam.title = dic[@"title"];
                iteam.key = dic[@"key"];
                [da addObject:iteam];
            }

        }
        self.topAdArray = da;
        [flowView reloadData];
         [self.scrollView headerEndRefreshing];
        //        [self setHeaderArray:[responseObject objectForKey:@"value"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.scrollView headerEndRefreshing];
    }];
    
}
- (void)getTuijianList
{
    NSMutableDictionary* updateDict = [NetServer commonDict];
    [updateDict setObject:@"petalk" forKey:@"command"];
    [updateDict setObject:@"topTagHotList" forKey:@"options"];
//    [updateDict setObject:@"1" forKey:@"code"];
    [NetServer requestWithParameters:updateDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray * g = [responseObject objectForKey:@"value"];
        NSMutableArray * ff = [NSMutableArray array];
        for (int i = 0; i<g.count; i++) {
            NSMutableDictionary * h = [NSMutableDictionary dictionaryWithDictionary:g[i]];
            
            NSArray * talks = [h objectForKey:@"petalks"];
            [h setObject:[self getModelArray:talks] forKey:@"petalks"];
            [ff addObject:h];
        }
        self.tuijianArray = ff;
        forthTableVH = ((ScreenWidth-60)/3.0f+52+10+10)*self.tuijianArray.count;
        [self resetViewsPosition];
        [self.forthTV reloadData];
        [self gethotTag];
        [self.scrollView headerEndRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self gethotTag];
        [self.scrollView headerEndRefreshing];
    }];
}
-(void)gethotTag
{
    NSMutableDictionary* updateDict = [NetServer commonDict];
    [updateDict setObject:@"tag" forKey:@"command"];
    [updateDict setObject:@"hot" forKey:@"options"];
    //    [updateDict setObject:@"1" forKey:@"code"];
    [NetServer requestWithParameters:updateDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.hotTagArray = [responseObject objectForKey:@"value"];
        [self resetViewsPosition];
        [self.textCollection reloadData];
        [self getTopTopic];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self getTopTopic];
    }];
}
-(void)getTopTopic
{
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"topic" forKey:@"command"];
    [usersDict setObject:@"topOne" forKey:@"options"];
    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.todayTopicDic = @{@"content":[responseObject[@"value"] objectForKey:@"content"],
                               @"pic":[responseObject[@"value"] objectForKey:@"pic"],
                               @"id":[responseObject[@"value"] objectForKey:@"id"],
                               @"viewCount":[responseObject[@"value"] objectForKey:@"viewCount"]};
        self.topicTitleL.text = _todayTopicDic[@"content"];
        self.topicImageV.imageURL = [NSURL URLWithString:_todayTopicDic[@"pic"]];
        self.topicDiscussNumL.text = [_todayTopicDic[@"viewCount"] stringByAppendingString:@"浏览"];
        [[NSUserDefaults standardUserDefaults] setObject:_todayTopicDic forKey:@"WXRTodayTopic"];
        [self gethot3];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self gethot3];
    }];

}
-(void)gethot3
{
    NSMutableDictionary* updateDict = [NetServer commonDict];
    [updateDict setObject:@"layout" forKey:@"command"];
    [updateDict setObject:@"top3Hot" forKey:@"options"];
    //    [updateDict setObject:@"1" forKey:@"code"];
    [NetServer requestWithParameters:updateDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray * g = [NSMutableArray array];
        for (NSDictionary * dic in responseObject[@"value"]) {
            SquareIteam * iteam = [[SquareIteam alloc] init];
            iteam.handleType = dic[@"handleType"];
            iteam.iconUrl = dic[@"iconUrl"];
            iteam.title = dic[@"title"];
            iteam.key = dic[@"key"];
            [g addObject:iteam];
        }
        self.hot3Array = g;
//        self.hot3Array = [responseObject objectForKey:@"value"];
        for (int i = 0; i<self.hot3Array.count; i++) {
            EGOImageButton * u = (EGOImageButton *)[self.thirdV_part1 viewWithTag:i+1];
            SquareIteam * iteam = self.hot3Array[i];
            u.imageURL = [NSURL URLWithString:i==0?iteam.iconUrl:[iteam.iconUrl stringByAppendingString:@"?imageView2/2/w/200"]];
        }
        [self getHaoli];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self getHaoli];
    }];
}
-(void)getHaoli
{
    NSMutableDictionary* updateDict = [NetServer commonDict];
    [updateDict setObject:@"layout" forKey:@"command"];
    [updateDict setObject:@"datum" forKey:@"options"];
    [updateDict setObject:@"6" forKey:@"code"];
    [NetServer requestWithParameters:updateDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"value"] count]>0) {
            NSDictionary * dic = [responseObject objectForKey:@"value"][0];
            
            
            EGOImageButton * u = (EGOImageButton *)[self.thirdV_part2 viewWithTag:1];
            u.imageURL = [NSURL URLWithString:dic[@"iconUrl"]];
        }

        //        [self setHeaderArray:[responseObject objectForKey:@"value"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)resetViewsPosition
{
    
    [self.forthTV setFrame:CGRectMake(0, self.thirdV.frame.size.height+self.thirdV.frame.origin.y, ScreenWidth, forthTableVH)];
    self.textCollection.frame = CGRectMake(0, 50, self.view.frame.size.width-20,ceilf(self.hotTagArray.count/2.0)*31);
    _textView.frame = CGRectMake(10, self.forthTV.frame.origin.y+self.forthTV.frame.size.height+10, self.view.frame.size.width-20, 50+self.textCollection.frame.size.height+10);
    [self.scrollView setContentSize:CGSizeMake(ScreenWidth, self.textView.frame.size.height+self.textView.frame.origin.y+10)];
}
-(NSMutableArray *)getModelArray:(NSArray *)array
{
    NSMutableArray * hArray = [NSMutableArray array];
    for (int i = 0; i<array.count; i++) {
        TalkingBrowse * talking = [[TalkingBrowse alloc] initWithSimpleInfo:[array objectAtIndex:i]];
        
        [hArray addObject:talking];
    }
    return hArray;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tuijianArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (ScreenWidth-60)/3.0f+52+10+10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"tuijianListCell";
    TuijianTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[TuijianTagTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.tagDict = self.tuijianArray[indexPath.row];
//    cell.awardDict = self.awardArary[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TagTalkListViewController * tagTlistV = [[TagTalkListViewController alloc] init];
    
    tagTlistV.title = [self.tuijianArray[indexPath.row] objectForKey:@"name"];
    Tag * tag = [[Tag alloc] init];
    tag.tagID = [self.tuijianArray[indexPath.row] objectForKey:@"id"];
    tag.tagName = [self.tuijianArray[indexPath.row] objectForKey:@"name"];
    tagTlistV.tag = tag;
    tagTlistV.shouldRequestTagInfo = YES;
    [self.navigationController pushViewController:tagTlistV animated:YES];
}
- (void)gotoTodayTopic
{
    if (_todayTopicDic) {
        InteractionBarViewController * interBar = [[InteractionBarViewController alloc] init];
        interBar.hideNaviBg = YES;
        interBar.titleStr = [_todayTopicDic objectForKey:@"content"];
        interBar.bgImageUrl = [_todayTopicDic objectForKey:@"pic"];
        interBar.topicId = [_todayTopicDic objectForKey:@"id"];
        [self.navigationController pushViewController:interBar animated:YES];
    }else
    {
        InteractionBarViewController * interBar = [[InteractionBarViewController alloc] init];
        interBar.hideNaviBg = YES;
        interBar.state = 1;
        [self.navigationController pushViewController:interBar animated:YES];
    }
}
-(void)towhichActPage:(EGOImageButton *)sender
{
    SquareIteam * iteam = [self.hot3Array objectAtIndex:sender.tag-1];
    [SquareListViewController actionTheSquareIteam:iteam withNavigationController:self.navigationController];
}
-(void)toLiWuPage
{
    if (![UserServe sharedUserServe].account) {
        [[RootViewController sharedRootViewController] showLoginViewController];
        return;
    }
    PrizeListViewController * prizeVC = [[PrizeListViewController alloc] init];
    prizeVC.squareKey = @"4";
    [self.navigationController pushViewController:prizeVC animated:YES];
}
-(void)toTagPage
{
    SquareViewController * sv = [[SquareViewController alloc] init];
    [self.navigationController pushViewController:sv animated:YES];
}
-(void)toShuoshuoPaihangPage
{
    RankingViewController * rankingVC = [[RankingViewController alloc] init];
    [self.navigationController pushViewController:rankingVC animated:YES];
}
-(void)toPetPaihangPage
{
    PetRankingViewController * rankingVC = [[PetRankingViewController alloc] init];
    [self.navigationController pushViewController:rankingVC animated:YES];
}
-(void)toShangPaihangPage
{
    [SVProgressHUD showErrorWithStatus:@"Developing"];
}

-(void)getSquareContent
{
    //获取每日话题
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"topic" forKey:@"command"];
    [usersDict setObject:@"topOne" forKey:@"options"];
    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.todayTopicDic = @{@"content":[responseObject[@"value"] objectForKey:@"content"],
                               @"pic":[responseObject[@"value"] objectForKey:@"pic"],
                               @"id":[responseObject[@"value"] objectForKey:@"id"]};
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)beginRefreshing
{
//    [self getTuijianList];
    [self getTopAd];
}

#pragma mark - UICollectionView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagTalkListViewController * tagTlistV = [[TagTalkListViewController alloc] init];
    
    tagTlistV.title = [self.hotTagArray[indexPath.row] objectForKey:@"name"];
    Tag * tag = [[Tag alloc] init];
    tag.tagID = [self.hotTagArray[indexPath.row] objectForKey:@"id"];
    tag.tagName = [self.hotTagArray[indexPath.row] objectForKey:@"name"];
    tagTlistV.tag = tag;
    tagTlistV.shouldRequestTagInfo = YES;
    [self.navigationController pushViewController:tagTlistV animated:YES];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.hotTagArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SectionCellIdentifier = @"textCell2";
    TextCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SectionCellIdentifier forIndexPath:indexPath];
//    SquareIteam * iteam = _textList[indexPath.row];
    cell.label.text = [[self.hotTagArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}

- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView
{
    return CGSizeMake(self.view.frame.size.width, (self.view.frame.size.width)/2);
}
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView
{
    if (self.topAdArray.count) {
        return self.topAdArray.count;
    }
    return 1;
}
- (UIView *)flowView:(PagedFlowView *)myflowView cellForPageAtIndex:(NSInteger)index
{
    if (!self.topAdArray.count) {
        return [[UIView alloc]init];
    }
    EGOImageButton * imageV = (EGOImageButton*)[myflowView dequeueReusableCell];
    if (!imageV) {
        imageV = [[EGOImageButton alloc] init];
    }
    imageV.tag = 200+index;
    [imageV addTarget:self action:@selector(tagButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    imageV.imageURL = [NSURL URLWithString:((SquareIteam*)self.topAdArray[index]).iconUrl];
    return imageV;
}

-(void)tagButtonTouched:(UIButton *)sender
{
    SquareIteam * iteam = nil;

    iteam = self.topAdArray[sender.tag-200];
    [SquareListViewController actionTheSquareIteam:iteam withNavigationController:self.navigationController];
}

-(void)makeSquareItem
{
    NSArray * keyArray = @[@"quanshezhuanfang",@"huodongquwen",@"xunlianfuwu",@"shidazuire",@"kuailehuoli",@"zuiqianyan"];
    self.gudinggcArray = [NSMutableArray array];
    for (int i = 0; i<6; i++) {
        SquareIteam * item = [[SquareIteam alloc] init];
        item.handleType = @"3";
        item.title = @"测试";
//        item.key = keyArray[i];
        item.key = @"hot";
        [self.gudinggcArray addObject:item];
    }
    
    
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
