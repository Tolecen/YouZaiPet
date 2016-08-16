//
//  HotViewController.m
//  TalkingPet
//
//  Created by wangxr on 15/5/13.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "HotViewController.h"
#import "MJRefresh.h"
#import "TalkingBrowse.h"
#import "PetalkView.h"
#import "EGOImageView.h"
#import "TalkingDetailPageViewController.h"
#import "RootViewController.h"
//#import "BrowserTableHelper.h"
@interface HotPetalkCell : UICollectionViewCell
@property (nonatomic,retain)PetalkView * petalkV;
@property (nonatomic,retain)EGOImageView * imageV;
@property (nonatomic,retain)EGOImageButton * headView;
@property (nonatomic,retain) TalkingBrowse * talking;
@property (nonatomic,retain)UILabel * desL;
@property (nonatomic,retain)UIButton * tagButton;
@property (nonatomic,retain)UILabel * tagLabel;
@property (nonatomic,retain)UILabel * zanL;
@property (nonatomic,retain)UILabel *commentL;
@property (nonatomic,retain)UIButton *zanButton;
@property (nonatomic,retain)UILabel * nameL;
@property (nonatomic,retain)UILabel *gradeL;

@property (nonatomic,strong)UIView * audioLengthView;
@property (nonatomic,retain)UILabel *audioL;

