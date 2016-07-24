//
//  HuDongListTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 15/3/27.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "HuDongListTableViewCell.h"
#import "RootViewController.h"
@implementation HuDongListTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.publisherAvatarV = [[EGOImageButton alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [self.publisherAvatarV setBackgroundColor:[UIColor grayColor]];
        [self.contentView addSubview:self.publisherAvatarV];
        [self.publisherAvatarV setBackgroundImage:[UIImage imageNamed:@"placeholderHead"] forState:UIControlStateNormal];
        [_publisherAvatarV addTarget:self action:@selector(publisherAction) forControlEvents:UIControlEventTouchUpInside];
        _publisherAvatarV.layer.masksToBounds = YES;
        _publisherAvatarV.layer.cornerRadius = 20;
        
        self.genderImageV = [[UIImageView alloc] initWithFrame:CGRectMake(75, 0, 16, 14)];
        [self.contentView addSubview:self.genderImageV];
        
        
        self.publisherNameL = [[UILabel alloc] initWithFrame:CGRectMake(75, 370+35, 200, 20)];
        [self.publisherNameL setBackgroundColor:[UIColor clearColor]];
        [self.publisherNameL setFont:[UIFont systemFontOfSize:16]];
        self.publisherNameL.textColor = [UIColor colorWithWhite:100/255.0f alpha:1];
        [self.publisherNameL setText:@"我是小黄瓜"];
        [self.contentView addSubview:self.publisherNameL];
        
        self.publisherNameL.userInteractionEnabled = YES;
        
        
        UITapGestureRecognizer * tapw = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(publisherAction)];
        [self.publisherNameL addGestureRecognizer:tapw];
        
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(60, self.publisherAvatarV.frame.origin.y+5+2+13, 120, 20)];
        [self.timeL setBackgroundColor:[UIColor clearColor]];
        [self.timeL setTextColor:[UIColor lightGrayColor]];
        [self.timeL setText:@"03-30 10:55"];
        [self.timeL setFont:[UIFont systemFontOfSize:12]];
        [self.contentView addSubview:self.timeL];
        
        
        
        self.favorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.favorBtn setFrame:CGRectMake(ScreenWidth-10-60, 15, 60, 30)];
        [self.favorBtn setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.favorBtn];
        self.favorBtn.showsTouchWhenHighlighted = YES;
        [_favorBtn addTarget:self action:@selector(favorAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.favorImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        //            [_favorImgV setImage:[UIImage imageNamed:@"step-ico"]];
        [self.favorBtn addSubview:_favorImgV];
        [self.favorImgV setImage:[UIImage imageNamed:@"browser_zan"]];
        
        self.favorLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 30, 20)];
        [self.favorLabel setBackgroundColor:[UIColor clearColor]];
        [self.favorLabel setText:@"31"];
        [self.favorLabel setFont:[UIFont systemFontOfSize:13]];
        //            [self.favorLabel setTextColor:[UIColor whiteColor]];
        [self.favorLabel setTextAlignment:NSTextAlignmentLeft];
        [self.favorBtn addSubview:self.favorLabel];
        [self.favorLabel setTextColor:[UIColor colorWithWhite:100/255.0f alpha:1]];
        [self.favorLabel setAdjustsFontSizeToFitWidth:YES];

        
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, ScreenWidth-20, 75)];
        [self.contentL setBackgroundColor:[UIColor clearColor]];
        [self.contentL setTextColor:[UIColor colorWithWhite:120/255.0f alpha:1]];
        self.contentL.lineBreakMode = NSLineBreakByWordWrapping;
        self.contentL.numberOfLines = 0;
        self.contentL.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.contentL];
        
        self.firstImgV = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
        [self.firstImgV setBackgroundColor:[UIColor colorWithWhite:240/255.0f alpha:1]];
        [self.contentView addSubview:self.firstImgV];
        
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(80, 80, 20, 20)];
        self.numL.backgroundColor = [UIColor blackColor];
        self.numL.alpha = 0.8;
        self.numL.font = [UIFont systemFontOfSize:12];
        self.numL.textColor = [UIColor whiteColor];
        self.numL.textAlignment = NSTextAlignmentCenter;
        self.numL.adjustsFontSizeToFitWidth = YES;
        [self.firstImgV addSubview:self.numL];
        
        self.commentBg  = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
        [self.contentView addSubview:self.commentBg];
        self.commentBg.userInteractionEnabled = YES;
        
        self.commentUser1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        self.commentUser1.backgroundColor = [UIColor clearColor];
        self.commentUser1.textColor = [UIColor colorWithRed:133/255.0f green:209/255.0f blue:252/255.0f alpha:1];
        self.commentUser1.font = [UIFont systemFontOfSize:13];
        [self.commentBg addSubview:self.commentUser1];
        self.commentUser1.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapw1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comment1clicked)];
        [self.commentUser1 addGestureRecognizer:tapw1];
        
        
        self.commentL1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.commentBg.frame.size.width, 20)];
        self.commentL1.backgroundColor = [UIColor clearColor];
        [self.commentL1 setTextColor:[UIColor colorWithWhite:120/255.0f alpha:1]];
        self.commentL1.font = [UIFont systemFontOfSize:13];
        [self.commentBg addSubview:self.commentL1];
        
        self.commentUser2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        self.commentUser2.backgroundColor = [UIColor clearColor];
        self.commentUser2.textColor = [UIColor colorWithRed:133/255.0f green:209/255.0f blue:252/255.0f alpha:1];
        self.commentUser2.font = [UIFont systemFontOfSize:13];
        [self.commentBg addSubview:self.commentUser2];
        self.commentUser2.userInteractionEnabled = YES;
        
        UITapGestureRecognizer * tapw2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comment2clicked)];
        [self.commentUser2 addGestureRecognizer:tapw2];
        
        self.commentL2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.commentBg.frame.size.width, 20)];
        self.commentL2.backgroundColor = [UIColor clearColor];
        [self.commentL2 setTextColor:[UIColor colorWithWhite:120/255.0f alpha:1]];
        self.commentL2.font = [UIFont systemFontOfSize:13];
        [self.commentBg addSubview:self.commentL2];
        
        
        self.commentIconV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [self.commentIconV setImage:[UIImage imageNamed:@"browser_comment"]];
        [self.commentBg addSubview:self.commentIconV];
        
        self.allCL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        [self.allCL setBackgroundColor:[UIColor clearColor]];
        self.allCL.font = [UIFont systemFontOfSize:12];
        [self.allCL setTextColor:[UIColor colorWithWhite:120/255.0f alpha:1]];
        [self.commentBg addSubview:self.allCL];
        
        self.lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 1)];
        [self.lineV setBackgroundColor:[UIColor colorWithWhite:240/255.0f alpha:1]];
        [self.contentView addSubview:self.lineV];
        
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        
    }
    return self;
}
-(void)comment1clicked
{
    if ([self.delegate respondsToSelector:@selector(touchedUserId:)]) {
        [self.delegate touchedUserId:[self.commentArray[0] objectForKey:@"petId"]];
    }
}
-(void)comment2clicked
{
    if ([self.delegate respondsToSelector:@selector(touchedUserId:)]) {
        [self.delegate touchedUserId:[self.commentArray[1] objectForKey:@"petId"]];
    }
}
-(void)publisherAction
{
    if ([self.delegate respondsToSelector:@selector(touchedUserId:)]) {
        [self.delegate touchedUserId:[self.contentDict objectForKey:@"petId"]];
    }
}
- (void)favorAction
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
    //    if (_delegate&& [_delegate respondsToSelector:@selector(zanWithTalkingBrowse:)]) {
    //        [_delegate zanWithTalkingBrowse:self.talking];
    //    }
    if ([[self.contentDict objectForKey:@"isLiked"] isEqualToString:@"true"]) {
      
        [_favorImgV setImage:[UIImage imageNamed:@"browser_zan"]];
        
        self.favorLabel.text =[NSString stringWithFormat:@"%d",[self.favorLabel.text intValue]>0?([self.favorLabel.text intValue]-1):0];
        
        if ([self.delegate respondsToSelector:@selector(resetDictForSection:row:dict:)]) {
            NSMutableDictionary * fg = [NSMutableDictionary dictionaryWithDictionary:self.contentDict];
            [fg setObject:@"false" forKey:@"isLiked"];
            [fg setObject:self.favorLabel.text forKey:@"likeCount"];
            [self.delegate resetDictForSection:self.cellSection row:self.cellIndex dict:fg];
        }
        
        
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"topic" forKey:@"command"];
        [mDict setObject:@"cancelLike" forKey:@"options"];
        [mDict setObject:[self.contentDict objectForKey:@"id"] forKey:@"talkId"];
