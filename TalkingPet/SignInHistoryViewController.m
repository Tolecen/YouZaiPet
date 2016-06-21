//
//  SignInHistoryViewController.m
//  TalkingPet
//
//  Created by wangxr on 14/12/9.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "SignInHistoryViewController.h"

@interface Calendar : NSObject
@property (nonatomic,retain) NSString * award;
@property (nonatomic,retain) NSString * data;
@property (nonatomic,assign) BOOL sign;
@end
@implementation Calendar

@end
@interface CalendarCell : UICollectionViewCell
@property (nonatomic,retain) UILabel * dayL;
@property (nonatomic,retain) UILabel * mouthL;
@property (nonatomic,retain) UILabel * awardL;
@end
@implementation CalendarCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.clipsToBounds = YES;
        self.dayL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _dayL.backgroundColor = [UIColor clearColor];
        _dayL.font = [UIFont systemFontOfSize:24];
        _dayL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_dayL];
        self.mouthL = [[UILabel alloc] initWithFrame:CGRectMake(5, frame.size.height-20, frame.size.width-10, 20)];
        _mouthL.backgroundColor = [UIColor clearColor];
        _mouthL.textAlignment = NSTextAlignmentRight;
        _mouthL.font = [UIFont systemFontOfSize:12];
        _mouthL.textColor = [UIColor colorWithRed:135/255.0 green:130/255.0 blue:250/255.0 alpha:1];
        [self.contentView addSubview:_mouthL];
        self.awardL = [[UILabel alloc] initWithFrame:CGRectMake(-12, 5, 35*1.414, 15)];
        _awardL.transform = CGAffineTransformRotate(_awardL.transform, -M_PI_4);
        _awardL.backgroundColor= [UIColor colorWithRed:255/255.0 green:255/255.0 blue:154/255.0 alpha:1];
        _awardL.textColor = [UIColor colorWithRed:182/255.0 green:178/255.0 blue:251/255.0 alpha:1];
        _awardL.textAlignment = NSTextAlignmentCenter;
        _awardL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_awardL];
    }
    return self;
}
@end
@interface SignInHistoryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    int size ;
}
@property (nonatomic,retain)UICollectionView * signInHistoryCollectionView;
@property (nonatomic,retain)UILabel * signCountL;
@property (nonatomic,retain)UILabel * futureL;
@property (nonatomic,retain)UILabel * congratulateL;
@property (nonatomic,retain)NSMutableArray * calendarArray;
@end
@implementation SignInHistoryViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButtonWithTarget:@selector(back)];
//    self.view.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    
    self.signInHistoryCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.view.center.x-155, 5, 310, 360) collectionViewLayout:({
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(70,70);
        layout.sectionInset = UIEdgeInsetsMake(40, 13, 40, 13);
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        layout;
    })];
    if (self.view.frame.size.height<500) {
        _signInHistoryCollectionView.frame = CGRectMake(self.view.center.x-155, 5, self.view.frame.size.width-10, 300);
        size = 12;
    }else
    {
        size = 16;
    }
    _signInHistoryCollectionView.bounces = NO;
    _signInHistoryCollectionView.delegate = self;
    _signInHistoryCollectionView.dataSource = self;
    _signInHistoryCollectionView.backgroundColor = [UIColor clearColor];
    [_signInHistoryCollectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"collectionViewCell"];
    _signInHistoryCollectionView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
//    _signInHistoryCollectionView.layer.masksToBounds = YES;
//    _signInHistoryCollectionView.layer.cornerRadius = 5;
    [self.view addSubview:_signInHistoryCollectionView];
    
    if (self.view.frame.size.height>500) {
        UIImageView * maskV = [[UIImageView alloc] initWithFrame:CGRectMake(13, 40, 284, 284)];
        [maskV setImage:[UIImage imageNamed:@"signIn_mask"]];
        [_signInHistoryCollectionView addSubview:maskV];
    }

    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(155-55, 10, 110, 20)];
    imageView.image = [UIImage imageNamed:@"signIn_topbg"];
    [_signInHistoryCollectionView addSubview:imageView];
    
    UIImageView * imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x-20, 12, 15, 15)];
    [imageV1 setImage:[UIImage imageNamed:@"signIn_nicon"]];
    [_signInHistoryCollectionView addSubview:imageV1];
    
    UIImageView * imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+5, 12, 15, 15)];
    [imageV2 setImage:[UIImage imageNamed:@"signIn_nicon"]];
    [_signInHistoryCollectionView addSubview:imageV2];
    
    self.signCountL = [[UILabel alloc] initWithFrame:imageView.frame];
    _signCountL.backgroundColor = [UIColor clearColor];
    _signCountL.font = [UIFont systemFontOfSize:14];
    _signCountL.textAlignment = NSTextAlignmentCenter;
    _signCountL.textColor = [UIColor whiteColor];
    [_signInHistoryCollectionView addSubview:_signCountL];
    
    self.futureL = [[UILabel alloc] initWithFrame:CGRectMake(0, _signInHistoryCollectionView.frame.size.height-30, 310, 20)];
    _futureL.backgroundColor = [UIColor clearColor];
    _futureL.font = [UIFont systemFontOfSize:14];
