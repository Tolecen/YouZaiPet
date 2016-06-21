//
//  HuDongListTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 15/3/27.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "EGOImageView.h"
@class RootViewController;
@protocol HuDongListCellDelegate <NSObject>

-(void)resetDictForSection:(int)section row:(int)row dict:(NSDictionary *)dict;
-(void)touchedUserId:(NSString *)uid;

@end
@interface HuDongListTableViewCell : UITableViewCell
{
    NSDateFormatter *formatter;
}
@property (nonatomic,strong)EGOImageButton * publisherAvatarV;
@property (nonatomic,strong)UIImageView * genderImageV;
@property (nonatomic,strong)UILabel * publisherNameL;
@property (nonatomic,strong)UILabel * timeL;
@property (nonatomic,strong)UIButton *favorBtn;
@property (nonatomic,strong)UIImageView * favorImgV;
@property (nonatomic,strong)UILabel * favorLabel;
@property (nonatomic,strong)UILabel * contentL;
@property (nonatomic,strong)UIImageView * commentBg;
@property (nonatomic,strong)UIView * lineV;
@property (nonatomic,strong)UILabel * commentUser1;
@property (nonatomic,strong)UILabel * commentUser2;
@property (nonatomic,strong)UILabel * commentL1;
@property (nonatomic,strong)UILabel * commentL2;
@property (nonatomic,strong)UILabel * allCL;
@property (nonatomic,strong)UIImageView * commentIconV;
@property (nonatomic,strong)NSDictionary * contentDict;
@property (nonatomic,strong)NSArray * commentArray;
@property (nonatomic,strong)NSArray * imageArray;
@property (nonatomic,strong)EGOImageView * firstImgV;
@property (nonatomic,strong)UILabel * numL;
@property (nonatomic,assign)int cellIndex;
@property (nonatomic,assign)int cellSection;
@property (nonatomic,assign) id <HuDongListCellDelegate> delegate;
//@property (nonatomic,strong)
@end