@property (nonatomic,copy)void(^HeadTapped) (TalkingBrowse *talkingBrowse);
-(void)layoutSubviewsManul;
@end
@implementation HotPetalkCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
        //        self.petalkV  = [[PetalkView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        //        [self.contentView addSubview:_petalkV];
        
        self.imageV = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        self.imageV.backgroundColor = [UIColor colorWithR:245 g:245 b:245 alpha:1];
        [self.contentView addSubview:self.imageV];
        
        self.audioLengthView = [[UIView alloc] initWithFrame:CGRectMake(8, 8, 50, 14)];
        self.audioLengthView.backgroundColor = CommonGreenColor;
        self.audioLengthView.layer.cornerRadius = 5;
        self.audioLengthView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.audioLengthView];
        
        UIImageView * p = [[UIImageView alloc] initWithFrame:CGRectMake(8, 3, 5, 7)];
        p.image = [UIImage imageNamed:@"bofang@2x"];
        [self.audioLengthView addSubview:p];
        
        self.audioL = [[UILabel alloc] initWithFrame:CGRectMake(50-5-30, 0, 30, self.audioLengthView.frame.size.height)];
        _audioL.backgroundColor = [UIColor clearColor];
        _audioL.font = [UIFont systemFontOfSize:10];
        _audioL.textColor = [UIColor whiteColor];
        _audioL.textAlignment = NSTextAlignmentRight;
        [self.audioLengthView addSubview:_audioL];
        _audioL.text = @"";
        _audioL.adjustsFontSizeToFitWidth = YES;
        
        self.desL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.imageV.frame)+5, frame.size.width-20, 40)];
        self.desL.backgroundColor = [UIColor clearColor];
        self.desL.textColor = [UIColor colorWithR:150 g:150 b:150 alpha:1];
        self.desL.font = [UIFont systemFontOfSize:13];
        self.desL.numberOfLines = 2;
        self.desL.lineBreakMode = NSLineBreakByCharWrapping;
        self.desL.text = @"要在这里添加描述哦哈哈急急急预约啊啊";
        [self.contentView addSubview:self.desL];
        
        
        self.tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.tagButton.frame = CGRectMake(10, CGRectGetMaxY(self.desL.frame)+6, frame.size.width-20, 14);
        self.tagButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.tagButton];
        
        UIImageView * tagimgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 10, 10)];
        tagimgv.image = [UIImage imageNamed:@"biaoqian@2x"];
        [self.tagButton addSubview:tagimgv];
        
        self.tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, frame.size.width-30, 14)];
        self.tagLabel.backgroundColor = [UIColor clearColor];
        self.tagLabel.textColor = [UIColor colorWithR:200 g:200 b:200 alpha:1];
        self.tagLabel.font = [UIFont systemFontOfSize:10];
        self.tagLabel.text = @"萌宠大比拼";
        [self.tagButton addSubview:self.tagLabel];
        
        UIImageView * zanimgv = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-35-10-35-10, CGRectGetMaxY(self.tagButton.frame)+12, 10, 10)];
        zanimgv.image = [UIImage imageNamed:@"zan@2x"];
        [self.contentView addSubview:zanimgv];
        
        self.zanL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(zanimgv.frame)+5, CGRectGetMaxY(self.tagButton.frame)+10, 30, 14)];
        self.zanL.backgroundColor = [UIColor clearColor];
        self.zanL.textColor = [UIColor colorWithR:200 g:200 b:200 alpha:1];
        self.zanL.font = [UIFont systemFontOfSize:11];
        self.zanL.text = @"120";
        self.zanL.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.zanL];
        
        UIImageView * cimgv = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-35-10, CGRectGetMaxY(self.tagButton.frame)+12, 10, 10)];
        cimgv.image = [UIImage imageNamed:@"pinglun@2x"];
        [self.contentView addSubview:cimgv];
        
        self.commentL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cimgv.frame)+5, CGRectGetMaxY(self.tagButton.frame)+10, 30, 14)];
        self.commentL.backgroundColor = [UIColor clearColor];
        self.commentL.textColor = [UIColor colorWithR:200 g:200 b:200 alpha:1];
        self.commentL.font = [UIFont systemFontOfSize:11];
        self.commentL.text = @"23";
        self.commentL.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.commentL];
        
        UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.commentL.frame)+6, frame.size.width-10, 1)];
        lineV.backgroundColor = [UIColor colorWithR:245 g:245 b:245 alpha:1];
        [self.contentView addSubview:lineV];
        
        
        self.headView = [[EGOImageButton alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(lineV.frame)+5, 36, 36)];
        _headView.backgroundColor = [UIColor colorWithR:245 g:245 b:245 alpha:1];
        _headView.layer.cornerRadius = 18;
        _headView.layer.masksToBounds=YES;
        [self.contentView addSubview:_headView];
        [self.headView addTarget:self action:@selector(headClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headView.frame)+7, CGRectGetMinY(self.headView.frame), frame.size.width-46-40, 18)];
        _nameL.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
        _nameL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_nameL];
        _nameL.text = @"小泥河";
        
        self.gradeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headView.frame)+7, CGRectGetMaxY(self.nameL.frame), self.nameL.frame.size.width, 18)];
        self.gradeL.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
        self.gradeL.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:self.gradeL];
        self.gradeL.text = @"LV.12";
        
        self.zanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.zanButton.frame = CGRectMake(frame.size.width-10-28, CGRectGetMinY(self.headView.frame)+7, 24, 22);
        [self.zanButton setBackgroundImage:[UIImage imageNamed:@"xihuan-off@2x"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.zanButton];
        [self.zanButton addTarget:self action:@selector(zanAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)headClicked:(UIButton *)sender
{
    if (self.HeadTapped) {
        self.HeadTapped(self.talking);
    }
}

-(void)layoutSubviewsManul
{
    //[super layoutSubviews];
    [self.imageV setImageWithURL:[NSURL URLWithString:self.talking.thumbImgUrl]];
    self.nameL.text = self.talking.petInfo.nickname;
    self.desL.text = self.talking.descriptionContent;
    self.gradeL.text = [NSString stringWithFormat:@"LV.%@",self.talking.petInfo.grade?self.talking.petInfo.grade:@"0"];
    [self.headView setImageURL:[NSURL URLWithString:[self.talking.petInfo.headImgURL stringByAppendingString:@"?imageView2/2/w/60"]]];
    
    self.zanL.text = self.talking.favorNum;
    self.commentL.text = self.talking.commentNum;
    
    if (self.talking.audioUrl && self.talking.audioUrl.length>1) {
        self.audioLengthView.hidden = NO;
        _audioL.text = [NSString stringWithFormat:@"%.1f\"",[self.talking.audioDuration floatValue]];
    }
    else
        self.audioLengthView.hidden = YES;
    
    self.tagLabel.text = [[self.talking.tagArray firstObject] objectForKey:@"name"];
    
    if (self.talking.ifZan) {
        [self.zanButton setBackgroundImage:[UIImage imageNamed:@"xihuan-on@2x"] forState:UIControlStateNormal];
    }
    else
        [self.zanButton setBackgroundImage:[UIImage imageNamed:@"xihuan-off@2x"] forState:UIControlStateNormal];
}

-(void)zanAction:(UIButton *)sender
{
    NSString * currentUserId = [UserServe sharedUserServe].userID;
    if (!currentUserId) {
        if (![RootViewController sharedRootViewController].presentedViewController) {
            [[RootViewController sharedRootViewController] showLoginViewController];
        }
        return;
    }
    
    
    if (self.talking.ifZan) {
        //        return;
        [self.zanButton setBackgroundImage:[UIImage imageNamed:@"xihuan-off@2x"] forState:UIControlStateNormal];
        self.talking.ifZan = NO;
        self.zanButton.enabled = NO;
        
        self.zanL.text =[NSString stringWithFormat:@"%d",[self.zanL.text intValue]>0?([self.zanL.text intValue]-1):0];
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"interaction" forKey:@"command"];
        [mDict setObject:@"cancelFavour" forKey:@"options"];
        [mDict setObject:self.talking.theID forKey:@"petalkId"];
        [mDict setObject:@"F" forKey:@"type"];
        [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"userId"];
        
        
        NSLog(@"cancelFavor:%@",mDict);
        [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"cancel favor success:%@",responseObject);
            
            self.zanButton.enabled = YES;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"cancel favor error:%@",error);
            self.zanButton.enabled = YES;
        }];
    }
    else{
        self.talking.ifZan = YES;
        self.zanButton.enabled = NO;
        
        //        [self performSelector:@selector(zanMakeBig) withObject:nil afterDelay:0.2];
        //        [self zanMakeBig];
        [self.zanButton setBackgroundImage:[UIImage imageNamed:@"xihuan-on@2x"] forState:UIControlStateNormal];
        self.zanL.text =[NSString stringWithFormat:@"%d",[self.zanL.text intValue]+1];
        
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"interaction" forKey:@"command"];
        [mDict setObject:@"create" forKey:@"options"];
        [mDict setObject:self.talking.theID forKey:@"petalkId"];
        [mDict setObject:@"F" forKey:@"type"];
        [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"userId"];
        
        
        NSLog(@"doFavor:%@",mDict);
        [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            self.zanButton.enabled = YES;
            NSLog(@"favor success:%@",responseObject);
            if ([responseObject objectForKey:@"message"]) {
                if([[responseObject objectForKey:@"message"] rangeOfString:@"("].location !=NSNotFound)
                {
                    [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
                }
                else{
                    
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"favor error:%@",error);
            self.zanButton.enabled = YES;
        }];
    }
    
    
}
@end