//    _futureL.shadowColor = [UIColor colorWithWhite:0.3 alpha:0.6];
//    _futureL.shadowOffset = CGSizeMake(2, 2);
    _futureL.textAlignment = NSTextAlignmentCenter;
    _futureL.adjustsFontSizeToFitWidth = YES;
    _futureL.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
    [_signInHistoryCollectionView addSubview:_futureL];
    
    UILabel * secceL = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100 - navigationBarHeight, self.view.frame.size.width - 10, 20)];
    secceL.backgroundColor = [UIColor clearColor];
    secceL.font = [UIFont systemFontOfSize:18];
    secceL.textAlignment = NSTextAlignmentCenter;
    secceL.textColor = [UIColor colorWithRed:182/255.0 green:178/255.0 blue:251/255.0 alpha:1];
    [self.view addSubview:secceL];
    
    self.congratulateL = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 70 - navigationBarHeight, self.view.frame.size.width - 10, 40)];
    _congratulateL.backgroundColor = [UIColor clearColor];
    _congratulateL.font = [UIFont systemFontOfSize:24];
    _congratulateL.textAlignment = NSTextAlignmentCenter;
    _congratulateL.textColor = [UIColor colorWithRed:182/255.0 green:178/255.0 blue:251/255.0 alpha:1];
    _congratulateL.text = @"查询中,请稍等";
    [self.view addSubview:_congratulateL];
    
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"activity" forKey:@"command"];
    [mDict setObject:@"signCal" forKey:@"options"];
    [mDict setObject:@"7" forKey:@"pageSize"];
    [mDict setObject:[UserServe sharedUserServe].currentPet.petID forKey:@"petId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = responseObject[@"value"];
        _congratulateL.text = [NSString stringWithFormat:@"恭喜获得%@积分",dic[@"award"]];
        _signCountL.text = [NSString stringWithFormat:@"已连续签到%@天",dic[@"count"]];
        _futureL.text = dic[@"memo"];
        [self buildCalendarListWithBaseList:dic[@"details"]];
        secceL.text = [NSString stringWithFormat:@"%@签到成功",[UserServe sharedUserServe].currentPet.nickname];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [self buildViewWithSkintype];
}
- (void)buildCalendarListWithBaseList:(NSArray *)array
{
    //视图需要的数组
    self.calendarArray = [NSMutableArray array];
    //时间工具
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    //构造数组
    NSMutableDictionary * map = [NSMutableDictionary dictionary];
    for(NSDictionary * dic in array) {
        Calendar * calendar = [[Calendar alloc] init];
        calendar.award = dic[@"award"];
        calendar.sign = YES;
        calendar.award = dic[@"award"];
        calendar.data = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[dic[@"createTime"] doubleValue]/1000]];
        [map setObject:calendar forKey:calendar.data];
    }
    for (int i = 0; i < size; i++) {
        NSDictionary * dic = [array lastObject];
        NSString * key = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[dic[@"createTime"] doubleValue]/1000 + i*24*3600]];
        Calendar * calendar = [map objectForKey:key];
        if (calendar) {
            [_calendarArray addObject:calendar];
        }else
        {
            Calendar * calendar = [[Calendar alloc] init];
            calendar.sign = NO;
            calendar.award = @"0";
            calendar.data = key;
            [_calendarArray addObject:calendar];
        }
    }
    [_signInHistoryCollectionView reloadData];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _calendarArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"collectionViewCell";
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identifier forIndexPath:indexPath];
    Calendar * calendar = [_calendarArray objectAtIndex:indexPath.row];
    NSArray * dataArray = [calendar.data componentsSeparatedByString:@"-"];
    if (calendar.sign) {
        cell.backgroundColor = [UIColor colorWithRed:182/255.0 green:178/255.0 blue:251/255.0 alpha:1];
        cell.dayL.textColor = [UIColor whiteColor];
        cell.awardL.hidden = NO;
    }else{
        cell.backgroundColor = [UIColor colorWithRed:182/255.0 green:178/255.0 blue:251/255.0 alpha:0.5];
        cell.dayL.textColor = [UIColor colorWithWhite:150/255.0 alpha:1];
        cell.awardL.hidden = YES;

    }
    cell.dayL.text = [dataArray lastObject];
    cell.mouthL.text = [NSString stringWithFormat:@"%@月",dataArray[1]];
    cell.awardL.text = [NSString stringWithFormat:@"%@积分",calendar.award];
    return  cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
