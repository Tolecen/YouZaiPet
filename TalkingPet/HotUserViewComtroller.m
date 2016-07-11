//
//  HotUserViewComtroller.m
//  TalkingPet
//
//  Created by wangxr on 14/11/11.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "HotUserViewComtroller.h"
#import "PetCategoryParser.h"
#import "EGOImageView.h"
#import "SVProgressHUD.h"

@interface HotUserCell : UICollectionViewCell
@property (nonatomic,retain)UIImageView * attentionIV;
@property (nonatomic,retain)EGOImageView * headIV;
@property (nonatomic,retain)UIImageView * genderIV;
@property (nonatomic,retain)UILabel * nickL;
@property (nonatomic,retain)UILabel * breedAgeL;
@end
@implementation HotUserCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView * IV = [[UIImageView alloc] initWithFrame:self.bounds];
        IV.image = [UIImage imageNamed:@"hot_backg"];
        [self.contentView addSubview: IV];
        
        self.headIV = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholderHead"]];
        _headIV.frame = CGRectMake(10, 5, 75, 75);
        _headIV.layer.masksToBounds=YES;
        _headIV.layer.cornerRadius = 75/2;
        _headIV.layer.borderWidth=2.0f;
        _headIV.layer.borderColor=[UIColor whiteColor].CGColor;
        [self.contentView addSubview: _headIV];
        
        self.attentionIV = [[UIImageView alloc] initWithFrame:CGRectMake(70, 0, 25, 25)];
        _attentionIV.image = [UIImage imageNamed:@"hot_selector"];
        [self.contentView addSubview: _attentionIV];
        
        self.genderIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 85, 12, 12)];
        [self.contentView addSubview: _genderIV];
        
        self.nickL = [[UILabel alloc] initWithFrame:CGRectMake(12, 80, 83, 20)];
        _nickL.backgroundColor = [UIColor clearColor];
        _nickL.font = [UIFont systemFontOfSize:12];
        _nickL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        _nickL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview: _nickL];
        
        self.breedAgeL = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 95, 20)];
        _breedAgeL.backgroundColor = [UIColor clearColor];
        _breedAgeL.font = [UIFont systemFontOfSize:10];
        _breedAgeL.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        _breedAgeL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview: _breedAgeL];
        
    }
    return self;
}
@end
@interface HotUser :NSObject
@property (nonatomic,assign)BOOL needAttention;
@property (nonatomic,retain)NSString * headPortrait;
@property (nonatomic,retain)NSString * nickName;
@property (nonatomic,retain)NSString * gender;
@property (nonatomic,retain)NSString * age;
@property (nonatomic,retain)NSString * breed;
@property (nonatomic,retain)NSString * petID;
@end
@implementation HotUser

