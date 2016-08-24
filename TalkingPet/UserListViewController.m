//
//  UserListViewController.m
//  TalkingPet
//
//  Created by wangxr on 14-8-11.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "UserListViewController.h"
#import "UserListTableViewCell.h"
#import "PersonProfileViewController.h"
@interface UserListViewController ()<UITableViewDataSource,UITableViewDelegate,UserCellAttentionDelegate,AttentionDelegate,UISearchDisplayDelegate,UISearchBarDelegate>{
    int currentPage;
}
@property (nonatomic,retain)UITableView * tableView;
@property (nonatomic,retain)NSMutableArray * userListArr;
@property (nonatomic,retain)UISearchBar * mSearchBar;
@property (nonatomic,retain)UISearchDisplayController * searchController;
@property (nonatomic,retain)NSArray * searchArr;

@end

@implementation UserListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentPage = 0;
        self.shouldSelectChatUser = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    if (self.listType == UserListTypeAttention) {
        self.title = @"关注";
    }
    if (self.listType == UserListTypeFans) {
        self.title = @"粉丝";
    }
    if (self.listType == UserListBlackList) {
        self.title = @"黑名单";
    }
    if (self.countNum) {
        if (self.listType == UserListTypeAttention) {
            self.title = @"我的关注";
        }
        if (self.listType == UserListTypeFans) {
            self.title = @"我的粉丝";
        }
        self.title = [self.title stringByAppendingFormat:@"(%@)",self.countNum];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButtonWithTarget:@selector(back)];
    
    UIView * bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height - navigationBarHeight)];
    [bgV setBackgroundColor:[UIColor clearColor]];
    
    UIView * uu = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight)];
    [uu setBackgroundColor:[UIColor whiteColor]];
    uu.layer.cornerRadius = 8;
    uu.layer.masksToBounds = YES;
    [uu setAlpha:0.7];
    [bgV addSubview:uu];
    
    self.tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - navigationBarHeight);
    _tableView.backgroundView=bgV;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    _tableView.rowHeight = 70;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    g = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight/2-108, ScreenWidth, 100)];
    [g setText:@"这里空空的呀"];
    [g setBackgroundColor:[UIColor clearColor]];
    [g setTextAlignment:NSTextAlignmentCenter];
    [g setTextColor:[UIColor whiteColor]];
    [self.view addSubview:g];
    g.hidden = YES;
    
    [self buildViewWithSkintype];
    
    [self.tableView addFooterWithTarget:self action:@selector(tableViewFooterRereshing:)];
    [self reloadData];
    if ([self.petID isEqual:[UserServe sharedUserServe].userID]&&self.listType == UserListTypeAttention) {
        self.mSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 44, 320, 44)];
        _mSearchBar.autocorrectionType=UITextAutocorrectionTypeNo;
        _mSearchBar.autocapitalizationType=UITextAutocapitalizationTypeNone;
        if ([_mSearchBar respondsToSelector:@selector(setBarTintColor:)]) {
            _mSearchBar.barTintColor = [UIColor colorWithWhite:230/255.0f alpha:1];
        }else{
            _mSearchBar.tintColor = [UIColor colorWithWhite:230/255.0f alpha:1];
        }
        [self.mSearchBar setPlaceholder:@"搜索用户"];
        _tableView.tableHeaderView =_mSearchBar;
        self.mSearchBar.delegate = self;
        [self.mSearchBar sizeToFit];
        //        self.searchController =[[UISearchDisplayController alloc] initWithSearchBar:self.mSearchBar contentsController:self];
        //        self.searchController.searchResultsDelegate= self;
        //        self.searchController.searchResultsDataSource = self;
        //        self.searchController.searchResultsTableView.rowHeight = 70;
        //        self.searchController.delegate = self;
    }
}
- (void)tableViewFooterRereshing:(UITableView *)tableView
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    
    if (self.listType == UserListTypeAttention) {
        [mDict setObject:@"petfans" forKey:@"command"];
        [mDict setObject:@"findFocus" forKey:@"options"];
        [mDict setObject:self.petID forKey:@"userId"];
        if ([UserServe sharedUserServe].userID) {
            [mDict setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
        }
    }
    if (self.listType == UserListTypeFans) {
        [mDict setObject:@"petfans" forKey:@"command"];
        [mDict setObject:@"findFans" forKey:@"options"];
        [mDict setObject:self.petID forKey:@"userId"];
        if ([UserServe sharedUserServe].userID) {
            [mDict setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
        }
    }
    if (self.listType == UserListBlackList) {
        [mDict setObject:@"setting" forKey:@"command"];
        [mDict setObject:@"CBL" forKey:@"options"];
        [mDict setObject:self.petID forKey:@"userId"];
        if ([UserServe sharedUserServe].userID) {
            [mDict setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
        }
    }
    
    [mDict setObject:[NSString stringWithFormat:@"%d",currentPage] forKey:@"pageIndex"];
    [mDict setObject:@"20" forKey:@"pageSize"];
    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        currentPage++;
        if (self.listType==UserListBlackList) {
            [self.userListArr addObjectsFromArray:responseObject[@"value"]];
            
        }
        
        [self.tableView footerEndRefreshing];
        [_tableView reloadData];
        [SVProgressHUD dismissWithError:@"数据加载完毕" afterDelay:1];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView footerEndRefreshing];
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)reloadData
{
    currentPage = 1;
    NSMutableDictionary* mDict = [NetServer commonDict];
    if (self.listType == UserListTypeAttention) {
        [mDict setObject:@"petfans" forKey:@"command"];
        [mDict setObject:@"findFocus" forKey:@"options"];
        [mDict setObject:self.petID forKey:@"userId"];
        if ([UserServe sharedUserServe].userID) {
            //            [mDict setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
        }
    }
    if (self.listType == UserListTypeFans) {
        [mDict setObject:@"petfans" forKey:@"command"];
        [mDict setObject:@"findFans" forKey:@"options"];
        [mDict setObject:self.petID forKey:@"userId"];
        if ([UserServe sharedUserServe].userID) {
            //            [mDict setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
        }
    }
    if (self.listType == UserListBlackList) {
        [mDict setObject:@"setting" forKey:@"command"];
        [mDict setObject:@"CBL" forKey:@"options"];
        [mDict setObject:self.petID forKey:@"userId"];
        if ([UserServe sharedUserServe].userID) {
            [mDict setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
        }
    }
    
    [mDict setObject:@"1" forKey:@"pageIndex"];
    [mDict setObject:@"20" forKey:@"pageSize"];
    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        currentPage++;
        if (self.listType==UserListBlackList) {
            self.userListArr = [NSMutableArray arrayWithArray:responseObject[@"value"]];
        }
        else
            self.userListArr = [NSMutableArray arrayWithArray:responseObject[@"value"]];
        [_tableView reloadData];
        if (self.userListArr.count==0) {
            g.hidden = NO;
        }
        else
            g.hidden = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.shouldSelectChatUser) {
        ChatDetailViewController * chatDV = [[ChatDetailViewController alloc] init];
        Pet * theP = [[Pet alloc] init];
        if ([tableView isEqual:_tableView]) {
            theP.petID = (_userListArr[indexPath.row])[@"id"];
            theP.nickname =(_userListArr[indexPath.row])[@"nickName"];
            theP.headImgURL = (_userListArr[indexPath.row])[@"headPortrait"];
            chatDV.thePet = theP;
            chatDV.title =theP.nickname;
        }
        else
        {
            theP.petID = (_searchArr[indexPath.row])[@"id"];
            theP.nickname =(_searchArr[indexPath.row])[@"nickName"];
            theP.headImgURL = (_searchArr[indexPath.row])[@"headPortrait"];
            chatDV.thePet = theP;
            chatDV.title =theP.nickname;
        }
        [self.navigationController pushViewController:chatDV animated:YES];
        return;
    }
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    if ([tableView isEqual:_tableView]) {
        pv.petId = (_userListArr[indexPath.row])[@"id"];
        pv.petAvatarUrlStr = (_userListArr[indexPath.row])[@"headPortrait"];
        pv.petNickname = (_userListArr[indexPath.row])[@"nickName"];
        pv.delegate = self;
    }else
    {
        pv.petId = (_searchArr[indexPath.row])[@"id"];
        pv.petAvatarUrlStr = (_searchArr[indexPath.row])[@"headPortrait"];
        pv.petNickname = (_searchArr[indexPath.row])[@"nickName"];
    }
    [self.navigationController pushViewController:pv animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_tableView]) {
        return self.userListArr.count;
    }else
    {
        return _searchArr.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_tableView]) {
        static NSString *cellIdentifier = @"petListcell";
        UserListTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        if (cell == nil) {
            if (self.listType==UserListBlackList) {
                cell = [[UserListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier CellType:1 ListType:2];
            }
            else
            {
                cell = [[UserListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier CellType:1 ListType:1];
            }
            cell.delegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.petDict = [self.userListArr objectAtIndex:indexPath.row];
        cell.cellIndex = indexPath.row;
        if (self.listType == UserListBlackList) {
            cell.listType = 2;
        }
        else
            cell.listType = 1;
        return cell;
    }else
    {
        static NSString *cellIdentifier = @"seachListcell";
        UserListTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        if (cell == nil) {
            cell = [[UserListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier CellType:1 ListType:1];
            cell.delegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.petDict = [self.searchArr objectAtIndex:indexPath.row];
        cell.cellIndex = indexPath.row;
        return cell;
    }
}
-(void)toUserPage:(NSDictionary *)petDict
{
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    pv.petId = [petDict objectForKey:@"id"];
    pv.petAvatarUrlStr = [petDict objectForKey:@"headPortrait"];
    pv.petNickname = [petDict objectForKey:@"nickName"];
    pv.delegate = self;
    [self.navigationController pushViewController:pv animated:YES];
}
-(void)attentionPetWithPetId:(NSString *)petId AndRelationship:(NSString *)relationship
{
    for (int i = 0; i<self.userListArr.count; i++) {
        NSDictionary * dict = self.userListArr[i];
        if ([[dict objectForKey:@"id"] isEqualToString:petId]) {
            NSMutableDictionary * gh = [NSMutableDictionary dictionaryWithDictionary:dict];
            [gh setObject:relationship forKey:@"rs"];
            [self.userListArr replaceObjectAtIndex:i withObject:gh];
            break;
        }
    }
    [self.tableView reloadData];
}
-(void)attentionDelegate:(NSDictionary *)dict Index:(NSInteger)index
{
    [self.userListArr replaceObjectAtIndex:index withObject:dict];
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *) searchBar
{
    UITextField *searchBarTextField = nil;
    NSArray *views = ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) ? searchBar.subviews : [[searchBar.subviews objectAtIndex:0] subviews];
    for (UIView *subview in views)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            searchBarTextField = (UITextField *)subview;
            break;
        }
    }
    searchBarTextField.enablesReturnKeyAutomatically = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [SVProgressHUD showWithStatus:@"搜索中"];
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"petfans" forKey:@"command"];
    [mDict setObject:@"findFocus" forKey:@"options"];
    [mDict setObject:self.petID forKey:@"userId"];
    if ([UserServe sharedUserServe].userID) {
        //        [mDict setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
    }
    [mDict setObject:searchBar.text forKey:@"keyword"];
    [mDict setObject:@"1" forKey:@"pageIndex"];
    [mDict setObject:@"20" forKey:@"pageSize"];
    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"arr=========%@",responseObject[@"value"]);
        self.userListArr = [NSMutableArray arrayWithArray:responseObject[@"value"]];
        if(self.userListArr.count==0)
        {
            g.text=@"暂无搜索结果";
            g.textColor=[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1.00];
            g.hidden=NO;
        }else
        {
            g.hidden=YES;
        }
        [_tableView reloadData];
        [SVProgressHUD dismiss];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    self.searchArr = nil;
}

-(void)removeThisPetFromBlackList:(NSDictionary *)dict cellIndex:(NSInteger)cellIndex;
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"setting" forKey:@"command"];
    [mDict setObject:@"CBD" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"currPetId"];
    [mDict setObject:[dict objectForKey:@"id"] forKey:@"userId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD showSuccessWithStatus:@"已从黑名单移除"];
        [self.userListArr removeObjectAtIndex:cellIndex];
        [self.tableView reloadData];
        [DatabaseServe removePetFromChatBlackList:[dict objectForKey:@"id"]];
    }
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 
                             }];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
