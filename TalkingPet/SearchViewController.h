//
//  SearchViewController.h
//  TalkingPet
//
//  Created by Tolecen on 14-7-18.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BrowseTalkingTableViewCell.h"
#import "UserListTableViewCell.h"
#import "TalkingDetailPageViewController.h"
#import "BrowserTableHelper.h"
#import "SearchResultTagTableViewCell.h"
@interface SearchViewController : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,TalkingTableViewCellDelegate,BrowserTableHelperDelegate,UserCellAttentionDelegate,AttentionDelegate,UISearchBarDelegate>
{
    BOOL ifcancel;
    UIButton * shuoshuoB;
    UIButton * tagB;
    UIButton * userB;
    UIView * segmentIV;
    
    int searchType;
    
    int currentPage;
    
    UILabel * g;
}
@property (nonatomic, strong)UISearchBar * search;
@property (nonatomic, strong)UIButton * rightBtn;
@property (nonatomic, strong)UIView * searchView;
@property (nonatomic, strong)UIView * searchBarBGV;
@property (nonatomic, strong)UIView * scrollBG;
@property (nonatomic, strong)UITextField * searchTF;
@property (nonatomic, strong)UIButton * cancelSearchBtn;
@property (nonatomic, strong)UIButton * clearTFBtn;
@property (nonatomic, strong)UISegmentedControl * categorySeg;
@property (nonatomic, strong)UITableView * resultTableView;
@property (nonatomic, strong)NSMutableArray * tagArray;
@property (nonatomic, strong)NSMutableArray * userArray;
@property (nonatomic,strong) BrowserTableHelper * shuoshuoTableViewHelper;

@end
