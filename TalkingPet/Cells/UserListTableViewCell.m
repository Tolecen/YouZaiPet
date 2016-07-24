//
//  UserListTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 14-7-22.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "UserListTableViewCell.h"
#import "RootViewController.h"
#import "SVProgressHUD.h"
@implementation UserListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier CellType:(int)type ListType:(int)listType
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
//        if (type==2) {
//            UIView * bgv = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 310, 70)];
//            [bgv setBackgroundColor:[UIColor whiteColor]];
//            [bgv setAlpha:0.7];
//            [self.contentView addSubview:bgv];
//
//        }
        self.listType = listType;
        self.commentAvatarV = [[EGOImageButton alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        [self.commentAvatarV setBackgroundColor:[UIColor grayColor]];
        self.commentAvatarV.placeholderImage = [UIImage imageNamed:@"placeholderHead"];
        [self.contentView addSubview:self.commentAvatarV];
        self.commentAvatarV.layer.cornerRadius = 25;
        self.commentAvatarV.layer.masksToBounds = YES;
        [self.commentAvatarV addTarget:self action:@selector(headBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        self.darenV = [[UIImageView alloc] initWithFrame:CGRectMake(10+50-17, 10+50-17, 17, 17)];
        [self.darenV setImage:[UIImage imageNamed:@"daren"]];
        [self.contentView addSubview:self.darenV];
        
        //        UIImageView * avatarbg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        //        [avatarbg setImage:[UIImage imageNamed:@"avatarbg1"]];
        //        [self.contentView addSubview:avatarbg];
        
        self.commentNameL = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, ScreenWidth-70-10-72-5, 20)];
        [self.commentNameL setBackgroundColor:[UIColor clearColor]];
        [self.commentNameL setFont:[UIFont systemFontOfSize:17]];
        [self.contentView addSubview:self.commentNameL];
        
        self.talkNoL = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, 100, 20)];
        [self.talkNoL setBackgroundColor:[UIColor clearColor]];
        self.talkNoL.textColor = [UIColor grayColor];
        [self.talkNoL setFont:[UIFont systemFontOfSize:14]];
        [self.talkNoL setText:@"宠物说:20"];
        [self.contentView addSubview:self.talkNoL];
        
        self.fansNoL = [[UILabel alloc] initWithFrame:CGRectMake(180, 40, 100, 20)];
        [self.fansNoL setBackgroundColor:[UIColor clearColor]];
        self.fansNoL.textColor = [UIColor grayColor];
        [self.fansNoL setFont:[UIFont systemFontOfSize:14]];
        [self.fansNoL setText:@"粉丝:20"];
        [self.contentView addSubview:self.fansNoL];
        
        self.relationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.relationBtn setFrame:CGRectMake(ScreenWidth-10-72, 23, 72, 24.5)];
        [self.relationBtn setBackgroundImage:[UIImage imageNamed:@"userlistguanzhu0"] forState:UIControlStateNormal];
//        [self.relationBtn setTitle:@"+关注" forState:UIControlStateNormal];
        [self.relationBtn setTitleColor:[UIColor colorWithRed:0.235 green:0.776 blue:1 alpha:1] forState:UIControlStateNormal];
        [self.relationBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        if (listType==2) {
            [self.relationBtn addTarget:self action:@selector(removeFromBlackList) forControlEvents:UIControlEventTouchUpInside];
        }
        else
            [self.relationBtn addTarget:self action:@selector(attentionBtnDo) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.relationBtn];
        
        UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(10, 69, ScreenWidth-10, 1)];
        [lineV setBackgroundColor:[UIColor colorWithWhite:230/255.0f alpha:1]];
        [self.contentView addSubview:lineV];
        
    }
    
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.commentNameL.text = [self.petDict objectForKey:@"nickname"];
    self.commentAvatarV.imageURL = [NSURL URLWithString:[[self.petDict objectForKey:@"head"] stringByAppendingString:@"?imageView2/2/w/80"]];
    if ([[self.petDict objectForKey:@"counter"] isKindOfClass:[NSDictionary class]]) {
        self.talkNoL.text = [NSString stringWithFormat:@"发布:%@",[[self.petDict objectForKey:@"counter"] objectForKey:@"issue"]];
        self.fansNoL.text = [NSString stringWithFormat:@"粉丝:%@",[[self.petDict objectForKey:@"counter"] objectForKey:@"fans"]];
    }
    
    self.relationShip = [self.petDict objectForKey:@"rs"];
