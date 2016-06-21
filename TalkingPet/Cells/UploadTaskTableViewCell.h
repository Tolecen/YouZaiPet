//
//  UploadTaskTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 14-8-1.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UploadTaskTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView * thumbnailImageV;
@property (nonatomic,retain) NSString * publishID;
@property (nonatomic,retain) UIView * rePublishView;
- (void)setProgressSizeWithScale:(double)scale;
- (void)startAnimating;
@end
