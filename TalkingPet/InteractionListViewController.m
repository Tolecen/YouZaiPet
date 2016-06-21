//
//  InteractionListViewController.m
//  TalkingPet
//
//  Created by Tolecen on 15/3/26.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//
/**
 *　　　　　　　　┏┓　　　┏┓+ +
 *　　　　　　　┏┛┻━━━┛┻┓ + +
 *　　　　　　　┃　　　　　　　┃
 *　　　　　　　┃　　　━　　　┃ ++ + + +
 *　　　　　　 ████━████ ┃+
 *　　　　　　　┃　　　　　　　┃ +
 *　　　　　　　┃　　　┻　　　┃
 *　　　　　　　┃　　　　　　　┃ + +
 *　　　　　　　┗━┓　　　┏━┛
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃ + + + +
 *　　　　　　　　　┃　　　┃　　　　Code is far away from bug with the animal protecting
 *　　　　　　　　　┃　　　┃ + 　　　　神兽保佑,代码无bug
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃　　+
 *　　　　　　　　　┃　 　　┗━━━┓ + +
 *　　　　　　　　　┃ 　　　　　　　┣┓
 *　　　　　　　　　┃ 　　　　　　　┏┛
 *　　　　　　　　　┗┓┓┏━┳┓┏┛ + + + +
 *　　　　　　　　　　┃┫┫　┃┫┫
 *　　　　　　　　　　┗┻┛　┗┻┛+ + + +
 */
#import "InteractionListViewController.h"

@interface InteractionListViewController ()

@end

@implementation InteractionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lastId = @"";
    self.listArray = [NSMutableArray array];
    [self setBackButtonWithTarget:@selector(backBtnDo:)];
    
    self.listTableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight)];
    self.listTableV.delegate = self;
    self.listTableV.dataSource = self;
    self.listTableV.scrollsToTop = YES;
    self.listTableV.backgroundColor = [UIColor whiteColor];
    //    _notiTableView.rowHeight = 90;
    //    _notiTableView.contentInset = UIEdgeInsetsMake(0, 0, 59, 0);
    self.listTableV.showsVerticalScrollIndicator = NO;
//    self.listTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.listTableV];
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*0.618)];
    self.topView.backgroundColor = [UIColor clearColor];
    self.topImageV = [[EGOImageButton alloc] initWithFrame:self.topView.frame];
    [self.topImageV setBackgroundColor:[UIColor colorWithWhite:240/255.0f alpha:1]];
    [self.topView addSubview:self.topImageV];
    [self.topImageV addTarget:self action:@selector(toHudongList) forControlEvents:UIControlEventTouchUpInside];
//    self.topImageV.imageURL = [NSURL URLWithString:@"http://pic3.nipic.com/20090617/2082016_092517008_2.jpg"];
    
    self.topLbgV = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenWidth*0.618-30, ScreenWidth, 30)];
    self.topLbgV.backgroundColor = [UIColor blackColor];
    self.topLbgV.alpha = 0.8;
    [self.topView addSubview:self.topLbgV];
    self.topLbgV.userInteractionEnabled = NO;
    
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenWidth*0.618-20, ScreenWidth, 20)];
    [self.topLabel setBackgroundColor:[UIColor clearColor]];
    [self.topLabel setFont:[UIFont systemFontOfSize:16]];
    self.topLabel.textColor = [UIColor whiteColor];
    self.topLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.topLabel.numberOfLines = 0;
    [self.topView addSubview:self.topLabel];
    self.topLabel.userInteractionEnabled = NO;
    
    UIImageView * sdV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 59, 59)];
    [sdV setImage:[UIImage imageNamed:@"image_superscript"]];
    [self.topView addSubview:sdV];
    
    self.listTableV.tableHeaderView = self.topView;
    
    [self getTheList];
    
    
    [self.listTableV addHeaderWithTarget:self action:@selector(tableViewHeaderRereshing:)];
    //        [self.tableV headerBeginRefreshing];
    [self.listTableV addFooterWithTarget:self action:@selector(tableViewFooterRereshing:)];
    // Do any additional setup after loading the view.
}

