//
//  ExperienceViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/3/17.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "ExperienceViewController.h"
@interface ImageCell : UITableViewCell
@property (nonatomic,retain)UIImageView * myImageView;
@property (nonatomic,retain)UILabel * label;
@end
@implementation ImageCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.myImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_myImageView];
        self.label = [[UILabel alloc] init];
        _label.numberOfLines = 0;
        [self.contentView addSubview:_label];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _myImageView.frame = self.bounds;
}
@end
@interface ExperienceViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * experienceTableView;
}
@property (nonatomic,retain)NSDictionary * dictionary;
@end

@implementation ExperienceViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"成长历程";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButtonWithTarget:@selector(backBtnDo)];
    [self buildViewWithSkintype];
    
    experienceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-navigationBarHeight)];
    experienceTableView.rowHeight = self.view.frame.size.width*603/750;
    experienceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    experienceTableView.delegate = self;
    experienceTableView.dataSource = self;
    [self.view addSubview:experienceTableView];
    
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"rank" forKey:@"command"];
    [mDict setObject:self.paihangType==2?@"petRankEveryMoment":@"petRankWeekMoment" forKey:@"options"];
    [mDict setObject:_petId forKey:@"petId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dictionary = responseObject[@"value"];
        [experienceTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)backBtnDo
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *petCellIdentifier = @"UserRankingCell";
    ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:petCellIdentifier];
    if (cell == nil) {
        cell = [[ImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:petCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.myImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"list_image%ld",(long)indexPath.row+1]];
    NSMutableAttributedString *attributedStr;
    switch (indexPath.row) {
        case 0:{
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"YYYY年MM月dd日\n加入宠物说,\n发布了第一条说说"];
            NSDate *timesp = [NSDate dateWithTimeIntervalSince1970:[_dictionary[@"joinTime"]  doubleValue]/1000];
            NSString *timespStr = [formatter stringFromDate:timesp];
            attributedStr = [[NSMutableAttributedString alloc] initWithString: timespStr];
            [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:20] range: NSMakeRange(0, timespStr.length)];
            [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:30] range: NSMakeRange(0, 4)];
            [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:30] range: NSMakeRange(5, 2)];
            [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:30] range: NSMakeRange(8, 2)];
            [attributedStr addAttribute: NSForegroundColorAttributeName value: [UIColor whiteColor] range: NSMakeRange(0, timespStr.length)];
            [attributedStr addAttribute: NSShadowAttributeName value:({
                NSShadow * shadow = [[NSShadow alloc] init];
                shadow.shadowOffset = CGSizeMake(1.5, 1.5);
                shadow.shadowColor = [UIColor colorWithRed:208/255.0 green:131/255.0 blue:171/255.0 alpha:1];
                shadow;
                }) range: NSMakeRange(0, timespStr.length)];
            [attributedStr addAttribute: NSParagraphStyleAttributeName value:({
                NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
                style.lineSpacing = 5;
                style;
            }) range: NSMakeRange(0, attributedStr.length)];
            cell.label.frame = CGRectMake(10, 10, 300, 95);
        }break;
        case 1:{
            NSString * friendNo = _dictionary[@"friendCount"]  ;
            NSString * fansNo = _dictionary[@"followerCount"]  ;
            NSString * str = [NSString stringWithFormat:@"结识了%@个朋友,\n被%@个人关注",friendNo,fansNo];
            attributedStr = [[NSMutableAttributedString alloc] initWithString: str];
            [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:20] range: NSMakeRange(0, str.length)];
            [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:30] range: NSMakeRange(3, friendNo.length)];
            [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:30] range: NSMakeRange(9+friendNo .length, fansNo.length)];
            [attributedStr addAttribute: NSForegroundColorAttributeName value: [UIColor whiteColor] range: NSMakeRange(0, str.length)];
            [attributedStr addAttribute: NSShadowAttributeName value:({
                NSShadow * shadow = [[NSShadow alloc] init];
                shadow.shadowOffset = CGSizeMake(1.5, 1.5);
                shadow.shadowColor = [UIColor colorWithRed:153/255.0 green:128/255.0 blue:244/255.0 alpha:1];
                shadow;
            }) range: NSMakeRange(0, str.length)];
            cell.label.frame = CGRectMake(10, 10, 300, 75);
        }break;
        case 2:{
            NSString * times = _dictionary[@"petalkCount"]  ;
            NSString * zan = _dictionary[@"likedCount"]  ;
            NSString * str = [NSString stringWithFormat:@"%@精彩瞬间。\n收到了%@个赞",times,zan];
            attributedStr = [[NSMutableAttributedString alloc] initWithString: str];
            [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:20] range: NSMakeRange(0, str.length)];
            [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:30] range: NSMakeRange(0, times.length)];
            [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:30] range: NSMakeRange(9+times.length, zan.length)];
            [attributedStr addAttribute: NSForegroundColorAttributeName value: [UIColor whiteColor] range: NSMakeRange(0, str.length)];
            [attributedStr addAttribute: NSShadowAttributeName value:({
                NSShadow * shadow = [[NSShadow alloc] init];
                shadow.shadowOffset = CGSizeMake(1.5, 1.5);
                shadow.shadowColor = [UIColor colorWithRed:81/255.0 green:154/255.0 blue:187/255.0 alpha:1];
                shadow;
            }) range: NSMakeRange(0, str.length)];
            cell.label.frame = CGRectMake(10, 10, 300, 75);
        }break;
        case 3:{
            NSString * No = _dictionary[@"rkNum"]  ;
            NSString * str = [NSString stringWithFormat:@"在热门排行%@榜中排名第%@位",_paihangType==1?@"周":@"总",No];
            attributedStr = [[NSMutableAttributedString alloc] initWithString: str];
            [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:20] range: NSMakeRange(0, str.length)];
            [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:30] range: NSMakeRange(11, No.length)];
            [attributedStr addAttribute: NSForegroundColorAttributeName value: [UIColor whiteColor] range: NSMakeRange(0, str.length)];
            [attributedStr addAttribute: NSShadowAttributeName value:({
                NSShadow * shadow = [[NSShadow alloc] init];
                shadow.shadowOffset = CGSizeMake(1.5, 1.5);
                shadow.shadowColor = [UIColor colorWithRed:179/255.0 green:143/255.0 blue:1/255.0 alpha:1];
                shadow;
            }) range: NSMakeRange(0, str.length)];
            [attributedStr addAttribute: NSParagraphStyleAttributeName value:({
                NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
                style.alignment = NSTextAlignmentCenter;
                style;
            }) range: NSMakeRange(0, str.length)];
            cell.label.frame = CGRectMake(10, 10, ScreenWidth-20, 30);
            cell.label.center = CGPointMake(CGRectGetMidX(cell.bounds), cell.label.center.y);
        
        }break;
        default:
            break;
    }
    cell.label.attributedText = attributedStr;
    return cell;
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
