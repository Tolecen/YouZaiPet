//
//  AttentionViewController.h
//  TalkingPet
//
//  Created by wangxr on 15/5/12.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttentionViewController : UIViewController
@property (nonatomic,retain)UITableView * tableView;
-(void)attentionNoContent:(BOOL)have;
- (void)beginRefreshing;
@end
