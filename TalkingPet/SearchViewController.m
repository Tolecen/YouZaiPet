//
//  SearchViewController.m
//  TalkingPet
//
//  Created by Tolecen on 14-7-18.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "SearchViewController.h"
#import "UINavigationItem+CustomItem.h"
@interface SearchViewController ()

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        ifcancel = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self getBackImageView].frame = CGRectOffset([self getBackImageView].frame, 0, navigationBarHeight);
//    self.navigationController.navigationBarHidden = YES;
    float h = 20;
    if (navigationBarHeight>50) {
        h = 0;
    }
    /*
    UIView * searchTopbgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 88-h)];
    [searchTopbgV setBackgroundColor:[UIColor clearColor]];
//    searchTopbgV.alpha = 0.7;
    [self.view addSubview:searchTopbgV];
    
    UIView * searchTopbgV2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 88-h)];
    [searchTopbgV2 setBackgroundColor:[UIColor colorWithRed:0.235 green:0.776 blue:1 alpha:1]];
//    searchTopbgV2.alpha = 0.7;
    [searchTopbgV addSubview:searchTopbgV2];
    
    
    self.searchBarBGV = [[UIView alloc] initWithFrame:CGRectMake(10, 88-h-35-15, 223, 35)];
    self.searchBarBGV.backgroundColor = [UIColor clearColor];
    [searchTopbgV addSubview:_searchBarBGV];
    
    UIImageView * bgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 223, 35)];
    [bgImgV setImage:[UIImage imageNamed:@"searchPageToptextBG"]];
    [_searchBarBGV addSubview:bgImgV];
    
    UIImageView * sicon = [[UIImageView alloc] initWithFrame:CGRectMake(6, 10, 15, 15)];
    [sicon setImage:[UIImage imageNamed:@"sousuo-ico"]];
    [_searchBarBGV addSubview:sicon];
    
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(27, 2.5, 270, 30)];
    _searchTF.placeholder = @"搜索动态/用户/标签";
    _searchTF.borderStyle = UITextBorderStyleNone;
    _searchTF.backgroundColor = [UIColor clearColor];
    _searchTF.font = [UIFont systemFontOfSize:16];
    _searchTF.textAlignment = NSTextAlignmentLeft;
    _searchTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _searchTF.returnKeyType = UIReturnKeySearch;
    _searchTF.delegate = self;
    [_searchBarBGV addSubview:_searchTF];
    self.searchTF.userInteractionEnabled = YES;
    
    self.clearTFBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_clearTFBtn setBackgroundImage:[UIImage imageNamed:@"shanchushuruwenzi"] forState:UIControlStateNormal];
    [_clearTFBtn setFrame:CGRectMake(self.searchBarBGV.frame.size.width-18-5, 8.5, 18, 18)];
    [_searchBarBGV addSubview:_clearTFBtn];
    [_clearTFBtn addTarget:self action:@selector(clearBtnDO) forControlEvents:UIControlEventTouchUpInside];
    _clearTFBtn.hidden = YES;
    
    self.cancelSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelSearchBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelSearchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelSearchBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [_cancelSearchBtn setFrame:CGRectMake(310-62, 88-h-35-15, 62, 35)];
    [_cancelSearchBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [searchTopbgV addSubview:_cancelSearchBtn];
    [_cancelSearchBtn addTarget:self action:@selector(cancelSearchBtnDo) forControlEvents:UIControlEventTouchUpInside];
    _cancelSearchBtn.hidden = YES;
     
     */
    
    UIView * rightBtnBgv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [rightBtnBgv setBackgroundColor:[UIColor clearColor]];
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [rightBtnBgv addSubview:_rightBtn];
    _rightBtn.tag = 1;
    [_rightBtn addTarget:self action:@selector(cancelSearchBtnDo) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationItem setItemWithCustomView:rightBtnBgv itemType:right];
    
    UIView * bgv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame)-70, 44)];
    [bgv setBackgroundColor:[UIColor clearColor]];
    
    self.search = [[UISearchBar alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(self.view.frame)-70, 44)];
