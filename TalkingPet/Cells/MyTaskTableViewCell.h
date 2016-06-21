//
//  MyTaskTableViewCell.h
//  TalkingPet
//
//  Created by Tolecen on 15/3/12.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ReSetTimeDelegate <NSObject>

@optional
-(void)resetTimeforIndex:(int)index Time:(NSString *)time;
-(void)toPageForType:(int)type TagId:(NSString *)tagId;
-(void)toTheRulePage;
@end
@interface MyTaskTableViewCell : UITableViewCell
{
    NSTimer * remainTimer;
}
@property (nonatomic,strong) UIImageView * bgImageV;
@property (nonatomic,strong) UILabel * nameL;
@property (nonatomic,strong) UILabel * desL;
@property (nonatomic,strong) UILabel * prizeL;
@property (nonatomic,strong) UILabel * timeL;
@property (nonatomic,strong) UILabel * noPubL;
@property (nonatomic,strong) UIButton * pubBtn;
@property (nonatomic,strong) UIImageView * statusImageV;
@property (nonatomic,strong) NSDictionary * actDict;
@property (nonatomic,assign) int status;
@property (nonatomic,assign) int cellIndex;
@property (nonatomic,strong) NSString * remainTime;
@property (nonatomic,assign) double hremianTimeS;
@property (nonatomic,assign) id <ReSetTimeDelegate>delegate;
@property (nonatomic,strong) UIButton * ruleBtn;
@end
