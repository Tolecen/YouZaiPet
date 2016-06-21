//
//  InteractionBarViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/3/25.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "InteractionBarViewController.h"
#import "PublishServer.h"
#import "RootViewController.h"
#import "ShareSheet.h"
@interface PublishInteractionCell:UITableViewCell
{
    UIView * progressImageV;
    UIButton*resendBtn;
    UIButton*delTaskBtn;
}
@property (nonatomic,retain)UIImageView * thunImg;
@property (nonatomic,retain)NSString * publishID;
@property (nonatomic,retain)UIView * rePublishView;
@property (nonatomic,copy)void(^rePublishAction)();
@property (nonatomic,copy)void(^cancelPublishAction)();
- (void)setProgressSizeWithScale:(double)scale;
@end
@implementation PublishInteractionCell
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _thunImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        [self.contentView addSubview:_thunImg];
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(70, 25, ScreenWidth-80, 10)];
        view.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:view];
        
        progressImageV = [[UIView alloc] initWithFrame:CGRectMake(70, 25, 0, 10)];
        progressImageV.backgroundColor = [UIColor colorWithRed:133/255.0 green:209/255.0 blue:252/255.0 alpha:1];
        [self.contentView addSubview:progressImageV];
        
        self.rePublishView = [[UIView alloc] init];
        _rePublishView.frame = CGRectMake(70, 0, ScreenWidth-70, 50);
        _rePublishView.backgroundColor = [UIColor whiteColor];
        _rePublishView.hidden = YES;
        [self.contentView addSubview:self.rePublishView];
        
        UILabel*failedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 180, 20)];
        [failedLabel setBackgroundColor:[UIColor clearColor]];
        [failedLabel setText:@"发布失败"];
        [failedLabel setFont:[UIFont systemFontOfSize:16]];
        [failedLabel setTextColor:[UIColor redColor]];
        [_rePublishView addSubview:failedLabel];
        
        resendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [resendBtn setFrame:CGRectMake(_rePublishView.frame.size.width-85, 13, 35, 35)];
        [resendBtn setBackgroundImage:[UIImage imageNamed:@"rangd_normal"] forState:UIControlStateNormal];
        [self.rePublishView addSubview:resendBtn];
        [resendBtn addTarget:self action:@selector(resendFailedTask) forControlEvents:UIControlEventTouchUpInside];
        
        delTaskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delTaskBtn setFrame:CGRectMake(_rePublishView.frame.size.width-50, 13, 35, 35)];
        [delTaskBtn setBackgroundImage:[UIImage imageNamed:@"deleteTask_normal"] forState:UIControlStateNormal];
        [self.rePublishView addSubview:delTaskBtn];
        [delTaskBtn addTarget:self action:@selector(removeThisTask) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, ScreenWidth, 1)];
        lineView.backgroundColor = [UIColor colorWithWhite:230/255.0f alpha:1];
        [self.contentView addSubview:lineView];
    }
    return self;
}
-(void)setPublishID:(NSString *)publishID
{
    if (![_publishID isEqualToString:publishID]) {
        _publishID = publishID;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changProgressSize:) name:publishID object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRepublishView) name:[NSString stringWithFormat:@"%@PublishFailure",publishID] object:nil];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    [resendBtn setFrame:CGRectMake(_rePublishView.frame.size.width-85, 13, 35, 35)];
    [delTaskBtn setFrame:CGRectMake(_rePublishView.frame.size.width-50, 13, 35, 35)];
}
- (void)changProgressSize:(NSNotification*)not
{
    NSDictionary * dic = not.userInfo;
    NSLog(@"==%@",dic[@"written"]);
    double scale = [dic[@"written"] doubleValue];
    [self setProgressSizeWithScale:scale];
}
- (void)setProgressSizeWithScale:(double)scale
{
    progressImageV.frame = CGRectMake(70, 25, (ScreenWidth-80)*scale, 10);
}
- (void)showRepublishView
{
    _rePublishView.hidden = NO;
}
-(void)resendFailedTask
{
    if (_rePublishAction) {
        _rePublishAction();
    }
}
-(void)removeThisTask
{
    if (_cancelPublishAction) {
        _cancelPublishAction();
    }
}
@end
@interface InteractionBarViewController ()

@end