//     if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0){
//        _search.searchBarStyle = UISearchBarStyleMinimal;
//    }
    _search.autocorrectionType=UITextAutocorrectionTypeNo;
    _search.autocapitalizationType=UITextAutocapitalizationTypeNone;
    if ([_search respondsToSelector:@selector(setBarTintColor:)]) {
        _search.barTintColor = [UIColor clearColor];
        if ( [[[ UIDevice currentDevice ] systemVersion ] floatValue ]>=7.0) {
            [[[[_search . subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
            [ _search setBackgroundColor :[ UIColor clearColor ]];
        }
        else
        {
            [ _search setBarTintColor :[ UIColor clearColor ]];
            
            [ _search setBackgroundColor :[ UIColor clearColor ]];
        }
        
        [_rightBtn setTitle:@" 取消" forState:UIControlStateNormal];
        [_rightBtn setFrame:CGRectMake(5, 0, 60, 44)];
    }
    else
    {
        _search.tintColor = [UIColor clearColor];
        [[_search.subviews objectAtIndex:0]removeFromSuperview];
        [_rightBtn setTitle:@"取消 " forState:UIControlStateNormal];
        [_rightBtn setFrame:CGRectMake(0, 0, 60, 44)];
    }
    _search.delegate = self;
    _search.placeholder = @"搜索动态/用户/标签";
    
    _search.showsScopeBar = YES;
//    UITextField *searchField = [_search valueForKey:@"_searchField"];
//    [searchField setValue:[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
//    searchField.textColor = [UIColor whiteColor];
////    [searchField setValue:[UIColor whiteColor] forKeyPath:@"_textLabel.textColor"];
    [bgv addSubview:_search];
//    [_search setImage:[UIImage imageNamed:@"sousuo-ico"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
//    [_search setImage:[UIImage imageNamed:@"shanchushuruwenzi"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    
    [self.navigationItem setItemWithCustomView:bgv itemType:left];
    


    
    segmentIV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    segmentIV.backgroundColor = [UIColor colorWithWhite:235/255.0f alpha:1];
    [self.view addSubview:segmentIV];
//    self.scrollBG = [[UIView alloc] initWithFrame:CGRectMake(15, 35, 69.5, 1)];
//    _scrollBG.backgroundColor = [UIColor whiteColor];
//    [segmentIV addSubview:_scrollBG];
    shuoshuoB = [UIButton buttonWithType:UIButtonTypeCustom];
    shuoshuoB.frame = CGRectMake(0, 0, ScreenWidth/3, 30);
    [shuoshuoB setTitle:@"宠物说" forState:UIControlStateNormal];
    [shuoshuoB.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [shuoshuoB setTitleColor:[UIColor colorWithRed:0.235 green:0.776 blue:1 alpha:1] forState:UIControlStateNormal];
    shuoshuoB.tag = 1;

//    [shuoshuoB setBackgroundImage:[UIImage imageNamed:@"hot"] forState:UIControlStateNormal];
    [shuoshuoB addTarget:self action:@selector(searchWithType:) forControlEvents:UIControlEventTouchUpInside];
    [segmentIV addSubview:shuoshuoB];
    tagB = [UIButton buttonWithType:UIButtonTypeCustom];
    [tagB.titleLabel setFont:[UIFont systemFontOfSize:15]];
    tagB.frame = CGRectMake(ScreenWidth/3, 0, ScreenWidth/3, 30);
    tagB.tag = 2;
    [tagB setTitle:@"标签" forState:UIControlStateNormal];
    [tagB setTitleColor:[UIColor colorWithWhite:140/255.0f alpha:1] forState:UIControlStateNormal];
//    [tagB setBackgroundImage:[UIImage imageNamed:@"square"] forState:UIControlStateNormal];
    [tagB addTarget:self action:@selector(searchWithType:) forControlEvents:UIControlEventTouchUpInside];
    [segmentIV addSubview:tagB];
    userB = [UIButton buttonWithType:UIButtonTypeCustom];
    userB.frame = CGRectMake(2*(ScreenWidth/3), 0, ScreenWidth/3, 30);
    userB.tag = 3;
    [userB.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [userB setTitleColor:[UIColor colorWithWhite:140/255.0f alpha:1] forState:UIControlStateNormal];
    [userB setTitle:@"用户" forState:UIControlStateNormal];
//    [userB setBackgroundImage:[UIImage imageNamed:@"care"] forState:UIControlStateNormal];
    [userB addTarget:self action:@selector(searchWithType:) forControlEvents:UIControlEventTouchUpInside];
    [segmentIV addSubview:userB];

    
    
    [self.search becomeFirstResponder];
    
    searchType = 1;
    currentPage = 0;
    
    
    self.resultTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, ScreenWidth, self.view.frame.size.height-30-navigationBarHeight)];
//    _resultTableView.delegate = self;
//    _resultTableView.dataSource = self;
    _resultTableView.backgroundView = nil;
    _resultTableView.scrollsToTop = YES;
    _resultTableView.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    _resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _resultTableView.rowHeight = 510;
//    _resultTableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    _resultTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_resultTableView];
    
//    g = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 320, 100)];
//    [g setText:@"暂时没有消息"];
//    [g setTextAlignment:NSTextAlignmentCenter];
//    [g setTextColor:[UIColor whiteColor]];
//    [self.view addSubview:g];
    
    self.shuoshuoTableViewHelper = [[BrowserTableHelper alloc] initWithController:self Tableview:self.resultTableView SectionView:nil];
    self.shuoshuoTableViewHelper.delegate = self;
    self.shuoshuoTableViewHelper.cellNeedShowPublishTime = NO;
//    self.shuoshuoTableViewHelper.naviH = 0;
    
    _resultTableView.delegate = self.shuoshuoTableViewHelper;
    _resultTableView.dataSource = self.shuoshuoTableViewHelper;
//    self.shuoshuoTableViewHelper.tableViewType = TableViewTypeHot;
    // Do any additional setup after loading the view.
    
    
    g = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, 100)];
    [g setText:@"暂时没有您想要的结果呢~"];
    [g setBackgroundColor:[UIColor clearColor]];
    [g setTextAlignment:NSTextAlignmentCenter];
    [g setFont:[UIFont systemFontOfSize:16]];
    [g setTextColor:[UIColor colorWithWhite:150/255.0f alpha:1]];
    [self.view addSubview:g];
    g.hidden = YES;
    
    [self buildViewWithSkintype];
}
-(void)resultCount:(int)count
{
    if (count==0) {
        g.hidden = NO;
    }
    else
    {
        g.hidden = YES;
    }
}
-(void)refreshTableDo
{
    if (searchType==1) {
        g.hidden = YES;
        currentPage = 0;
        _resultTableView.delegate = self.shuoshuoTableViewHelper;
        _resultTableView.dataSource = self.shuoshuoTableViewHelper;
        self.shuoshuoTableViewHelper.footerShouldDelegateToUserCenter = NO;
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"search" forKey:@"command"];
        [mDict setObject:@"petalk" forKey:@"options"];
        [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"petId"];
        [mDict setObject:@"10" forKey:@"pageSize"];
        [mDict setObject:@"0" forKey:@"pageIndex"];
        [mDict setObject:self.search.text forKey:@"keyword"];
        //        [mDict setObject:@"O" forKey:@"type"];
        
        [self.shuoshuoTableViewHelper loadFirstDataPageWithDict:mDict];
    }
    else if (searchType==2){
        g.hidden = YES;
        currentPage = 0;
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        self.shuoshuoTableViewHelper.footerShouldDelegateToUserCenter = YES;
        [_resultTableView reloadData];
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"search" forKey:@"command"];
        [mDict setObject:@"tag" forKey:@"options"];
        [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"petId"];
        [mDict setObject:@"10" forKey:@"pageSize"];
        [mDict setObject:@"0" forKey:@"pageIndex"];
        [mDict setObject:self.search.text forKey:@"keyword"];
        
        [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
            currentPage++;
            self.tagArray = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"value"] objectForKey:@"list"]];
            [self.resultTableView reloadData];
            [self.resultTableView headerEndRefreshing];
            NSLog(@"search tag success:%@",responseObject);
            if (self.tagArray.count<=0) {
                g.hidden = NO;
            }
            else
                g.hidden = YES;
            
            //            [self cellPlayAni:self.tableV];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //            NSLog(@"get hot shuoshuo failed error:%@",error);
            //            [self endHeaderRefreshing:self.tableV];
            [self.resultTableView headerEndRefreshing];
        }];
        
    }
    else if (searchType==3){
        g.hidden = YES;
        currentPage = 0;
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        self.shuoshuoTableViewHelper.footerShouldDelegateToUserCenter = YES;
        [_resultTableView reloadData];
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"search" forKey:@"command"];
        [mDict setObject:@"user" forKey:@"options"];
        [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"petId"];
        [mDict setObject:@"20" forKey:@"pageSize"];
        [mDict setObject:@"0" forKey:@"pageIndex"];
        [mDict setObject:self.search.text forKey:@"keyword"];
        
        [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
            currentPage++;
            self.userArray = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"value"] objectForKey:@"list"]];
            //            self.tagArray = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"value"] objectForKey:@"list"]];
            [self.resultTableView reloadData];
            [self.resultTableView headerEndRefreshing];
            NSLog(@"search tag success:%@",responseObject);
            if (self.userArray.count<=0) {
                g.hidden = NO;
            }
            else
                g.hidden = YES;
            
            //            [self cellPlayAni:self.tableV];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //            NSLog(@"get hot shuoshuo failed error:%@",error);
            //            [self endHeaderRefreshing:self.tableV];
            [self.resultTableView headerEndRefreshing];
        }];
    }

}
- (void)buildViewWithSkintype
{
    [super buildViewWithSkintype];
}
-(void)searchWithType:(UIButton *)sender
{
//    sender.layer.cornerRadius = 5;
//    sender.layer.masksToBounds = YES;
//    sender.layer.borderWidth = 1;
//    sender.layer.borderColor = [[UIColor whiteColor] CGColor];
    [sender setTitleColor:[UIColor colorWithRed:0.235 green:0.776 blue:1 alpha:1] forState:UIControlStateNormal];
    for (int i = 0; i<3; i++) {
        UIButton * btn = (UIButton *)[segmentIV viewWithTag:(i+1)];
        if (i+1!=sender.tag) {
//            btn.layer.cornerRadius = 0;
//            btn.layer.masksToBounds = NO;
//            btn.layer.borderWidth = 0;
//            btn.layer.borderColor = [[UIColor whiteColor] CGColor];
            [btn setTitleColor:[UIColor colorWithWhite:140/255.0f alpha:1] forState:UIControlStateNormal];
        }
    }
    if (searchType!=sender.tag) {
        [self.shuoshuoTableViewHelper stopAudio];
    }
    searchType = (int)sender.tag;
    
    if (!self.search.text.length||self.search.text.length<1) {
        return;
    }
    [self doSearchWithType:searchType];
    
    
    
}
-(void)doSearchWithType:(int)type
{
    if (searchType==1) {
        g.hidden = YES;
        currentPage = 0;
        _resultTableView.delegate = self.shuoshuoTableViewHelper;
        _resultTableView.dataSource = self.shuoshuoTableViewHelper;
        self.shuoshuoTableViewHelper.footerShouldDelegateToUserCenter = NO;
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"search" forKey:@"command"];
        [mDict setObject:@"petalk" forKey:@"options"];
        [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"petId"];
        [mDict setObject:@"10" forKey:@"pageSize"];
        [mDict setObject:@"0" forKey:@"pageIndex"];
        [mDict setObject:self.search.text forKey:@"keyword"];
//        [mDict setObject:@"O" forKey:@"type"];
        
        [self.shuoshuoTableViewHelper loadFirstDataPageWithDict:mDict];
    }
    else if (searchType==2){
        g.hidden = YES;
        currentPage = 0;
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        self.shuoshuoTableViewHelper.footerShouldDelegateToUserCenter = YES;
        [_resultTableView reloadData];
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"search" forKey:@"command"];
        [mDict setObject:@"tag" forKey:@"options"];
        [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"petId"];
        [mDict setObject:@"10" forKey:@"pageSize"];
        [mDict setObject:@"0" forKey:@"pageIndex"];
        [mDict setObject:self.search.text forKey:@"keyword"];
        
        [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
            currentPage++;
            self.tagArray = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"value"] objectForKey:@"list"]];
            [self.resultTableView reloadData];
            [self.resultTableView headerEndRefreshing];
            NSLog(@"search tag success:%@",responseObject);
            if (self.tagArray.count<=0) {
                g.hidden = NO;
            }
            else
                g.hidden = YES;

            
