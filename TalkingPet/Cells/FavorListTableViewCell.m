//
//  FavorListTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 14-7-15.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "FavorListTableViewCell.h"
#import "RootViewController.h"
#import "SVProgressHUD.h"
@implementation FavorListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.commentAvatarV = [[EGOImageButton alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        [self.commentAvatarV setBackgroundColor:[UIColor grayColor]];
        //        [self.commentAvatarV setImage:[UIImage imageNamed:@"gougouAvatar.jpeg"]];
        [self.commentAvatarV setBackgroundImage:[UIImage imageNamed:@"placeholderHead.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.commentAvatarV];
        [self.commentAvatarV addTarget:self action:@selector(headBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView * avatarbg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        [avatarbg setImage:[UIImage imageNamed:@"avatarbg2"]];
        [self.contentView addSubview:avatarbg];
        
        self.commentNameL = [[UILabel alloc] initWithFrame:CGRectMake(70, 25, 200, 20)];
        [self.commentNameL setBackgroundColor:[UIColor clearColor]];
        [self.commentNameL setFont:[UIFont systemFontOfSize:17]];
        [self.commentNameL setText:@"你是二货啊"];
        [self.contentView addSubview:self.commentNameL];
        
        self.relationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.relationBtn setFrame:CGRectMake(ScreenWidth-10-72, 23, 72, 24.5)];
        [self.relationBtn setBackgroundImage:[UIImage imageNamed:@"guanzhu2"] forState:UIControlStateNormal];
        [self.relationBtn setTitle:@"+关注" forState:UIControlStateNormal];
        [self.relationBtn setTitleColor:[UIColor colorWithRed:0.235 green:0.776 blue:1 alpha:1] forState:UIControlStateNormal];
        [self.relationBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:self.relationBtn];
        [self.relationBtn addTarget:self action:@selector(attentionBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
//        self.darenV = [[UIImageView alloc] initWithFrame:CGRectMake(10+50-17, 10+50-17, 17, 17)];
//        [self.darenV setImage:[UIImage imageNamed:@"daren"]];
//        [self.contentView addSubview:self.darenV];

        
    }
    return self;
}

-(void)headBtnClicked
{
    if (_delegate&& [_delegate respondsToSelector:@selector(toUserPage:)]) {
        [_delegate toUserPage:self.favorDict];
    }
    
}
-(void)attentionBtnClicked
{
    if ([self.relationShip isEqualToString:@"0"]) {
        [self doAttention];
    }
    else
        [self cancelAttention];
    
}
-(void)doAttention
{
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"petfans" forKey:@"command"];
    [mDict setObject:@"focus" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"fansId"];
    [mDict setObject:[self.favorDict objectForKey:@"petId"] forKey:@"userId"];
    
    //    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    NSLog(@"focus user:%@",mDict);
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"error"] isEqualToString:@"200"]) {
            
            self.relationShip = @"1";
            NSMutableDictionary * fdict = [NSMutableDictionary dictionaryWithDictionary:self.favorDict];
            [fdict setObject:@"1" forKey:@"rs"];
            [self.relationBtn setBackgroundImage:[UIImage imageNamed:@"guanzhued"] forState:UIControlStateNormal];
            [self.relationBtn setTitle:@"已关注" forState:UIControlStateNormal];
            
            
            [self.relationBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            //            self.relationBtn.enabled = NO;
            if (_delegate&& [_delegate respondsToSelector:@selector(attentionDelegate:Index:)]) {
                [_delegate attentionDelegate:fdict Index:self.cellIndex];
            }
            //            [self.hotTableView reloadData];
            
            if ([responseObject objectForKey:@"message"]) {
                [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
            }
        }
        //        [self.delegate attentionPetWithTalkingBrowse:self.talking];
        NSLog(@"focus user success:%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"focus user failed error:%@",error);
        
    }];
    
}
-(void)cancelAttention
{
    NSString * currentPetId = [UserServe sharedUserServe].userID;
    if (!currentPetId) {
        [[RootViewController sharedRootViewController] showLoginViewController];
        return;
    }
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"petfans" forKey:@"command"];
    [mDict setObject:@"cancelFocus" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"fansPetId"];
    [mDict setObject:[self.favorDict objectForKey:@"petId"] forKey:@"petId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.relationShip = @"0";
        [self.relationBtn setBackgroundImage:[UIImage imageNamed:@"guanzhu_normal"] forState:UIControlStateNormal];
        [self.relationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.relationBtn setTitle:@"+关注" forState:UIControlStateNormal];
        NSMutableDictionary * fdict = [NSMutableDictionary dictionaryWithDictionary:self.favorDict];
        [fdict setObject:@"0" forKey:@"rs"];
        if (_delegate&& [_delegate respondsToSelector:@selector(attentionDelegate:Index:)]) {
            [_delegate attentionDelegate:fdict Index:self.cellIndex];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.commentAvatarV.imageURL = [NSURL URLWithString:[[self.favorDict objectForKey:@"petHeadPortrait"] stringByAppendingString:@"?imageView2/2/w/80"]];
    self.commentNameL.text = [self.favorDict objectForKey:@"petNickname"];
    self.relationShip = [self.favorDict objectForKey:@"rs"];
    
    if ([self.relationShip isEqualToString:@"0"]) {
        self.relationBtn.hidden = NO;
        
        [self.relationBtn setBackgroundImage:[UIImage imageNamed:@"guanzhu2"] forState:UIControlStateNormal];
        [self.relationBtn setTitleColor:[UIColor colorWithRed:0.235 green:0.776 blue:1 alpha:1] forState:UIControlStateNormal];
        
        [self.relationBtn setTitle:@"+关注" forState:UIControlStateNormal];
        
        self.relationBtn.enabled = YES;
    }
    else if ([self.relationShip isEqualToString:@"1"]){
        self.relationBtn.hidden = NO;
        [self.relationBtn setBackgroundImage:[UIImage imageNamed:@"guanzhued"] forState:UIControlStateNormal];
        [self.relationBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [self.relationBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        //        self.relationBtn.enabled = NO;
    }
    else if ([self.relationShip isEqualToString:@"2"]){
        self.relationBtn.hidden = NO;
        [self.relationBtn setBackgroundImage:[UIImage imageNamed:@"guanzhued"] forState:UIControlStateNormal];
        [self.relationBtn setTitle:@"相互关注" forState:UIControlStateNormal];
        [self.relationBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        //        self.relationBtn.enabled = NO;
    }
    else
    {
        self.relationBtn.hidden = YES;
    }
    
    self.relationBtn.hidden = YES;
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
