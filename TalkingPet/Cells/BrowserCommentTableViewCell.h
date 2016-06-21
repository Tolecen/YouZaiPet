//
//  BrowserCommentTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 15/2/6.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "TalkingTableViewCellDelegate.h"
@interface BrowserCommentTableViewCell : UITableViewCell<TalkingTableViewCellDelegate>
@property (nonatomic,strong) UILabel * commentViewcommentL;
@property (nonatomic,strong)NSMutableArray * showCommentArray;
@property (nonatomic,strong)NSString * commentNum;
@property (nonatomic,assign) id <TalkingTableViewCellDelegate> delegate;
@end
