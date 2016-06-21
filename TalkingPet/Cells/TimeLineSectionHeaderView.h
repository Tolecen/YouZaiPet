//
//  TimeLineSectionHeaderView.h
//  TalkingPet
//
//  Created by Tolecen on 15/1/31.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "Pet.h"
#import "Common.h"
@protocol TimeLineHeaderDelegate <NSObject>
@optional
-(void)headerClicked:(NSString *)petId;
@end
@interface TimeLineSectionHeaderView : UITableViewHeaderFooterView
@property (nonatomic,strong) EGOImageButton * publisherAvatarV;
@property (nonatomic,strong) UILabel * publisherNameL;
@property (nonatomic,strong) UIImageView * genderImageV;
@property (nonatomic,strong) UILabel * nameL;
@property (nonatomic,strong) UIImageView * timeBgV;
@property (nonatomic,strong) UILabel * timeL;
@property (nonatomic,strong) UILabel * browserNumL;
@property (nonatomic,strong) NSString * timeStr;
@property (nonatomic,strong) UIImage * timeBgImg;
@property (nonatomic,strong) Pet * petInfo;
@property (nonatomic,assign) BOOL ifForward;
@property (nonatomic,assign) int cellIndex;
@property (nonatomic,assign) id<TimeLineHeaderDelegate>delegate;
@property (nonatomic,assign) BOOL showTheHead;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier showHead:(BOOL)showHead;
@end