@interface HotJingYanCell : UICollectionViewCell
//@property (nonatomic,retain)PetalkView * petalkV;
@property (nonatomic,retain)EGOImageView * imageV;
@property (nonatomic,retain)EGOImageButton * headView;
@property (nonatomic,retain) TalkingBrowse * talking;
@property (nonatomic,retain)UILabel * desL;
@property (nonatomic,retain)UIButton * tagButton;
@property (nonatomic,retain)UILabel * tagLabel;
@property (nonatomic,retain)UILabel * zanL;
@property (nonatomic,retain)UILabel *commentL;
@property (nonatomic,retain)UILabel *liulanL;
@property (nonatomic,retain)UIButton *zanButton;
@property (nonatomic,retain)UILabel * nameL;
@property (nonatomic,retain)UILabel *gradeL;



@property (nonatomic,copy)void(^HeadTapped) (TalkingBrowse *talkingBrowse);
-(void)layoutSubviewsManul;
@end
@implementation HotJingYanCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
        //        self.petalkV  = [[PetalkView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        //        [self.contentView addSubview:_petalkV];
        
        self.imageV = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        self.imageV.backgroundColor = [UIColor colorWithR:245 g:245 b:245 alpha:1];
        [self.contentView addSubview:self.imageV];
        
        UIImageView * jbiaoqian = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-28, frame.size.width-28, 23, 23)];
        [jbiaoqian setImage:[UIImage imageNamed:@"jingyanbiaoqian"]];
        [self.contentView addSubview:jbiaoqian];
        
        
        
        self.desL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.imageV.frame)+5, frame.size.width-20, 40)];
        self.desL.backgroundColor = [UIColor clearColor];
        self.desL.textColor = CommonGreenColor;
        self.desL.font = [UIFont systemFontOfSize:13];
        self.desL.numberOfLines = 2;
        self.desL.lineBreakMode = NSLineBreakByCharWrapping;
        self.desL.text = @"要在这里添加描述哦哈哈急急急预约啊啊";
        [self.contentView addSubview:self.desL];
        
        
        self.headView = [[EGOImageButton alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(self.desL.frame)+5, 36, 36)];
        _headView.backgroundColor = [UIColor colorWithR:245 g:245 b:245 alpha:1];
        _headView.layer.cornerRadius = 18;
        _headView.layer.masksToBounds=YES;
        [self.contentView addSubview:_headView];
        [self.headView addTarget:self action:@selector(headClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headView.frame)+7, CGRectGetMinY(self.headView.frame), frame.size.width-46-40, 18)];
        _nameL.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
        _nameL.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_nameL];
        _nameL.text = @"啦啦啦";
        
        self.gradeL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headView.frame)+7, CGRectGetMaxY(self.nameL.frame), self.nameL.frame.size.width, 18)];
        self.gradeL.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
        self.gradeL.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:self.gradeL];
        self.gradeL.text = @"LV.7";
        
        self.zanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.zanButton.frame = CGRectMake(frame.size.width-10-28, CGRectGetMinY(self.headView.frame)+7, 24, 22);
        [self.zanButton setBackgroundImage:[UIImage imageNamed:@"xihuan-off@2x"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.zanButton];
        [self.zanButton addTarget:self action:@selector(zanAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView * zanimgv = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.gradeL.frame)+12, 10, 10)];
        zanimgv.image = [UIImage imageNamed:@"zan@2x"];
        [self.contentView addSubview:zanimgv];
        
        self.zanL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(zanimgv.frame)+5, CGRectGetMaxY(self.gradeL.frame)+10, 30, 14)];
        self.zanL.backgroundColor = [UIColor clearColor];
        self.zanL.textColor = [UIColor colorWithR:200 g:200 b:200 alpha:1];
        self.zanL.font = [UIFont systemFontOfSize:11];
        self.zanL.text = @"120";
        self.zanL.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.zanL];
        
        UIImageView * cimgv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.zanL.frame), CGRectGetMaxY(self.gradeL.frame)+12, 10, 10)];
        cimgv.image = [UIImage imageNamed:@"pinglun@2x"];
        [self.contentView addSubview:cimgv];
        
        self.commentL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cimgv.frame)+5, CGRectGetMaxY(self.gradeL.frame)+10, 30, 14)];
        self.commentL.backgroundColor = [UIColor clearColor];
        self.commentL.textColor = [UIColor colorWithR:200 g:200 b:200 alpha:1];
        self.commentL.font = [UIFont systemFontOfSize:11];
        self.commentL.text = @"23";
        self.commentL.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.commentL];
        
        UIImageView * limgv = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.commentL.frame), CGRectGetMaxY(self.gradeL.frame)+12, 10, 10)];
        limgv.image = [UIImage imageNamed:@"liulanliang-hui@2x"];
        [self.contentView addSubview:limgv];
        
        self.liulanL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(limgv.frame)+5, CGRectGetMaxY(self.gradeL.frame)+10, 30, 14)];
        self.liulanL.backgroundColor = [UIColor clearColor];
        self.liulanL.textColor = [UIColor colorWithR:200 g:200 b:200 alpha:1];
        self.liulanL.font = [UIFont systemFontOfSize:11];
        self.liulanL.text = @"223";
        self.liulanL.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.liulanL];
        
    }
    return self;
}