@end
@interface HotUserViewComtroller ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIButton * sureB;
    BOOL loading;
}
@property (nonatomic,retain)NSMutableArray * userArr;
@property (nonatomic,retain)NSMutableArray * idArr;
@property (nonatomic,retain)UICollectionView * userCollection;
@end
@implementation HotUserViewComtroller

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (!loading) {
        [self getUserList];
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"推荐关注";
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"hotuser_bg"]];
    
    UIImageView * bt = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-navigationBarHeight-ScreenWidth*0.27, ScreenWidth, ScreenWidth*0.27)];
    [bt setImage:[UIImage imageNamed:@"hotuser_bottom"]];
    [self.view addSubview:bt];
    
    UILabel * titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height<500?0:5, ScreenWidth-10, 20)];
    [self.view addSubview:titleL];
    titleL.backgroundColor = [UIColor clearColor];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
    titleL.font = [UIFont systemFontOfSize:16];
    titleL.text = @"关注热门宠友,和他们一起玩转宠物说";
    
    UICollectionViewFlowLayout* sectionlayout = [[UICollectionViewFlowLayout alloc]init];
    sectionlayout.itemSize = CGSizeMake(95,120);
    sectionlayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    sectionlayout.minimumLineSpacing = 5;
    sectionlayout.minimumInteritemSpacing = 5;
    self.userCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(self.view.center.x-160,self.view.frame.size.height<500?20:30, 320,390) collectionViewLayout:sectionlayout];
    _userCollection.delegate = self;
    _userCollection.dataSource = self;
    _userCollection.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_userCollection];
    _userCollection.showsHorizontalScrollIndicator = NO;
    [_userCollection registerClass:[HotUserCell class] forCellWithReuseIdentifier:@"SectionCell"];
    
    UIView * lingshiV = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height- navigationBarHeight -50, ScreenWidth, 40)];
    [self.view addSubview:lingshiV];
    
    if (self.view.frame.size.height<500) {
        lingshiV.frame = CGRectMake(0, self.view.frame.size.height- navigationBarHeight -40, ScreenWidth, 40);
    }
    
    
    UIImageView * shakeIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2, 35, 35)];
    shakeIV.animationImages = @[[UIImage imageNamed:@"shake1"],[UIImage imageNamed:@"shake2"],[UIImage imageNamed:@"shake3"],[UIImage imageNamed:@"shake2"]];
    [lingshiV addSubview:shakeIV];
    shakeIV.animationDuration = 0.3;
    [shakeIV startAnimating];
    
    UILabel * lab1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 9, 60, 20)];
    lab1.text = @"摇一摇";
    lab1.backgroundColor = [UIColor clearColor];
    lab1.textColor = [UIColor colorWithRed:0.235 green:0.776 blue:1 alpha:1];
    lab1.font = [UIFont systemFontOfSize:18];
    [lingshiV addSubview:lab1];
    
    UILabel * lab2 = [[UILabel alloc] initWithFrame:CGRectMake(110, 11, 60, 20)];
    lab2.text = @"换一批";
    lab2.backgroundColor = [UIColor clearColor];
    lab2.textColor = [UIColor colorWithRed:0.235 green:0.776 blue:1 alpha:1];
    lab2.font = [UIFont systemFontOfSize:14];
    [lingshiV addSubview:lab2];
    
    sureB = [UIButton buttonWithType:UIButtonTypeCustom];
    sureB.frame = CGRectMake(ScreenWidth-90, 6, 80, 30);
    sureB.titleLabel.font = [UIFont systemFontOfSize:14];
    [sureB setTitle:@"确认关注" forState:UIControlStateNormal];
    [sureB addTarget:self action:@selector(attentionUsers) forControlEvents:UIControlEventTouchUpInside];
    [lingshiV addSubview:sureB];
    
    lingshiV.backgroundColor = [UIColor clearColor];
    [sureB setBackgroundImage:[UIImage imageNamed:@"hotuser_act"] forState:UIControlStateNormal];
    
    [self buildViewWithSkintype];
    [self getUserList];
}
- (void)getUserList
{
    loading = YES;
    [SVProgressHUD showWithStatus:@"正在寻找有趣的人，请稍等"];
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"pet" forKey:@"command"];
    [mDict setObject:@"recommend" forKey:@"options"];
    [mDict setObject:@"9" forKey:@"pageSize"];
    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.userArr = [NSMutableArray array];
        self.idArr = [NSMutableArray array];
        PetCategoryParser * categoryParser = [[PetCategoryParser alloc] init];
        NSArray * arr = [responseObject objectForKey:@"value"];
        for (NSDictionary *dic in arr) {
            HotUser * user = [[HotUser alloc] init];
            user.petID = dic[@"id"];
            user.needAttention = YES;
            user.headPortrait = dic[@"headPortrait"];
            user.gender = dic[@"gender"];
            user.nickName = dic[@"nickName"];
            user.breed = [categoryParser breedWithIDcode:[dic[@"type"] integerValue]];
            user.age = [NSString stringWithFormat:@"%.0f岁",ceil(([[NSDate date] timeIntervalSince1970] - [dic[@"birthday"] doubleValue]/1000)/60/60/24/365)];
            
            [_userArr addObject:user];
            [_idArr addObject:user.petID];
        }
        [_userCollection reloadData];
        loading = NO;
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        loading = NO;
    }];
}
- (void)attentionUsers
{
    if (_idArr.count) {
        [SVProgressHUD showWithStatus:@"关注中..."];
        NSString * petIds = [NSString stringWithArray:_idArr];
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"petfans" forKey:@"command"];
        [mDict setObject:@"batchFocus" forKey:@"options"];
        [mDict setObject:[UserServe sharedUserServe].userID forKey:@"fansPetId"];
        [mDict setObject:petIds forKey:@"petId"];
        [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRLoginSucceed" object:self userInfo:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"关注失败，请在程序内关注您想关注的人吧"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRLoginSucceed" object:self userInfo:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXRLoginSucceed" object:self userInfo:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
#pragma mark - UICollectionView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HotUser * user = _userArr[indexPath.row];
    user.needAttention = !user.needAttention;
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    if (user.needAttention) {
        [_idArr addObject:user.petID];
    }else
    {
        [_idArr removeObject:user.petID];
    }
    if (_idArr.count) {
        [sureB setTitle:@"确认关注" forState:UIControlStateNormal];
    }else
    {
        [sureB setTitle:@"以后再说" forState:UIControlStateNormal];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _userArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SectionCellIdentifier = @"SectionCell";
    HotUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SectionCellIdentifier forIndexPath:indexPath];
    HotUser * user = _userArr[indexPath.row];
    cell.headIV.imageURL = [NSURL URLWithString:user.headPortrait];
    cell.nickL.text = user.nickName;
    CGSize size = [cell.nickL.text sizeWithFont:cell.nickL.font constrainedToSize:CGSizeMake(83, 20) lineBreakMode:NSLineBreakByWordWrapping];
    cell.genderIV.frame = CGRectMake((83-size.width)/2, 85, 12, 12);
    switch ([user.gender intValue]) {
        case 0:{
            cell.genderIV.image = [UIImage imageNamed:@"female"];
        }break;
        case 1:{
            cell.genderIV.image = [UIImage imageNamed:@"male"];
        }break;
        default:
            break;
    }
    cell.breedAgeL.text = [user.breed stringByAppendingString:[NSString stringWithFormat:@"  %@",user.age]];
    cell.attentionIV.hidden = !user.needAttention;
    return cell;
}
@end
