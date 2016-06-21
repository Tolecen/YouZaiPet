//
//  MyShuoshuoTimeLineViewController.h
//  TalkingPet
//
//  Created by Tolecen on 15/2/7.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TimelineBrowserHelper.h"
@interface MyShuoshuoTimeLineViewController : BaseViewController
{
    BOOL haveIn;
}
@property (nonatomic,strong) UITableView * contentTableView;
@property (nonatomic,strong) TimelineBrowserHelper * tHelper;
@end