-(void)headClicked:(UIButton *)sender
{
    if (self.HeadTapped) {
        self.HeadTapped(self.talking);
    }
}

-(void)layoutSubviewsManul
{
    //    [super layoutSubviews];
    [self.imageV setImageWithURL:[NSURL URLWithString:[self.talking.thumbImgUrl stringByAppendingString:@"?imageView2/1/w/400/h/400"]]];
    self.nameL.text = self.talking.petInfo.nickname;
    self.desL.text = [@"  " stringByAppendingString:self.talking.descriptionContent];
    self.gradeL.text = [NSString stringWithFormat:@"LV.%@",self.talking.petInfo.grade?self.talking.petInfo.grade:@"0"];
    [self.headView setImageURL:[NSURL URLWithString:[self.talking.petInfo.headImgURL stringByAppendingString:@"?imageView2/2/w/60"]]];
    
    self.zanL.text = self.talking.favorNum;
    self.commentL.text = self.talking.commentNum;
    self.liulanL.text = self.talking.browseNum;
    
    if (self.talking.ifZan) {
        [self.zanButton setBackgroundImage:[UIImage imageNamed:@"xihuan-on@2x"] forState:UIControlStateNormal];
    }
    else
        [self.zanButton setBackgroundImage:[UIImage imageNamed:@"xihuan-off@2x"] forState:UIControlStateNormal];
    
    //    self.tagLabel.text = [[self.talking.tagArray firstObject] objectForKey:@"name"];
    
}