//            [self cellPlayAni:self.tableV];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"get hot shuoshuo failed error:%@",error);
//            [self endHeaderRefreshing:self.tableV];
            [self.resultTableView headerEndRefreshing];
        }];

    }
    else if (searchType==3){
        g.hidden = YES;
        currentPage = 0;
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        self.shuoshuoTableViewHelper.footerShouldDelegateToUserCenter = YES;
        [_resultTableView reloadData];
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"search" forKey:@"command"];
        [mDict setObject:@"user" forKey:@"options"];
        [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"petId"];
        [mDict setObject:@"20" forKey:@"pageSize"];
        [mDict setObject:@"0" forKey:@"pageIndex"];
        [mDict setObject:self.search.text forKey:@"keyword"];
        
        [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
            currentPage++;
            self.userArray = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"value"] objectForKey:@"list"]];
//            self.tagArray = [NSMutableArray arrayWithArray:[[responseObject objectForKey:@"value"] objectForKey:@"list"]];
            [self.resultTableView reloadData];
            [self.resultTableView headerEndRefreshing];
            NSLog(@"search tag success:%@",responseObject);
            if (self.userArray.count<=0) {
                g.hidden = NO;
            }
            else
                g.hidden = YES;

            
            //            [self cellPlayAni:self.tableV];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //            NSLog(@"get hot shuoshuo failed error:%@",error);
            //            [self endHeaderRefreshing:self.tableV];
            [self.resultTableView headerEndRefreshing];
        }];
    }
    
}
-(void)footerDelegateToUserCenter
{
    g.hidden = YES;
    _resultTableView.delegate = self;
    _resultTableView.dataSource = self;
    NSMutableDictionary* mDict = [NetServer commonDict];
    if (searchType==2) {
//        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"search" forKey:@"command"];
        [mDict setObject:@"tag" forKey:@"options"];
        [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"petId"];
        [mDict setObject:@"10" forKey:@"pageSize"];
        [mDict setObject:[NSString stringWithFormat:@"%d",currentPage] forKey:@"pageIndex"];
        [mDict setObject:self.search.text forKey:@"keyword"];
    }
    else if (searchType==3){
        [mDict setObject:@"search" forKey:@"command"];
        [mDict setObject:@"user" forKey:@"options"];
        [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"petId"];
        [mDict setObject:@"20" forKey:@"pageSize"];
        [mDict setObject:[NSString stringWithFormat:@"%d",currentPage] forKey:@"pageIndex"];
        [mDict setObject:self.search.text forKey:@"keyword"];
    }
    
    [NetServer requestWithParameters:mDict Controller:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [self.commentArray addObjectsFromArray:[self getModelArray:[responseObject objectForKey:@"value"]]];
        currentPage++;
        if (searchType==2) {
            [self.tagArray addObjectsFromArray:[[responseObject objectForKey:@"value"] objectForKey:@"list"]];
            if (self.tagArray.count<=0) {
                g.hidden = NO;
            }
            else
                g.hidden = YES;

        }
        else if (searchType==3){
            [self.userArray addObjectsFromArray:[[responseObject objectForKey:@"value"] objectForKey:@"list"]];
            if (self.userArray.count<=0) {
                g.hidden = NO;
            }
            else
                g.hidden = YES;

        }
        
        self.shuoshuoTableViewHelper.isRefreshing = NO;
        [self.resultTableView footerEndRefreshing];
        [_resultTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get hot shuoshuo failed error:%@",error);
        self.shuoshuoTableViewHelper.isRefreshing = NO;
        [self.resultTableView footerEndRefreshing];
        //        [self endHeaderRefreshing:self.tableV];
    }];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.shuoshuoTableViewHelper stopAudio];
    if (ifcancel) {
        return;
    }
