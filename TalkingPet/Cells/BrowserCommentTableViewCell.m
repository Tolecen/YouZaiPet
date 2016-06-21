//
//  BrowserCommentTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 15/2/6.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "BrowserCommentTableViewCell.h"

@implementation BrowserCommentTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIImageView * comV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2, 27, 27)];
        [comV setImage:[UIImage imageNamed:@"browser_icon_comment"]];
        [self.contentView addSubview:comV];
        
        self.commentViewcommentL = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, ScreenWidth-47-10, 30)];
        [self.commentViewcommentL setBackgroundColor:[UIColor clearColor]];
        [self.commentViewcommentL setTextColor:[UIColor colorWithWhite:100/255.0f alpha:1]];
        [self.commentViewcommentL setText:@"查看所有100条评论"];
        [self.commentViewcommentL setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:self.commentViewcommentL];
        
        for (int i = 0; i<2; i++) {
            EGOImageButton * avatar = [[EGOImageButton alloc] initWithFrame:CGRectMake(45, 28+5*(i+1)+25*i, 25, 25)];
//            avatar.backgroundColor = [UIColor colorWithWhite:230/255.0f alpha:1];
            avatar.tag = 300+i;
            avatar.layer.cornerRadius = 13;
            avatar.placeholderImage = [UIImage imageNamed:@"browser_avatarPlaceholder"];
            avatar.layer.masksToBounds = YES;
            [avatar addTarget:self action:@selector(avatarShouldPush:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:avatar];
            //                UIImageView * mask3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
            //                [mask3 setImage:[UIImage imageNamed:@"maskHead"]];
            //                [avatar addSubview:mask3];
            
            UILabel * cL = [[UILabel alloc] initWithFrame:CGRectMake(80, 28+5*(i+1)+25*i, ScreenWidth-80-10, 25)];
            [cL setBackgroundColor:[UIColor clearColor]];
            [cL setTextColor:[UIColor colorWithWhite:100/255.0f alpha:1]];
            [cL setFont:[UIFont systemFontOfSize:13]];
            [cL setText:@"不错啊挺好的"];
            cL.tag = 400+i;
            [self.contentView addSubview:cL];
        }
        

    }
    return self;
}
-(void)avatarShouldPush:(EGOImageButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(avatarClickedId:)]) {
        [self.delegate avatarClickedId:[[self.showCommentArray objectAtIndex:sender.tag-300] objectForKey:@"petId"]];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.commentViewcommentL.text = [NSString stringWithFormat:@"查看所有%@条评论",self.commentNum];
    if ([self.showCommentArray count]<2) {
        EGOImageButton * ava = (EGOImageButton *)[self.contentView viewWithTag:301];
        ava.hidden = YES;
        UILabel * cl = (UILabel *)[self.contentView viewWithTag:401];
        cl.hidden = YES;
        EGOImageButton * ava0 = (EGOImageButton *)[self.contentView viewWithTag:300];
        ava0.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/30",[[self.showCommentArray objectAtIndex:0] objectForKey:@"petHeadPortrait"]]];
        UILabel * cl0 = (UILabel *)[self.contentView viewWithTag:400];
        cl0.text = [[[self.showCommentArray objectAtIndex:0] objectForKey:@"comment"] length]>0?[[self.showCommentArray objectAtIndex:0] objectForKey:@"comment"]:@"语音评论";
        
    }
    else{

        EGOImageButton * ava = (EGOImageButton *)[self.contentView viewWithTag:301];
        ava.hidden = NO;
        UILabel * cl = (UILabel *)[self.contentView viewWithTag:401];
        cl.hidden = NO;
        
        EGOImageButton * ava0 = (EGOImageButton *)[self.contentView viewWithTag:300];
        ava0.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/30",[[self.showCommentArray objectAtIndex:0] objectForKey:@"petHeadPortrait"]]];
        ava.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/30",[[self.showCommentArray objectAtIndex:1] objectForKey:@"petHeadPortrait"]]];
        UILabel * cl0 = (UILabel *)[self.contentView viewWithTag:400];
        cl0.text = [[[self.showCommentArray objectAtIndex:0] objectForKey:@"comment"] length]>0?[[self.showCommentArray objectAtIndex:0] objectForKey:@"comment"]:@"语音评论";
        cl.text = [[[self.showCommentArray objectAtIndex:1] objectForKey:@"comment"] length]>0?[[self.showCommentArray objectAtIndex:1] objectForKey:@"comment"]:@"语音评论";
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