-(void)zanAction:(UIButton *)sender
{
    NSString * currentUserId = [UserServe sharedUserServe].userID;
    if (!currentUserId) {
        if (![RootViewController sharedRootViewController].presentedViewController) {
            [[RootViewController sharedRootViewController] showLoginViewController];
        }
        return;
    }
    
    
    if (self.talking.ifZan) {
        //        return;
        [self.zanButton setBackgroundImage:[UIImage imageNamed:@"xihuan-off@2x"] forState:UIControlStateNormal];
        self.talking.ifZan = NO;
        self.zanButton.enabled = NO;
        
        self.zanL.text =[NSString stringWithFormat:@"%d",[self.zanL.text intValue]>0?([self.zanL.text intValue]-1):0];
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"interaction" forKey:@"command"];
        [mDict setObject:@"cancelFavour" forKey:@"options"];
        [mDict setObject:self.talking.theID forKey:@"petalkId"];
        [mDict setObject:@"F" forKey:@"type"];
        [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"userId"];
        
        
        NSLog(@"cancelFavor:%@",mDict);
        [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"cancel favor success:%@",responseObject);
            
            self.zanButton.enabled = YES;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"cancel favor error:%@",error);
            self.zanButton.enabled = YES;
        }];
    }
    else{
        self.talking.ifZan = YES;
        self.zanButton.enabled = NO;
        
        //        [self performSelector:@selector(zanMakeBig) withObject:nil afterDelay:0.2];
        //        [self zanMakeBig];
        [self.zanButton setBackgroundImage:[UIImage imageNamed:@"xihuan-on@2x"] forState:UIControlStateNormal];
        self.zanL.text =[NSString stringWithFormat:@"%d",[self.zanL.text intValue]+1];
        
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"interaction" forKey:@"command"];
        [mDict setObject:@"create" forKey:@"options"];
        [mDict setObject:self.talking.theID forKey:@"petalkId"];
        [mDict setObject:@"F" forKey:@"type"];
        [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"userId"];
        
        
        NSLog(@"doFavor:%@",mDict);
        [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            self.zanButton.enabled = YES;
            NSLog(@"favor success:%@",responseObject);
            if ([responseObject objectForKey:@"message"]) {
                if([[responseObject objectForKey:@"message"] rangeOfString:@"("].location !=NSNotFound)
                {
                    [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
                }
                else{
                    
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"favor error:%@",error);
            self.zanButton.enabled = YES;
        }];
    }
    
    
}

@end

static NSString * hotcellId = @"hotcell";
static NSString * jycellId = @"jycell";
@interface HotViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    int page;
    int jyPage;
    
    int listType;
    
    BOOL shuoshuoLoaded;
    BOOL jyLoaded;
}
@property (nonatomic,retain)NSMutableArray * dataArr;
@property (nonatomic,strong)NSMutableArray * jyArray;

@property (nonatomic,strong)UIView * topSelV;
@property (nonatomic,strong)UIImageView * zhiV;
@property (nonatomic,strong)UIButton *shuoshuoBtn;
@property (nonatomic,strong)UIButton *jingyanBtn;
@property (nonatomic,strong)UILabel * ssbtnL;
@property (nonatomic,strong)UILabel * jybtnL;