- (void)tableViewHeaderRereshing:(UITableView *)tableView
{
    self.lastId = @"";
    [self getTopicList];
}
- (void)tableViewFooterRereshing:(UITableView *)tableView
{
    [self getTopicList];
}
-(void)endRefreshing:(UITableView *)tableView
{
    [self.listTableV footerEndRefreshing];
    [self.listTableV headerEndRefreshing];
    [self.listTableV reloadData];
    
}
-(void)getTheList
{
    NSString * title = @"这里是每日话题";
    CGSize cSize;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0){
        NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle2.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:paragraphStyle2};
        cSize = [title boundingRectWithSize:CGSizeMake(ScreenWidth-20, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes2 context:nil].size;
    }
    else
        cSize = [title sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(ScreenWidth-20, 40) lineBreakMode:NSLineBreakByCharWrapping];
    
    [self.topLabel setText:title];
    [self.topLabel setFrame:CGRectMake(10, ScreenWidth*0.618-10-cSize.height, cSize.width, cSize.height)];
    [self.topLbgV setFrame:CGRectMake(0, ScreenWidth*0.618-10-cSize.height-10, ScreenWidth, cSize.height+20)];
    
    [self getTopicList];
}

-(void)getTopicList
{
    NSMutableDictionary* usersDict = [NetServer commonDict];
    [usersDict setObject:@"topic" forKey:@"command"];
    [usersDict setObject:@"list" forKey:@"options"];
    [usersDict setObject:@"20" forKey:@"pageSize"];
    [usersDict setObject:self.lastId forKey:@"startId"];
    [NetServer requestWithParameters:usersDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"value"] count]>=1) {
            if ([self.lastId isEqualToString:@""]) {
                self.listArray = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"value"]];
                NSString * title = [[self.listArray objectAtIndex:0] objectForKey:@"content"];
                CGSize cSize;
                if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0){
                    NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc]init];
                    paragraphStyle2.lineBreakMode = NSLineBreakByWordWrapping;
                    NSDictionary *attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:paragraphStyle2};
                    cSize = [title boundingRectWithSize:CGSizeMake(ScreenWidth-20, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes2 context:nil].size;
                }
                else
                    cSize = [title sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(ScreenWidth-20, 40) lineBreakMode:NSLineBreakByCharWrapping];
                [self.topLabel setText:title];
                [self.topLabel setFrame:CGRectMake(10, ScreenWidth*0.618-10-cSize.height, cSize.width, cSize.height)];
                [self.topLbgV setFrame:CGRectMake(0, ScreenWidth*0.618-10-cSize.height-10, ScreenWidth, cSize.height+20)];
                self.topImageV.imageURL = [NSURL URLWithString:[[self.listArray objectAtIndex:0] objectForKey:@"pic"]];
            }
            else
                [self.listArray addObjectsFromArray:[responseObject objectForKey:@"value"]];
            self.lastId = [[self.listArray lastObject] objectForKey:@"id"];
        }
        

        
        [self.listTableV reloadData];
        [self endRefreshing:self.listTableV];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endRefreshing:self.listTableV];
    }];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * content = [[self.listArray objectAtIndex:indexPath.row+1] objectForKey:@"content"];
    CGSize cSize;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0){
        NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle2.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle2};
        cSize = [content boundingRectWithSize:CGSizeMake(ScreenWidth-10-10-75-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes2 context:nil].size;
    }
    else
        cSize = [content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(ScreenWidth-10-10-75-10, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    return (10+cSize.height+5+20+10)>=95?(10+cSize.height+5+20+10):95;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count-1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"prizeListCell";
    TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[TopicTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.theDict = [self.listArray objectAtIndex:indexPath.row+1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InteractionBarViewController * interBar = [[InteractionBarViewController alloc] init];
    interBar.hideNaviBg = YES;
    interBar.titleStr = [[self.listArray objectAtIndex:indexPath.row+1] objectForKey:@"content"];
    interBar.bgImageUrl = [[self.listArray objectAtIndex:indexPath.row+1] objectForKey:@"pic"];
    interBar.topicId = [[self.listArray objectAtIndex:indexPath.row+1] objectForKey:@"id"];
    [self.navigationController pushViewController:interBar animated:YES];
}
-(void)toHudongList
{
    if (_listArray.count<=0) {
        return;
    }
    InteractionBarViewController * interBar = [[InteractionBarViewController alloc] init];
    interBar.hideNaviBg = YES;
    interBar.titleStr = [[self.listArray objectAtIndex:0] objectForKey:@"content"];
    interBar.bgImageUrl = [[self.listArray objectAtIndex:0] objectForKey:@"pic"];
    interBar.topicId = [[self.listArray objectAtIndex:0] objectForKey:@"id"];
    [self.navigationController pushViewController:interBar animated:YES];
}
-(void)backBtnDo:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