@implementation InteractionBarViewController
-(instancetype)init
{
    if (self = [super init]) {
        self.state = 0;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.lastId = @"";
    self.listArray = [NSMutableArray array];
    self.hotListArray = [NSMutableArray array];
    [self setShadowBackButtonWithTarget:@selector(backBtnDo:)];
    [self setRightButtonWithName:nil BackgroundImg:@"morebtn_shadow" Target:@selector(shareInteraction)];
    
    self.listTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-35)];
    self.listTableV.delegate = self;
    self.listTableV.dataSource = self;
    self.listTableV.scrollsToTop = YES;
    self.listTableV.backgroundColor = [UIColor whiteColor];
    //    _notiTableView.rowHeight = 90;
    //    _notiTableView.contentInset = UIEdgeInsetsMake(0, 0, 59, 0);
    self.listTableV.showsVerticalScrollIndicator = NO;
    self.listTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.listTableV];
    
    UIView * n = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-([UIDevice currentDevice].systemVersion.floatValue >= 7.0?35:(35+navigationBarHeight)), ScreenWidth, 35)];
    n.backgroundColor = [UIColor colorWithRed:183/255.0f green:232/255.0f blue:254/255.0f alpha:1];
    [self.view addSubview:n];
    
    UIButton * hudongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [hudongBtn setFrame:CGRectMake(40, self.view.frame.size.height-([UIDevice currentDevice].systemVersion.floatValue >= 7.0?35:(35+navigationBarHeight)), ScreenWidth-40, 35)];
    [hudongBtn setTitle:@"发布互动" forState:UIControlStateNormal];
    [hudongBtn setBackgroundColor:[UIColor colorWithRed:183/255.0f green:232/255.0f blue:254/255.0f alpha:1]];
    [hudongBtn addTarget:self action:@selector(editWithoutImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hudongBtn];
    
    
    UIButton * picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [picBtn setFrame:CGRectMake(0, self.view.frame.size.height-([UIDevice currentDevice].systemVersion.floatValue >= 7.0?35:(35+navigationBarHeight)), 40, 35)];
    [picBtn setImage:[UIImage imageNamed:@"tab_button_add"] forState:UIControlStateNormal];
//    [picBtn setTitle:@"发布互动" forState:UIControlStateNormal];
    [picBtn setBackgroundColor:[UIColor clearColor]];
    [picBtn addTarget:self action:@selector(editWithImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:picBtn];
    
    
    UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(45, self.view.frame.size.height-4-([UIDevice currentDevice].systemVersion.floatValue >= 7.0?27:(35+navigationBarHeight)-8), 1, 27)];
    [lineV setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:lineV];
    
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0){
        self.title = self.titleStr;
    }
    XLHeaderView *headerView = [[XLHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame)*0.618)backGroudImageURL:self.bgImageUrl headerImageURL:@"http://www.qqw21.com/article/uploadpic/2012-9/2012911193026322.jpg" title:self.titleStr subTitle:self.titleStr asNavi:NO];
//    headerView.viewController = self;
    headerView.scrollView = self.listTableV;