@end
@implementation HotViewController
-(void)viewDidLoad
{
    page = 1;
    jyPage = 1;
    
    listType = 1;
    
    NSArray * baseArr = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"hotListShuoShuo%@",[UserServe sharedUserServe].userID]];
    self.dataArr = [NSMutableArray array];
    for (NSDictionary * dic in baseArr) {
        TalkingBrowse * petalk = [[TalkingBrowse alloc] initWithHostInfo:dic];
        [_dataArr addObject:petalk];
    }
    
    NSArray * baseArr2 = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"hotListJY%@",[UserServe sharedUserServe].userID]];
    self.jyArray = [NSMutableArray array];
    for (NSDictionary * dic in baseArr2) {
        TalkingBrowse * petalk = [[TalkingBrowse alloc] initWithHostInfo:dic];
        [_jyArray addObject:petalk];
    }
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
    float whith = (self.view.frame.size.width-30)/2;
    layout.itemSize = CGSizeMake(whith,whith+5+40+10+10+10+10+10+40+10);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.hotView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight) collectionViewLayout:layout];
    _hotView.alwaysBounceVertical = YES;
    _hotView.delegate = self;
    _hotView.dataSource = self;
    _hotView.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1];
    [self.view addSubview:_hotView];
    _hotView.showsHorizontalScrollIndicator = NO;
    [_hotView registerClass:[HotPetalkCell class] forCellWithReuseIdentifier:hotcellId];
    
    [_hotView addHeaderWithTarget:self action:@selector(shuoshuoHeaderDo)];
    [_hotView addFooterWithTarget:self action:@selector(shuoshuoFooterDo)];
    
    
    UICollectionViewFlowLayout* layout2 = [[UICollectionViewFlowLayout alloc]init];
    //    float width = (self.view.frame.size.width-30)/2;
    layout2.itemSize = CGSizeMake(whith,whith+5+40+10+10+10+10+40);
    layout2.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout2.minimumInteritemSpacing = 10;
    layout2.minimumLineSpacing = 10;
    layout2.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    
    self.jingyanView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight) collectionViewLayout:layout2];
    _jingyanView.alwaysBounceVertical = YES;
    _jingyanView.delegate = self;
    _jingyanView.dataSource = self;
    _jingyanView.backgroundColor = [UIColor colorWithWhite:238/255.0 alpha:1];
    [self.view addSubview:_jingyanView];
    _jingyanView.showsHorizontalScrollIndicator = NO;
    [_jingyanView registerClass:[HotJingYanCell class] forCellWithReuseIdentifier:jycellId];
    
    [_jingyanView addHeaderWithTarget:self action:@selector(jyHeaderDo)];
    [_jingyanView addFooterWithTarget:self action:@selector(jyFooterDo)];
    _jingyanView.hidden = YES;
    
    
    //    self.contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight)];
    //    _contentTableView.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
    //    _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ////    _contentTableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    //    [self.view addSubview:_contentTableView];
    //    _contentTableView.hidden = YES;
    //
    //    self.tableViewHelper = [[BrowserTableHelper alloc] initWithController:self Tableview:_contentTableView SectionView:nil];
    //    _contentTableView.delegate = self.tableViewHelper;
    //    _contentTableView.dataSource = self.tableViewHelper;
    //    self.tableViewHelper.cellNeedShowPublishTime = NO;
    //    self.tableViewHelper.tableViewType = TableViewTypeTagList;
    
    //    NSArray * hotArray = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"hotList%@",[UserServe sharedUserServe].userID]];
    //    NSDictionary * hotReqDict = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"hotListReqDict%@",[UserServe sharedUserServe].userID]];
    //    if (hotArray&&hotReqDict) {
    //        self.tableViewHelper.dataArray = [self.tableViewHelper getModelArray:hotArray];
    //        self.tableViewHelper.reqDict = [NSMutableDictionary dictionaryWithDictionary:hotReqDict];
    //        [self.contentTableView reloadData];
    //
    //    }
    
    
    
    //    NSMutableDictionary* mDict = [NetServer commonDict];
    //    [mDict setObject:@"petalk" forKey:@"command"];
    //    [mDict setObject:@"hotList" forKey:@"options"];
    //    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"userId"];
    //    [mDict setObject:@"10" forKey:@"pageSize"];
    //    [mDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"pageIndex"];
    //
    //    self.tableViewHelper.reqDict = mDict;
    //
    //    [self.contentTableView headerBeginRefreshing];
    //顶部视图
    [self addTopSelView];
    
    
    [self.hotView headerBeginRefreshing];
    //    [self.tableViewHelper loadFirstDataPageWithDict:mDict];
}