//    self.navigationController.navigationBarHidden = NO;
}
-(void)scrollit
{
    if ([self.search isFirstResponder]) {
        [self.search resignFirstResponder];
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.categorySeg.selectedSegmentIndex==2) {
//        PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
//        [self.navigationController pushViewController:pv animated:YES];
//
//    }
//    else{
//        TalkingDetailPageViewController * talkingDV = [[TalkingDetailPageViewController alloc] init];
//        [self.navigationController pushViewController:talkingDV animated:YES];
//    }
    
    if (searchType==2) {
        TagTalkListViewController * tagTlistV = [[TagTalkListViewController alloc] init];
        tagTlistV.title = [self.tagArray[indexPath.row] objectForKey:@"name"];
        Tag * theTag = [[Tag alloc] init];
        theTag.tagID = [self.tagArray[indexPath.row] objectForKey:@"id"];
        theTag.tagName = [self.tagArray[indexPath.row] objectForKey:@"name"];
        theTag.backGroundURL = [self.tagArray[indexPath.row] objectForKey:@"bgUrl"];
        tagTlistV.tag = theTag;
        tagTlistV.shouldRequestTagInfo = YES;
        tagTlistV.canShowPublishBtn = NO;
        [self.navigationController pushViewController:tagTlistV animated:YES];
    }
    else if (searchType==3){
        PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
        pv.petId = (self.userArray[indexPath.row])[@"id"];
        pv.petAvatarUrlStr = (self.userArray[indexPath.row])[@"headPortrait"];
        pv.petNickname = (self.userArray[indexPath.row])[@"nickName"];
        pv.delegate = self;
        [self.navigationController pushViewController:pv animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (searchType==2){
        int disNum = 0;
        if (ScreenWidth<=320) {
            disNum = 4;
        }
        else
            disNum = 5;
        float h = (ScreenWidth-30-(disNum-1)*10)/disNum;
        
        return 43+h+10;
    }
    else
        return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searchType==2) {
        return self.tagArray.count;
    }
    else
        return self.userArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPathx
{
    if (searchType==2){
        static NSString *cellIdentifier = @"talkingCellByTag";
        SearchResultTagTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        if (cell == nil) {
            cell = [[SearchResultTagTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
//            cell.delegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tagDict = self.tagArray[indexPathx.row];
//        cell.publisherAvatarV.placeholderImage = [UIImage imageNamed:@"gougouAvatar.jpeg"];
//        cell.publisherAvatarV.imageURL = [NSURL URLWithString:@"http://www.qqcan.com/uploads/allimg/c120811/1344A300Z50-3T615.jpg"];
        
        return cell;
    }
    else if(searchType==3)
    {
        static NSString *cellIdentifier = @"petListcell";
        UserListTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
        if (cell == nil) {
            cell = [[UserListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier CellType:2 ListType:1];
            cell.delegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.petDict = [self.userArray objectAtIndex:indexPathx.row];
        cell.cellIndex = indexPathx.row;
        return cell;
    }
    return nil;
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
-(void)attentionDelegate:(NSDictionary *)dict Index:(NSInteger)index
{
    [self.userArray replaceObjectAtIndex:index withObject:dict];
    [self.resultTableView reloadData];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.search resignFirstResponder];
}

-(void)segmentAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
        {
            self.resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.resultTableView reloadData];
            [self.resultTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
            break;
        case 1:
        {
            self.resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.resultTableView reloadData];
            [self.resultTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
            break;
        case 2:
        {
            self.resultTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [self.resultTableView reloadData];
            [self.resultTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)forwardWithTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    TalkingDetailPageViewController * talkingDV = [[TalkingDetailPageViewController alloc] init];
    talkingDV.commentStyle = commentStyleForward;
    [self.navigationController pushViewController:talkingDV animated:YES];
}
- (void)commentWithTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    TalkingDetailPageViewController * talkingDV = [[TalkingDetailPageViewController alloc] init];
    talkingDV.commentStyle = commentStyleComment;
    [self.navigationController pushViewController:talkingDV animated:YES];
}
- (void)zanWithTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    
}
- (void)shareWithTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    
}
- (void)attentionPetWithTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    
}
- (void)petProfileWhoPublishTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    pv.delegate = self;
    [self.navigationController pushViewController:pv animated:YES];
}
- (void)petProfileWhoForwardTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    pv.delegate = self;
    [self.navigationController pushViewController:pv animated:YES];
}
-(void)attentionPetWithPetId:(NSString *)petId AndRelationship:(NSString *)relationship
{
    for (int i = 0; i<self.userArray.count; i++) {
        NSDictionary * dict = self.userArray[i];
        if ([[dict objectForKey:@"id"] isEqualToString:petId]) {
            NSMutableDictionary * gh = [NSMutableDictionary dictionaryWithDictionary:dict];
            [gh setObject:relationship forKey:@"rs"];
            [self.userArray replaceObjectAtIndex:i withObject:gh];
            break;
        }
    }
    [self.resultTableView reloadData];
}
- (void)locationWithTalkingBrowse: (TalkingBrowse *)talkingBrowse
{
    
}


-(void)clearBtnDO
{
//    self.searchTF.text = @"";
//    self.clearTFBtn.hidden = YES;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (!searchBar.text.length||searchBar.text.length<1) {
        [SVProgressHUD showErrorWithStatus:@"还没输入搜索内容呢"];
        return;
    }
    [searchBar resignFirstResponder];
    [self doSearchWithType:searchType];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"search clicked");
    if (!textField.text.length||textField.text.length<1) {
        [SVProgressHUD showErrorWithStatus:@"还没输入搜索内容呢"];
        return NO;
    }
    [textField resignFirstResponder];
    [self doSearchWithType:searchType];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    [self.searchBarBGV setFrame:CGRectMake(5, 5, 255, 35)];
    self.cancelSearchBtn.hidden = NO;
    [self.searchTF setFrame:CGRectMake(27, 2.5, 225-20, 30)];
    [_clearTFBtn setFrame:CGRectMake(self.searchBarBGV.frame.size.width-18-5, 8.5, 18, 18)];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string) {
        self.clearTFBtn.hidden = NO;
        if (textField.text.length==1) {
            self.clearTFBtn.hidden = YES;
        }
    }
    return YES;
}
-(void)cancelSearchBtnDo
{
    ifcancel = YES;
    [self.search resignFirstResponder];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