//    self.darenV.hidden = [[self.petDict objectForKey:@"star"] isEqualToString:@"1"]?NO:YES;
    if (self.listType==2) {
        self.relationBtn.hidden = NO;
        [self.relationBtn setBackgroundImage:[UIImage imageNamed:@"removeBlackList"] forState:UIControlStateNormal];
        return;
    }
    
    if ([self.relationShip isEqualToString:@"0"]) {
        self.relationBtn.hidden = NO;
        
        [self.relationBtn setBackgroundImage:[UIImage imageNamed:@"userlistguanzhu0"] forState:UIControlStateNormal];
        [self.relationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
//        [self.relationBtn setTitle:@"+关注" forState:UIControlStateNormal];
        
        self.relationBtn.enabled = YES;
    }
    else if ([self.relationShip isEqualToString:@"1"]){
        self.relationBtn.hidden = NO;
        [self.relationBtn setBackgroundImage:[UIImage imageNamed:@"userlistguanzhu1"] forState:UIControlStateNormal];
//        [self.relationBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [self.relationBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        //        self.relationBtn.enabled = NO;
    }
    else if ([self.relationShip isEqualToString:@"2"]){
        self.relationBtn.hidden = NO;
        [self.relationBtn setBackgroundImage:[UIImage imageNamed:@"userlistguanzhu2"] forState:UIControlStateNormal];
//        [self.relationBtn setTitle:@"相互关注" forState:UIControlStateNormal];
        [self.relationBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        //        self.relationBtn.enabled = NO;
    }
    else
    {
        self.relationBtn.hidden = YES;
    }
    
    if ([[self.petDict objectForKey:@"id"] isEqualToString:@"44239"]) {
        _relationBtn.enabled = NO;
    }
    else
    {
        _relationBtn.enabled = YES;
    }
    
//    self.relationBtn.hidden = YES;
    
}
-(void)headBtnClicked
{
    if (_delegate&& [_delegate respondsToSelector:@selector(toUserPage:)]) {
        [_delegate toUserPage:self.petDict];
    }
    
}
-(void)attentionBtnDo
{
    if ([self.relationShip isEqualToString:@"0"]) {
        [self doAttention];
    }
    else
        [self cancelAttention];
}
-(void)doAttention
{
    NSString * currentPetId = [UserServe sharedUserServe].userID;
    if (!currentPetId) {
        if (![RootViewController sharedRootViewController].presentedViewController) {
            [[RootViewController sharedRootViewController] showLoginViewController];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录才能执行更多操作哦" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        }
        return;
    }
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"petfans" forKey:@"command"];
    [mDict setObject:@"focus" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"fansId"];
    [mDict setObject:[self.petDict objectForKey:@"id"] forKey:@"userId"];
    
    //    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"petId"];
    NSLog(@"focus user:%@",mDict);
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"error"] isEqualToString:@"200"]) {
            
            self.relationShip = @"1";
            
            if ([responseObject objectForKey:@"message"]) {
                [SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
            }
            
            if ([[[responseObject objectForKey:@"value"] objectForKey:@"bothway"] isEqualToString:@"false"]) {
//                [self.relationBtn setTitle:@"已关注" forState:UIControlStateNormal];
                [self.relationBtn setBackgroundImage:[UIImage imageNamed:@"userlistguanzhu1"] forState:UIControlStateNormal];
                self.relationShip = @"1";
            }
            else{
//                [self.relationBtn setTitle:@"互相关注" forState:UIControlStateNormal];
                [self.relationBtn setBackgroundImage:[UIImage imageNamed:@"userlistguanzhu2"] forState:UIControlStateNormal];
                self.relationShip = @"2";
            }
            
            NSMutableDictionary * fdict = [NSMutableDictionary dictionaryWithDictionary:self.petDict];
            [fdict setObject:self.relationShip forKey:@"rs"];
//            [self.relationBtn setBackgroundImage:[UIImage imageNamed:@"guanzhued"] forState:UIControlStateNormal];
            //            [self.relationBtn setTitle:@"已关注" forState:UIControlStateNormal];
            
            
//            [self.relationBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            //            self.relationBtn.enabled = NO;
            if (_delegate&& [_delegate respondsToSelector:@selector(attentionDelegate:Index:)]) {
                [_delegate attentionDelegate:fdict Index:self.cellIndex];
            }
            //            [self.hotTableView reloadData];
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
        if (![RootViewController sharedRootViewController].presentedViewController) {
            [[RootViewController sharedRootViewController] showLoginViewController];
        }
        else
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先登录才能执行更多操作哦" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        }
        return;
    }
    NSMutableDictionary* mDict = [NetServer commonDict];
    [mDict setObject:@"petfans" forKey:@"command"];
    [mDict setObject:@"cancelFocus" forKey:@"options"];
    [mDict setObject:[UserServe sharedUserServe].userID forKey:@"fansPetId"];
    [mDict setObject:[self.petDict objectForKey:@"id"] forKey:@"petId"];
    [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.relationShip = @"0";
        [self.relationBtn setBackgroundImage:[UIImage imageNamed:@"userlistguanzhu0"] forState:UIControlStateNormal];
        [self.relationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
//        [self.relationBtn setTitle:@"+关注" forState:UIControlStateNormal];
        NSMutableDictionary * fdict = [NSMutableDictionary dictionaryWithDictionary:self.petDict];
        [fdict setObject:@"0" forKey:@"rs"];
        if (_delegate&& [_delegate respondsToSelector:@selector(attentionDelegate:Index:)]) {
            [_delegate attentionDelegate:fdict Index:self.cellIndex];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}
-(void)removeFromBlackList
{
    if ([self.delegate respondsToSelector:@selector(removeThisPetFromBlackList:cellIndex:)]) {
        [self.delegate removeThisPetFromBlackList:self.petDict cellIndex:self.cellIndex];
    }
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