-(void)addTopSelView
{
    self.topSelV = [[UIView alloc] initWithFrame:CGRectMake(0, -70, ScreenWidth, 100)];
    self.topSelV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.topSelV];
    
    UIView * bgav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
    bgav.backgroundColor = [UIColor whiteColor];
    [self.topSelV addSubview:bgav];
    
    self.shuoshuoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shuoshuoBtn setBackgroundImage:[UIImage imageNamed:@"chongyoudongtai-on@2x"] forState:UIControlStateNormal];
    [_shuoshuoBtn setFrame:CGRectMake(ScreenWidth/4-15, 10, 30, 30)];
    [self.topSelV addSubview:_shuoshuoBtn];
    [_shuoshuoBtn addTarget:self action:@selector(showShuoShuoTable) forControlEvents:UIControlEventTouchUpInside];
    
    _ssbtnL = [[UILabel alloc] initWithFrame:CGRectMake(_shuoshuoBtn.frame.origin.x-10, CGRectGetMaxY(_shuoshuoBtn.frame)+5, _shuoshuoBtn.frame.size.width+20, 20)];
    _ssbtnL.textColor = CommonGreenColor;
    _ssbtnL.font = [UIFont systemFontOfSize:12];
    _ssbtnL.text = @"宠物动态";
    _ssbtnL.textAlignment = NSTextAlignmentCenter;
    [self.topSelV addSubview:_ssbtnL];
    
    _jingyanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_jingyanBtn setBackgroundImage:[UIImage imageNamed:@"yangchongfenxiang-off@2x"] forState:UIControlStateNormal];
    [_jingyanBtn setFrame:CGRectMake(3*(ScreenWidth/4)-15, 10, 30, 30)];
    [self.topSelV addSubview:_jingyanBtn];
    [_jingyanBtn addTarget:self action:@selector(showJingYanTable) forControlEvents:UIControlEventTouchUpInside];
    
    _jybtnL = [[UILabel alloc] initWithFrame:CGRectMake(_jingyanBtn.frame.origin.x-10, CGRectGetMaxY(_jingyanBtn.frame)+5, _jingyanBtn.frame.size.width+20, 20)];
    _jybtnL.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
    _jybtnL.font = [UIFont systemFontOfSize:12];
    _jybtnL.text = @"养宠分享";
    _jybtnL.textAlignment = NSTextAlignmentCenter;
    [self.topSelV addSubview:_jybtnL];
    
    UIButton * buttonSel = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonSel setBackgroundImage:[UIImage imageNamed:@"shouye_more@2x"] forState:UIControlStateNormal];
    [buttonSel setFrame:CGRectMake(ScreenWidth/2-40, CGRectGetMaxY(bgav.frame), 80, 25)];
    [self.topSelV addSubview:buttonSel];
    [buttonSel addTarget:self action:@selector(showOrHideTopSelV) forControlEvents:UIControlEventTouchUpInside];
    [self showOrHideTopSelV];
    self.zhiV = [[UIImageView alloc] initWithFrame:CGRectMake(65/2, 5, 15, 5)];
    self.zhiV.image = [UIImage imageNamed:@"xiala@2x"];
    [buttonSel addSubview:self.zhiV];
    self.zhiV.userInteractionEnabled = NO;
    
}
-(void)showOrHideTopSelV
{
    if (self.topSelV.frame.origin.y==0) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.topSelV setFrame:CGRectMake(0, -70, ScreenWidth, 100)];
        } completion:^(BOOL finished) {
            self.zhiV.image = [UIImage imageNamed:@"xiala@2x"];
        }];
        
    }
    else if(self.topSelV.frame.origin.y==-70){
        [UIView animateWithDuration:0.3 animations:^{
            [self.topSelV setFrame:CGRectMake(0, 0, ScreenWidth, 100)];
        } completion:^(BOOL finished) {
            self.zhiV.image = [UIImage imageNamed:@"shouqi@2x"];
        }];
    }
    
    
}
-(void)showShuoShuoTable
{
    listType = 1;
    [_shuoshuoBtn setBackgroundImage:[UIImage imageNamed:@"chongyoudongtai-on@2x"] forState:UIControlStateNormal];
    [_jingyanBtn setBackgroundImage:[UIImage imageNamed:@"yangchongfenxiang-off@2x"] forState:UIControlStateNormal];
    _ssbtnL.textColor = CommonGreenColor;
    _jybtnL.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
    self.hotView.hidden = NO;
    self.jingyanView.hidden = YES;
    //[self showOrHideTopSelV];
    
    if (!shuoshuoLoaded) {
        [_hotView headerBeginRefreshing];
    }
}
-(void)showJingYanTable
{
    listType = 2;
    [_shuoshuoBtn setBackgroundImage:[UIImage imageNamed:@"chongyoudongtai-off@2x"] forState:UIControlStateNormal];
    [_jingyanBtn setBackgroundImage:[UIImage imageNamed:@"yangchongfenxiang-on@2x"] forState:UIControlStateNormal];
    _ssbtnL.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1];
    _jybtnL.textColor = CommonGreenColor;
    self.hotView.hidden = YES;
    self.jingyanView.hidden = NO;
    //[self showOrHideTopSelV];
    
    if (!jyLoaded) {
        [_jingyanView headerBeginRefreshing];
    }
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    //    [self.contentTableView setFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight)];
    [self.hotView setFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight)];
    [self.jingyanView setFrame:CGRectMake(0, 0, ScreenWidth, self.view.frame.size.height-navigationBarHeight)];
}
- (void)beginRefreshing
{
    //    [_hotView headerBeginRefreshing];
    [self.contentTableView headerBeginRefreshing];
}

-(void)shuoshuoHeaderDo
{
    page = 1;
    [self getHotShuoshuoList];
}
-(void)shuoshuoFooterDo
{
    [self getHotShuoshuoList];
}



-(void)jyHeaderDo
{
    jyPage = 1;
    [self getHotJYList];
}
-(void)jyFooterDo
{
    [self getHotJYList];
}

