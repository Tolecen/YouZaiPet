//
//  HuDongDetailTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 15/3/31.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "HuDongDetailTableViewCell.h"
#import "RootViewController.h"
@implementation HuDongDetailTableViewCell
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
        
        self.publisherNameL = [[UILabel alloc] initWithFrame:CGRectMake(75, self.publisherAvatarV.frame.origin.y+3, 200, 20)];
        [self.publisherNameL setBackgroundColor:[UIColor clearColor]];
        [self.publisherNameL setFont:[UIFont systemFontOfSize:16]];
        self.publisherNameL.textColor = [UIColor colorWithWhite:100/255.0f alpha:1];
        [self.publisherNameL setText:@"是我发的"];
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
        
        
        self.lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        self.lineV.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
        [self.contentView addSubview:self.lineV];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.contentDict) {
        self.publisherAvatarV.imageURL = [NSURL URLWithString:[self.contentDict objectForKey:@"petAvatar"]];
        self.publisherNameL.text = [self.contentDict objectForKey:@"petNickName"];
        self.favorLabel.text = [self.contentDict objectForKey:@"likeCount"];
        if ([[self.contentDict objectForKey:@"isLiked"] isEqualToString:@"false"]) {
            [_favorImgV setImage:[UIImage imageNamed:@"browser_zan"]];
        }
        else
        {
            [_favorImgV setImage:[UIImage imageNamed:@"browser_zanned"]];
            
        }
        
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
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        NSDate *timesp = [NSDate dateWithTimeIntervalSince1970:[[self.contentDict objectForKey:@"createTime"]  doubleValue]/1000.0f];
        NSString *timespStr = [formatter stringFromDate:timesp];
        [self.timeL setText:timespStr];
        
        
        NSString * content = [self.contentDict objectForKey:@"content"];
        CGSize cSize;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0){
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:content];
            NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle2.lineBreakMode = NSLineBreakByWordWrapping;
            paragraphStyle2.lineHeightMultiple = 1.2;
    //        paragraphStyle2.firstLineHeadIndent = 20;
            NSDictionary *attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle2.copy};
            cSize = [content boundingRectWithSize:CGSizeMake(ScreenWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes2 context:nil].size;
                [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle2 range:NSMakeRange(0, content.length)];
                [self.contentL setAttributedText:attrString];
        }
        else{
            cSize = [content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(ScreenWidth-20, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            [self.contentL setText:content];
        }
        
        
        [self.contentL setFrame:CGRectMake(10, 55, cSize.width, cSize.height)];
        
        if ([[self.contentDict objectForKey:@"pictures"] count]<=0) {
            self.lineV.hidden = NO;
            [self.lineV setFrame:CGRectMake(0, 60+cSize.height+9, ScreenWidth, 1)];
        }
        else
        {
            self.lineV.hidden = YES;
        }
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
        
//        if ([self.delegate respondsToSelector:@selector(resetDictForSection:row:dict:)]) {
//            NSMutableDictionary * fg = [NSMutableDictionary dictionaryWithDictionary:self.contentDict];
//            [fg setObject:@"false" forKey:@"isLiked"];
//            [fg setObject:self.favorLabel.text forKey:@"likeCount"];
//            [self.delegate resetDictForSection:self.cellSection row:self.cellIndex dict:fg];
//        }
        
        
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"topic" forKey:@"command"];
        [mDict setObject:@"cancelLike" forKey:@"options"];
        [mDict setObject:[self.contentDict objectForKey:@"id"] forKey:@"talkId"];
        //        [mDict setObject:@"F" forKey:@"type"];
        [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"userId"];
        
        
        NSLog(@"cancelFavor:%@",mDict);
        [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            [self.contentDict setObject:@"false" forKey:@"isLiked"];
            [self.contentDict setObject:self.favorLabel.text forKey:@"likeCount"];
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
        
//        if ([self.delegate respondsToSelector:@selector(resetDictForSection:row:dict:)]) {
//            NSMutableDictionary * fg = [NSMutableDictionary dictionaryWithDictionary:self.contentDict];
//            [fg setObject:@"true" forKey:@"isLiked"];
//            [fg setObject:self.favorLabel.text forKey:@"likeCount"];
//            [self.delegate resetDictForSection:self.cellSection row:self.cellIndex dict:fg];
//        }
//        
        
        
        NSMutableDictionary* mDict = [NetServer commonDict];
        [mDict setObject:@"topic" forKey:@"command"];
        [mDict setObject:@"createLike" forKey:@"options"];
        [mDict setObject:[self.contentDict objectForKey:@"id"] forKey:@"talkId"];
        [mDict setObject:[UserServe sharedUserServe].userID?[UserServe sharedUserServe].userID:@"" forKey:@"petId"];
        
        
        NSLog(@"doFavor:%@",mDict);
        [NetServer requestWithParameters:mDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            [self.contentDict setObject:@"true" forKey:@"isLiked"];
            [self.contentDict setObject:self.favorLabel.text forKey:@"likeCount"];
            NSLog(@"favor success:%@",responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"favor error:%@",error);
            
        }];
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
