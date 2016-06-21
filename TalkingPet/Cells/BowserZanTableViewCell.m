//
//  BowserZanTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 15/2/6.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BowserZanTableViewCell.h"

@implementation BowserZanTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
//        self.zanView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
//        self.zanView.backgroundColor = [UIColor clearColor];
//        [self.contentTextBgV addSubview:self.zanView];
        UIImageView * zanV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 4, 27, 27)];
        [zanV setImage:[UIImage imageNamed:@"browser_icon_zan"]];
        [self.contentView addSubview:zanV];
        
        UIImageView * zanNumBgV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30-10, 2, 30, 30)];
        [zanNumBgV setImage:[UIImage imageNamed:@"browser_zanNumBg"]];
        [self.contentView addSubview:zanNumBgV];
        
        self.zanViewzanL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-30-10, 7, 30, 20)];
        [self.zanViewzanL setBackgroundColor:[UIColor clearColor]];
        [self.zanViewzanL setTextAlignment:NSTextAlignmentCenter];
        [self.zanViewzanL setFont:[UIFont systemFontOfSize:13]];
        [self.zanViewzanL setTextColor:[UIColor whiteColor]];
        self.zanViewzanL.adjustsFontSizeToFitWidth = YES;
        [self.zanViewzanL setText:@"110"];
        [self.contentView addSubview:self.zanViewzanL];
        
        //剩下位置能放几个头像，方程30*x+(x+1)*8 = Screenwidth-10-zanV.width-10-zanViewzanL.width
        self.zanAvatarNum = (ScreenWidth-10-27-10-30-8)/38;
        //            int d = (num-(int)num)>0.
        for (int i = 0; i<self.zanAvatarNum; i++) {
            EGOImageButton * zanAvatar = [[EGOImageButton alloc] initWithFrame:CGRectMake(10+27+8*(i+1)+30*i, 0, 30, 30)];
            zanAvatar.tag = 200+i;
//            [zanAvatar setBackgroundColor:[UIColor colorWithWhite:230/255.0f alpha:1]];
            zanAvatar.placeholderImage = [UIImage imageNamed:@"browser_avatarPlaceholder"];
            [self.contentView addSubview:zanAvatar];
            zanAvatar.layer.cornerRadius = 15;
            zanAvatar.layer.masksToBounds = YES;
            [zanAvatar addTarget:self action:@selector(avatarShouldPush:) forControlEvents:UIControlEventTouchUpInside];
            
//            UIImageView * star = [[UIImageView alloc] initWithFrame:CGRectMake(10+27+8*(i+1)+30*i+18, 18, 12, 12)];
//            star.tag = 900+i;
//            [star setImage:[UIImage imageNamed:@"daren"]];
//            [self.contentView addSubview:star];
            //                UIImageView * mask2 = [[UIImageView alloc] initWithFrame:zanAvatar.frame];
            //                [mask2 setImage:[UIImage imageNamed:@"maskHead"]];
            //                [self.zanView addSubview:mask2];
        }
        

    }
    return self;
}
-(void)avatarShouldPush:(EGOImageButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(avatarClickedId:)]) {
        [self.delegate avatarClickedId:[[self.showZanArray objectAtIndex:sender.tag-200] objectForKey:@"petId"]];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];

    self.zanViewzanL.text = self.favorNum;
    for (int i = 0; i<self.zanAvatarNum; i++) {
        EGOImageButton * zanAvatarV = (EGOImageButton *)[self.contentView viewWithTag:200+i];
//        UIImageView * daV = (UIImageView *)[self.contentView viewWithTag:900+i];
        if (self.zanAvatarNum>self.showZanArray.count) {
            if (i<self.showZanArray.count) {
                zanAvatarV.hidden = NO;
                zanAvatarV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/30",[[self.showZanArray objectAtIndex:i] objectForKey:@"petHeadPortrait"]]];
            }
            else{
                zanAvatarV.hidden = YES;
//                daV.hidden = YES;
            }
        }
        else
        {
            zanAvatarV.hidden = NO;
            zanAvatarV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/30",[[self.showZanArray objectAtIndex:i] objectForKey:@"petHeadPortrait"]]];
        }
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