-(void)getHotShuoshuoList
{
    
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"petalk" forKey:@"command"];
    [mDict setObject:@"channel" forKey:@"options"];
    [mDict setObject:@"hot" forKey:@"code"];
    [mDict setObject:@"1" forKey:@"type"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"userId"];
    [mDict setObject:@"10" forKey:@"pageSize"];
    [mDict setObject:[NSString stringWithFormat:@"%d",page] forKey:@"pageIndex"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        [_hotView headerEndRefreshing];
        [_hotView footerEndRefreshing];
        NSArray * array = [responseObject[@"value"] objectForKey:@"list"];
        
        if (page==1) {
            shuoshuoLoaded = YES;
            [_dataArr removeAllObjects];
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:[NSString stringWithFormat:@"hotListShuoShuo%@",[UserServe sharedUserServe].userID]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        for (NSDictionary * dic in array) {
            TalkingBrowse * petalk = [[TalkingBrowse alloc] initWithHostInfo:dic];
            [_dataArr addObject:petalk];
        }
        [_hotView reloadData];
        page++;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_hotView headerEndRefreshing];
        [_hotView footerEndRefreshing];
    }];
}
-(void)getHotJYList
{
    
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"petalk" forKey:@"command"];
    [mDict setObject:@"channel" forKey:@"options"];
    [mDict setObject:@"hotstory" forKey:@"code"];
    [mDict setObject:@"2" forKey:@"type"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"userId"];
    [mDict setObject:@"10" forKey:@"pageSize"];
    [mDict setObject:[NSString stringWithFormat:@"%d",jyPage] forKey:@"pageIndex"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        [_jingyanView headerEndRefreshing];
        [_jingyanView footerEndRefreshing];
        NSArray * array = [responseObject[@"value"] objectForKey:@"list"];
        
        if (jyPage==1) {
            jyLoaded = YES;
            [_jyArray removeAllObjects];
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:[NSString stringWithFormat:@"hotListJY%@",[UserServe sharedUserServe].userID]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        for (NSDictionary * dic in array) {
            TalkingBrowse * petalk = [[TalkingBrowse alloc] initWithHostInfo:dic];
            [_jyArray addObject:petalk];
        }
        [_jingyanView reloadData];
        jyPage++;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_jingyanView headerEndRefreshing];
        [_jingyanView footerEndRefreshing];
    }];
}


#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:_hotView]) {
        return _dataArr.count;
    }
    else
        return _jyArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    TalkingBrowse * petalk = _dataArr[indexPath.row];
    if ([collectionView isEqual:_hotView]) {
        //        static NSString *SectionCellIdentifier = @"HotPetalkCell";
        HotPetalkCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hotcellId forIndexPath:indexPath];
        //    [cell.petalkV layoutSubviewsWithTalking:petalk];
        //    cell.headView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/50",petalk.petInfo.headImgURL]];
        //    cell.nameL.text = petalk.petInfo.nickname;
        //    cell.timesL.text = [NSString stringWithFormat:@"%@人浏览",petalk.browseNum];
        cell.HeadTapped = ^(TalkingBrowse *talkingBrowse){
            [self toUserPageWithBrowse:talkingBrowse];
        };
        cell.talking = _dataArr[indexPath.row];
        [cell layoutSubviewsManul];
        return cell;
    }
    else
    {
        //        static NSString *SectionCellIdentifier2 = @"JingyanPetalkCell";
        HotJingYanCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:jycellId forIndexPath:indexPath];
        //    [cell.petalkV layoutSubviewsWithTalking:petalk];
        //    cell.headView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/50",petalk.petInfo.headImgURL]];
        //    cell.nameL.text = petalk.petInfo.nickname;
        //    cell.timesL.text = [NSString stringWithFormat:@"%@人浏览",petalk.browseNum];
        cell.HeadTapped = ^(TalkingBrowse *talkingBrowse){
            [self toUserPageWithBrowse:talkingBrowse];
        };
        cell.talking = _jyArray[indexPath.row];
        [cell layoutSubviewsManul];
        return cell;
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TalkingDetailPageViewController * talkingDV = [[TalkingDetailPageViewController alloc] init];
    if (listType==1) {
        talkingDV.talking = _dataArr[indexPath.row];
    }
    else
        talkingDV.talking = _jyArray[indexPath.row];
    
    
    [self.parentViewController.navigationController pushViewController:talkingDV animated:YES];
}

-(void)toUserPageWithBrowse: (TalkingBrowse *)talkingBrowse
{
    PersonProfileViewController * pv = [[PersonProfileViewController alloc] init];
    pv.petId = talkingBrowse.petInfo.petID;
    pv.petAvatarUrlStr = talkingBrowse.petInfo.headImgURL;
    pv.petNickname = talkingBrowse.petInfo.nickname;
    pv.relationShip = talkingBrowse.relationShip;
    
    [self.navigationController pushViewController:pv animated:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.topSelV.frame.origin.y==0) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.topSelV setFrame:CGRectMake(0, -70, ScreenWidth, 100)];
        } completion:^(BOOL finished) {
            self.zhiV.image = [UIImage imageNamed:@"xiala@2x"];
        }];
        
    }
}
@end