//        [mDict setObject:@"F" forKey:@"type"];
        [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"userId"];
        
        
        NSLog(@"cancelFavor:%@",mDict);
        [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"cancel favor success:%@",responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"cancel favor error:%@",error);
            
        }];
    }
    else{
//        self.talking.ifZan = YES;
//        self.favorBtn.enabled = NO;
        
        //        [self performSelector:@selector(zanMakeBig) withObject:nil afterDelay:0.2];
//        [self zanMakeBig];
        [_favorImgV setImage:[UIImage imageNamed:@"browser_zanned"]];
        self.favorLabel.text =[NSString stringWithFormat:@"%d",[self.favorLabel.text intValue]+1];
        
        if ([self.delegate respondsToSelector:@selector(resetDictForSection:row:dict:)]) {
            NSMutableDictionary * fg = [NSMutableDictionary dictionaryWithDictionary:self.contentDict];
            [fg setObject:@"true" forKey:@"isLiked"];
            [fg setObject:self.favorLabel.text forKey:@"likeCount"];
            [self.delegate resetDictForSection:self.cellSection row:self.cellIndex dict:fg];
        }
        
        
        
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"topic" forKey:@"command"];
        [mDict setObject:@"createLike" forKey:@"options"];
        [mDict setObject:[self.contentDict objectForKey:@"id"] forKey:@"talkId"];
        [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"petId"];
        
        
        NSLog(@"doFavor:%@",mDict);
        [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"favor success:%@",responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"favor error:%@",error);
            
        }];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