//    self.listTableV.tableHeaderView = headerView;
    [self.view addSubview:headerView];
    self.headerView = headerView;
    
    
    [self.listTableV addHeaderWithTarget:self action:@selector(tableViewHeaderRereshing:)];
    //        [self.tableV headerBeginRefreshing];
    [self.listTableV addFooterWithTarget:self action:@selector(tableViewFooterRereshing:)];
    
    if (_state) {
        [self getTodayInteraction];
    }else{
        [self getHudongList];
    }
    // Do any additional setup after loading the view.
}
-(void)setTopicId:(NSString *)topicId
{
    _topicId = topicId;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(publishInteractionSuccess) name:[NSString stringWithFormat:@"WXRPublishServerPublishInteractionSuccess_%@",_topicId] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginPublishInteraction) name:[NSString stringWithFormat:@"WXRPublishServerBeginPublishInteraction_%@",_topicId] object:nil];
}
- (void)beginPublishInteraction
{
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
    [_listTableV reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}
-(void)publishInteractionSuccess
{
    [self beginPublishInteraction];
    [_listTableV headerBeginRefreshing];
}
- (void)tableViewHeaderRereshing:(UITableView *)tableView
{
    self.lastId = @"";
    [self getHudongList];
}
- (void)tableViewFooterRereshing:(UITableView *)tableView
{
    [self getHudongList];
}
- (void)editWithImage
{
    NSString * currentPetId = [UserServe sharedUserServe].currentPet.petID;
    if (!currentPetId) {
        if (![RootViewController sharedRootViewController].presentedViewController) {
            [[RootViewController sharedRootViewController] showLoginViewController];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录才能执行更多操作哦" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        }
        return;
    }

    [PublishServer editInteractionWithPicture:self.topicId];
}
- (void)editWithoutImage
{
    NSString * currentPetId = [UserServe sharedUserServe].currentPet.petID;
    if (!currentPetId) {
        if (![RootViewController sharedRootViewController].presentedViewController) {
            [[RootViewController sharedRootViewController] showLoginViewController];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录才能执行更多操作哦" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        }
        return;
    }

    [PublishServer editInteractionWithoutPicture:self.topicId];
}
-(void)endRefreshing:(UITableView *)tableView
{
    [self.listTableV footerEndRefreshing];
    [self.listTableV headerEndRefreshing];
    [self.listTableV reloadData];
    
}
-(void)getTodayInteraction
{
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"topic" forKey:@"command"];
    [usersDict setObject:@"topOne" forKey:@"options"];
    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.titleStr = [responseObject[@"value"] objectForKey:@"content"];
        self.bgImageUrl = [responseObject[@"value"] objectForKey:@"pic"];
        self.topicId = [responseObject[@"value"] objectForKey:@"id"];
        if (_headerView) {
            [_headerView removeFromSuperview];
        }
        if ([UIDevice currentDevice].systemVersion.floatValue < 7.0){
            self.title = self.titleStr;
        }
        XLHeaderView *headerView = [[XLHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame)*1/2.0f)backGroudImageURL:self.bgImageUrl headerImageURL:@"http://www.qqw21.com/article/uploadpic/2012-9/2012911193026322.jpg" title:self.titleStr subTitle:self.titleStr asNavi:NO];
        headerView.scrollView = self.listTableV;
        [self.view addSubview:headerView];
        self.headerView = headerView;
        [self getHudongList];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)getHudongList
{
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"topic" forKey:@"command"];
    [usersDict setObject:@"talkList" forKey:@"options"];
    [usersDict setObject:self.topicId?_topicId:@"" forKey:@"topicId"];
    [usersDict setObject:@"20" forKey:@"pageSize"];
    [usersDict setObject:self.lastId forKey:@"startId"];
    if ([UserServe sharedUserServe].currentPet.petID) {
        [usersDict setObject:[UserServe sharedUserServe].currentPet.petID forKey:@"petId"];
    }
    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"value"] count]>=1) {
            [self setTwoArray:[responseObject objectForKey:@"value"]];
            self.lastId = [[[responseObject objectForKey:@"value"] lastObject] objectForKey:@"id"];
        }
        [self endRefreshing:self.listTableV];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefreshing:self.listTableV];
    }];
}
-(void)setTwoArray:(NSMutableArray *)array
{
    if ([self.lastId isEqualToString:@""]) {
        [self.hotListArray removeAllObjects];
        [self.listArray removeAllObjects];
    }
    for (int i = 0; i<array.count; i++) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:array[i]];
        NSString * content = [dict objectForKey:@"content"];
        CGSize cSize;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0){
            NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle2.lineBreakMode = NSLineBreakByWordWrapping;
            paragraphStyle2.lineHeightMultiple = 1.2;
            //        paragraphStyle2.firstLineHeadIndent = 20;
            NSDictionary *attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle2};
            
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:content];
            [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, content.length)];
            
            cSize = [content boundingRectWithSize:CGSizeMake(ScreenWidth-20, 120) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes2 context:nil].size;
            [dict setObject:attrString forKey:@"attriContent"];
        }
        else
        {
            cSize = [content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(ScreenWidth-20, 120)  lineBreakMode:NSLineBreakByCharWrapping];
        }
        
        
        [dict setObject:[NSString stringWithFormat:@"%f",cSize.height] forKey:@"rowHeight"];
        [dict setObject:[NSString stringWithFormat:@"%f",cSize.width] forKey:@"rowWidth"];
        
        if ([[dict objectForKey:@"top"] isEqualToString:@"true"]) {
            [self.hotListArray addObject:dict];
        }
        else
            [self.listArray addObject:dict];
        
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_headerView updateSubViewsWithScrollOffset:scrollView.contentOffset];
}
-(void)touchedUserId:(NSString *)uid
{
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    pv.petId = uid;
    [self.navigationController pushViewController:pv animated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView* myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
//    myView.backgroundColor = [UIColor lightGrayColor];
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 22)];
//    titleLabel.textColor=[UIColor colorWithRed:133/255.0f green:209/255.0f blue:252/255.0f alpha:1];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    if (section==0) {
//        titleLabel.text = @"出彩互动";
//    }
//    else
//        titleLabel.text = @"全部互动";
//    [myView addSubview:titleLabel];
//    return myView;
//}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }else if (indexPath.row==0) {
        return 30;
    }
    else{
//        NSString * content = (indexPath.section==1?[self.hotListArray[indexPath.row-1] objectForKey:@"content"]:[self.listArray[indexPath.row-1] objectForKey:@"content"]);
//        NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc]init];
//        paragraphStyle2.lineBreakMode = NSLineBreakByWordWrapping;
//        paragraphStyle2.lineHeightMultiple = 1.2;
////        paragraphStyle2.firstLineHeadIndent = 20;
//        NSDictionary *attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle2};
//        CGSize cSize = [content boundingRectWithSize:CGSizeMake(ScreenWidth-20, 120) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes2 context:nil].size;
        NSString * heightStr = (indexPath.section==1?[self.hotListArray[indexPath.row-1] objectForKey:@"rowHeight"]:[self.listArray[indexPath.row-1] objectForKey:@"rowHeight"]);
        float theH = [heightStr floatValue];
        NSArray * cA = (indexPath.section==1?[self.hotListArray[indexPath.row-1] objectForKey:@"comments"]:[self.listArray[indexPath.row-1] objectForKey:@"comments"]);
        NSArray * hA = (indexPath.section==1?[self.hotListArray[indexPath.row-1] objectForKey:@"pictures"]:[self.listArray[indexPath.row-1] objectForKey:@"pictures"]);
        
        if (indexPath.section==1) {
            return 55+theH+(hA.count==0?0:110)+10+10;
        }
        else{
            if (cA.count==2) {
                return 55+theH+10+(hA.count==0?0:110)+95+10;
            }
            else if (cA.count==1){
                return 55+theH+10+(hA.count==0?0:110)+70+10;
            }
            return 55+theH+(hA.count==0?0:110)+10+10;
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return ((NSArray*)[PublishServer sharedPublishServer].interactionDic[_topicId]).count;
    }
    if (section==1) {
        return self.hotListArray.count>0?(self.hotListArray.count+1):0;
    }
    return self.listArray.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"publishCell";
        PublishInteractionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        if (cell == nil) {
            cell = [[PublishInteractionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        InteractionPublisher * publisher = ((NSArray*)[PublishServer sharedPublishServer].interactionDic[_topicId])[indexPath.row];
        cell.publishID = publisher.publishID;
        cell.rePublishView.hidden = !publisher.failure;
        [cell setProgressSizeWithScale:publisher.percent];
        UIImage * image = nil;
        if ([publisher.pathArray firstObject]) {
            image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[subdirectoryw stringByAppendingString:[publisher.pathArray firstObject]]]];
            cell.rePublishView.frame = CGRectMake(70, 0, ScreenWidth-70, 50);
        }else{
            cell.rePublishView.frame = CGRectMake(0, 0, ScreenWidth, 50);
        }
        cell.thunImg.image = image;
        cell.rePublishAction = ^(){
            NSArray * arr = [PublishServer sharedPublishServer].interactionDic[self.topicId];
            InteractionPublisher*publisher= arr[indexPath.row];
            [PublishServer publishInteractionWithPublisher:publisher];
        };
        cell.cancelPublishAction = ^(){
            [PublishServer cancelPublishInteractionWithPublishID:publisher.publishID interactionID:_topicId];
        };
        return cell;
    }else if (indexPath.row==0) {
        static NSString *cellIdentifier = @"sectioncell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
//        cell.contentView.backgroundColor = [UIColor redColor];
        cell.textLabel.text = indexPath.section==1?@"精彩互动":@"全部互动";
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString *cellIdentifier = @"hudongListCell";
        HuDongListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        if (cell == nil) {
            cell = [[HuDongListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.delegate = self;
        }
        if (indexPath.section==1) {
            cell.contentDict = self.hotListArray[indexPath.row-1];
            cell.commentArray = [self.hotListArray[indexPath.row-1] objectForKey:@"comments"];
            cell.imageArray = [self.hotListArray[indexPath.row-1] objectForKey:@"pictures"];
        }
        else{
            cell.contentDict = self.listArray[indexPath.row-1];
            cell.commentArray = [self.listArray[indexPath.row-1] objectForKey:@"comments"];
            cell.imageArray = [self.listArray[indexPath.row-1] objectForKey:@"pictures"];
        }
        cell.cellIndex = (int)indexPath.row-1;
        cell.cellSection = (int)indexPath.section;
//        cell.contentView.backgroundColor = [UIColor redColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)resetStatusforIndex:(int)index section:(int)section withStatus:(NSArray *)commentArray commentCount:(int)commentCount
{
    if (section==1) {
 
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:self.hotListArray[index]];
        NSMutableArray * cA = [NSMutableArray array];
        for (int i = 0; i<commentArray.count; i++) {
            NSMutableDictionary * g = [NSMutableDictionary dictionary];
            TalkComment * tk = commentArray[i];
            [g setObject:tk.petID forKey:@"petId"];
            [g setObject:tk.petNickname forKey:@"petNickName"];
            [g setObject:tk.content forKey:@"comment"];
            [cA addObject:g];
        }
        [dict setObject:cA forKey:@"comments"];
        [dict setObject:[NSString stringWithFormat:@"%d",commentCount] forKey:@"commentCount"];
        [self.hotListArray replaceObjectAtIndex:index withObject:dict];
    }
    else if (section==2) {
        
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:self.listArray[index]];
        NSMutableArray * cA = [NSMutableArray array];
        for (int i = 0; i<commentArray.count; i++) {
            NSMutableDictionary * g = [NSMutableDictionary dictionary];
            TalkComment * tk = commentArray[i];
            [g setObject:tk.petID forKey:@"petId"];
            [g setObject:tk.petNickname forKey:@"petNickName"];
            [g setObject:tk.content forKey:@"comment"];
            [cA addObject:g];
        }
        [dict setObject:cA forKey:@"comments"];
        [dict setObject:[NSString stringWithFormat:@"%d",commentCount] forKey:@"commentCount"];
        [self.listArray replaceObjectAtIndex:index withObject:dict];
    }
    [self.listTableV reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    else if (indexPath.row==0){
        return;
    }
    InteractionDetailViewController * ib = [[InteractionDetailViewController alloc] init];
    ib.delegate = self;
    ib.hideNaviBg = YES;
    ib.titleStr = self.titleStr;
    ib.bgImageUrl = self.bgImageUrl;
    ib.cellIndex = (int)indexPath.row-1;
    ib.sectionIndex = (int)indexPath.section;
    if (indexPath.section==1) {
        ib.hudongId = [self.hotListArray[indexPath.row-1] objectForKey:@"id"];
    }
    else if (indexPath.section==2) {
        ib.hudongId = [self.listArray[indexPath.row-1] objectForKey:@"id"];
    }
    [self.navigationController pushViewController:ib animated:YES];
}

-(void)resetDictForSection:(int)section row:(int)row dict:(NSDictionary *)dict
{
    if (section==1) {
        [self.hotListArray replaceObjectAtIndex:row withObject:dict];
    }
    else if(section == 2){
        [self.listArray replaceObjectAtIndex:row withObject:dict];
    }
    [self.listTableV reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self showNaviBg];
}
-(void)backBtnDo:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)shareInteraction
{
    if (!_topicId) {
        return;
    }
    ShareSheet * shareSheet = [[ShareSheet alloc]initWithIconArray:@[@"weiChatFriend",@"friendCircle",@"sina",@"qq"] titleArray:@[@"微信好友",@"朋友圈",@"微博",@"QQ"] action:^(NSInteger index) {
        switch (index) {
            case 0:{
                [ShareServe shareToWeixiFriendWithTitle:_titleStr Content:@"互动吧—发现更多养宠秘籍" imageUrl:_bgImageUrl webUrl:[NSString stringWithFormat:INTERACTIONBASEURL,_topicId] Succeed:nil];
            }break;
            case 1:{
                [ShareServe shareToFriendCircleWithTitle:_titleStr Content:@"互动吧—发现更多养宠秘籍" imageUrl:_bgImageUrl webUrl:[NSString stringWithFormat:INTERACTIONBASEURL,_topicId] Succeed:nil];
            }break;
            case 2:{
                [ShareServe shareToSineWithContent:[NSString stringWithFormat:@"%@"INTERACTIONBASEURL,_titleStr,_topicId] imageUrl:_bgImageUrl Succeed:nil];
            }break;
            case 3:{
                [ShareServe shareToQQWithTitle:_titleStr Content:@"互动吧—发现更多养宠秘籍" imageUrl:_bgImageUrl webUrl:[NSString stringWithFormat:INTERACTIONBASEURL,_topicId] Succeed:nil];
            }break;
            default:
                break;
        }
        
    }];
    [shareSheet show];
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
