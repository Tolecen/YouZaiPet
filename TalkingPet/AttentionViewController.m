//
//  AttentionViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/5/12.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "AttentionViewController.h"
#import "TimelineBrowserHelper.h"
#import "RootViewController.h"
#import "BlankPageView.h"

@interface AttentionViewController ()
{
    UITapGestureRecognizer * tapf;
    BlankPageView * blankPage;
}
@property (nonatomic,retain)TimelineBrowserHelper * attentionTableViewHelper;
@end
@implementation AttentionViewController
-(void)viewDidLoad
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, [UIDevice currentDevice].systemVersion.floatValue >= 7.0?0:50, 0);
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    _tableView.scrollsToTop = NO;
    
    self.attentionTableViewHelper = [[TimelineBrowserHelper alloc] initWithController:self tableview:self.tableView withHead:YES header:nil];
    self.tableView.delegate = self.attentionTableViewHelper;
    self.tableView.dataSource = self.attentionTableViewHelper;
    self.attentionTableViewHelper.needScrollTopDelegate = YES;
    
    NSArray * attentionArray = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"focusList%@",[UserServe sharedUserServe].currentPet.petID]];
    if (attentionArray) {
        self.attentionTableViewHelper.dataArray = [self.attentionTableViewHelper getModelArray:attentionArray];
        [self.tableView reloadData];
        
    }
    [self beginRefreshing];
}
- (void)beginRefreshing
{
    if (![UserServe sharedUserServe].currentPet.petID) {
        self.tableView.hidden = YES;
        self.attentionTableViewHelper.headerCanRefresh = NO;
        self.attentionTableViewHelper.footerCanRefresh = NO;
        if (!blankPage) {
            blankPage = [[BlankPageView alloc] init];
            [blankPage showWithView:self.view image:[UIImage imageNamed:@"attention_login"] buttonImage:[UIImage imageNamed:@"attention_unLogin"] action:^{
                [[RootViewController sharedRootViewController] showLoginViewController];
            }];
        }
    }
    else if ([UserServe sharedUserServe].currentPet.petID){
        self.tableView.hidden = NO;
        self.attentionTableViewHelper.headerCanRefresh = YES;
        self.attentionTableViewHelper.footerCanRefresh = YES;
        if (blankPage) {
            [blankPage removeFromSuperview];
            blankPage = nil;
        }
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"petalk" forKey:@"command"];
        [mDict setObject:@"focusList" forKey:@"options"];
        [mDict setObject:[UserServe sharedUserServe].currentPet.petID?[UserServe sharedUserServe].currentPet.petID:@"" forKey:@"petId"];
        [mDict setObject:@"10" forKey:@"pageSize"];
        
        self.attentionTableViewHelper.reqDict = mDict;
        [_tableView headerBeginRefreshing];
    }
}
-(void)doTouch
{
    [self beginRefreshing];
}
-(void)attentionNoContent:(BOOL)have
{
    if (!have) {
        self.tableView.hidden = YES;
        self.attentionTableViewHelper.headerCanRefresh = NO;
        self.attentionTableViewHelper.footerCanRefresh = NO;
    }
    else{
        self.tableView.hidden = NO;
        self.attentionTableViewHelper.headerCanRefresh = YES;
        self.attentionTableViewHelper.footerCanRefresh = YES;
        if (blankPage) {
            [blankPage removeFromSuperview];
            blankPage = nil;
        }
    }
}
@end