//    return;
    self.publisherNameL.text = [self.contentDict objectForKey:@"petNickName"];
    self.publisherAvatarV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/60",[self.contentDict objectForKey:@"petAvatar"]]];
    
    NSDate *timesp = [NSDate dateWithTimeIntervalSince1970:[[self.contentDict objectForKey:@"createTime"]  doubleValue]/1000.0f];
    NSString *timespStr = [formatter stringFromDate:timesp];
    [self.timeL setText:timespStr];
    
//    NSString * content = [self.contentDict objectForKey:@"content"];
//     NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:content];
//    NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle2.lineBreakMode = NSLineBreakByWordWrapping;
//    paragraphStyle2.lineHeightMultiple = 1.2;
////    paragraphStyle2.firstLineHeadIndent = 20;
//    NSDictionary *attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle2.copy};
//    CGSize cSize = [content boundingRectWithSize:CGSizeMake(ScreenWidth-20, 120) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes2 context:nil].size;
//    
//    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, content.length)];
    CGSize cSize = CGSizeMake([[self.contentDict objectForKey:@"rowWidth"] floatValue], [[self.contentDict objectForKey:@"rowHeight"] floatValue]);
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0){
        [self.contentL setAttributedText:[self.contentDict objectForKey:@"attriContent"]];
    }
    else
        [self.contentL setText:[self.contentDict objectForKey:@"content"]];
    [self.contentL setFrame:CGRectMake(10, 55, cSize.width, cSize.height)];
    
    UIImage * fg = [UIImage imageNamed:@"comment"];
    UIImage *image=[fg resizableImageWithCapInsets:UIEdgeInsetsMake(fg.size.height * 0.16, fg.size.width * 0.5, fg.size.height * 0.1, fg.size.width * 0.1) resizingMode:UIImageResizingModeStretch];
    [self.commentBg setImage:image];
    
    [self.commentBg setFrame:CGRectMake(10, 55+cSize.height+10, ScreenWidth-20, 90)];
 
    
    if (self.imageArray.count>0) {
        self.firstImgV.hidden = NO;
        [self.firstImgV setFrame:CGRectMake(10, 55+cSize.height+10, 100, 100)];
        [self.firstImgV setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/1/w/100",[self.imageArray[0] objectForKey:@"pic"]]]];
        if (self.imageArray.count>1) {
            self.numL.hidden = NO;
        }
        else
            self.numL.hidden = YES;
        [self.numL setText:[NSString stringWithFormat:@"%d",(int)self.imageArray.count]];
    }
    else{
        self.firstImgV.hidden = YES;
        self.firstImgV.imageURL = nil;
        
    }
    if (self.cellSection==1){
        self.commentBg.hidden = YES;
        self.commentL1.hidden = YES;
        self.commentUser1.hidden = YES;
        self.commentUser2.hidden = YES;
        self.commentL2.hidden = YES;
        [self.lineV setFrame:CGRectMake(0, 55+cSize.height+10+(self.imageArray.count==0?0:110)+10-1, ScreenWidth, 1)];
    }
    else{
        if (self.commentArray.count==1){
            self.commentBg.hidden = NO;
            self.commentL1.hidden = NO;
            self.commentUser1.hidden = NO;
            self.commentUser2.hidden = YES;
            self.commentL2.hidden = YES;
            NSString * user1 = [[[self.commentArray objectAtIndex:0] objectForKey:@"petNickName"] stringByAppendingString:@":"];
            CGSize fSize = [user1 sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(150, 20)];
            self.commentUser1.frame = CGRectMake(10, 20, fSize.width, 20);
            self.commentUser1.text = user1;
            [self.commentL1 setFrame:CGRectMake(10+fSize.width+5, 20, ScreenWidth-20-(10+fSize.width+5+10), 20)];
            [self.commentL1 setText:[[self.commentArray objectAtIndex:0] objectForKey:@"comment"]];
            [self.commentBg setFrame:CGRectMake(10, 55+cSize.height+10+(self.imageArray.count==0?0:110), ScreenWidth-20, 70)];
            [self.lineV setFrame:CGRectMake(0, 55+cSize.height+10+(self.imageArray.count==0?0:110)+70+10-1, ScreenWidth, 1)];
        }
        else if (self.commentArray.count==2){
            self.commentBg.hidden = NO;
            self.commentL1.hidden = NO;
            self.commentUser1.hidden = NO;
            self.commentUser2.hidden = NO;
            self.commentL2.hidden = NO;
            NSString * user1 = [[[self.commentArray objectAtIndex:0] objectForKey:@"petNickName"] stringByAppendingString:@":"];
            CGSize fSize = [user1 sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(150, 20)];
            self.commentUser1.frame = CGRectMake(10, 20, fSize.width, 20);
            self.commentUser1.text = user1;
            [self.commentL1 setFrame:CGRectMake(10+fSize.width+5, 20, ScreenWidth-20-(10+fSize.width+5+10), 20)];
            [self.commentL1 setText:[[self.commentArray objectAtIndex:0] objectForKey:@"comment"]];
            
            
            NSString * user2 = [[[self.commentArray objectAtIndex:1] objectForKey:@"petNickName"] stringByAppendingString:@":"];
            CGSize fSize2 = [user1 sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(150, 20)];
            self.commentUser2.frame = CGRectMake(10, 45, fSize2.width, 20);
            self.commentUser2.text = user2;
            [self.commentL2 setFrame:CGRectMake(10+fSize2.width+5, 45, ScreenWidth-20-(10+fSize.width+5+10), 20)];
            [self.commentL2 setText:[[self.commentArray objectAtIndex:1] objectForKey:@"comment"]];
            [self.commentBg setFrame:CGRectMake(10, 55+cSize.height+10+(self.imageArray.count==0?0:110), ScreenWidth-20, 95)];
            [self.lineV setFrame:CGRectMake(0, 55+cSize.height+10+(self.imageArray.count==0?0:110)+95+10-1, ScreenWidth, 1)];
        }
        else {
            self.commentBg.hidden = YES;
            self.commentL1.hidden = YES;
            self.commentUser1.hidden = YES;
            self.commentUser2.hidden = YES;
            self.commentL2.hidden = YES;
            [self.lineV setFrame:CGRectMake(0, 55+cSize.height+10+(self.imageArray.count==0?0:110)+10-1, ScreenWidth, 1)];
        }
    }
    
    NSString * allCLStr = [NSString stringWithFormat:@"查看所有%@条评论",[self.contentDict objectForKey:@"commentCount"]];
    CGSize gSize = [allCLStr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(150, 20)];
    [self.allCL setFrame:CGRectMake(ScreenWidth-20-10-gSize.width, self.commentBg.frame.size.height-25, gSize.width, 20)];
    self.allCL.text = allCLStr;
    [self.commentIconV setFrame:CGRectMake(ScreenWidth-20-10-gSize.width-25, self.commentBg.frame.size.height-25, 20, 20)];
    

    
    if ([[self.contentDict objectForKey:@"isLiked"] isEqualToString:@"false"]) {
        [_favorImgV setImage:[UIImage imageNamed:@"browser_zan"]];
    }
    else
    {
        [_favorImgV setImage:[UIImage imageNamed:@"browser_zanned"]];
        
    }
    
    [self.favorLabel setText:[self.contentDict objectForKey:@"likeCount"]];
    
    if ([[self.contentDict objectForKey:@"petGender"] isEqualToString:@"1"]) {
        [self.genderImageV setImage:[UIImage imageNamed:@"male"]];
        [self.genderImageV setFrame:CGRectMake(53, self.publisherAvatarV.frame.origin.y+5, 16, 14)];
        self.genderImageV.hidden = NO;
        [self.publisherNameL setFrame:CGRectMake(71,self.publisherAvatarV.frame.origin.y+3, 150, 20)];
    }
    else if ([[self.contentDict objectForKey:@"petGender"] isEqualToString:@"0"]){
        [self.genderImageV setImage:[UIImage imageNamed:@"female"]];
        [self.genderImageV setFrame:CGRectMake(53, self.publisherAvatarV.frame.origin.y+5, 16, 14)];
        self.genderImageV.hidden = NO;
        [self.publisherNameL setFrame:CGRectMake(71,self.publisherAvatarV.frame.origin.y+3, 150, 20)];
    }
    else
    {
        self.genderImageV.hidden = YES;
        [self.publisherNameL setFrame:CGRectMake(55,self.publisherAvatarV.frame.origin.y+3, 160, 20)];
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
