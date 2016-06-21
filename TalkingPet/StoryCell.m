//
//  StoryCell.m
//  TalkingPet
//
//  Created by wangxr on 15/7/10.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "StoryCell.h"
@interface StoryCell ()
{
    UIImageView * imageV;
    UIImageView * subIV;
    UIImageView * textBG;
    UIImageView * audio;
    UILabel * contentL;
    UILabel * subL;
}
@end
@implementation StoryCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        imageV = [[UIImageView alloc]initWithFrame:self.bounds];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.clipsToBounds = YES;
        [self.contentView addSubview:imageV];
        subIV = [[UIImageView alloc]init];
        subIV.hidden = YES;
        [self.contentView addSubview:subIV];
        textBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height-20, frame.size.width, 20)];
        textBG.image = [UIImage imageNamed:@"story_img_text"];
        textBG.hidden = YES;
        [self.contentView addSubview:textBG];
        audio = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        audio.image = [UIImage imageNamed:@"story_img_audio"];
        audio.hidden = YES;
        [self.contentView addSubview:audio];
        contentL = [[UILabel alloc] initWithFrame:textBG.frame];
        contentL.numberOfLines = 0;
        contentL.hidden = YES;
        [self.contentView addSubview:contentL];
        subL = [[UILabel alloc] init];
        subL.font = [UIFont systemFontOfSize:12];
        subL.hidden = YES;
        [self.contentView addSubview:subL];
    }
    return self;
}
-(void)layoutWithTitle:(NSString*)title time:(NSString*)time cover:(UIImage*)cover
{
    if (cover) {
        subIV.hidden = NO;
        imageV.image = [UIImage imageNamed:@"story_preview_cover"];
        subIV.image = cover;
    }else
    {
        subIV.hidden = YES;
        imageV.image = [UIImage imageNamed:@"story_preview_defaultCover"];
    }
    float width = self.bounds.size.width;
    subIV.frame = CGRectMake(width*40/640, width*224/640, width*560/640, width*320/640);
    audio.hidden = YES;
    textBG.hidden = YES;
    contentL.hidden = NO;
    contentL.text = title;
    contentL.textAlignment = NSTextAlignmentLeft;
    contentL.frame = textBG.frame;
    contentL.font = [UIFont systemFontOfSize:16];
    subL.hidden = NO;
    subL.text = time;
    subL.font = [UIFont systemFontOfSize:12];
    imageV.frame=self.bounds;
    textBG.frame=CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20);
    contentL.frame = CGRectMake(width*40/640, width*116/640, width*560/640, 20);;
    subL.frame = CGRectMake(width*40/640, width*164/640, width*560/640, 20);
    contentL.textColor = [UIColor orangeColor];
    subL.textColor = [UIColor orangeColor];
}
-(void)layoutWithImage:(UIImage *)image text:(NSString*)text  lineFeed:(BOOL)feed haveAudio:(BOOL)avdio
{
    imageV.image = image;
    subIV.hidden = YES;
    audio.hidden = !avdio;
    textBG.hidden = !text.length;
    contentL.hidden = !text.length;
    contentL.text = text;
    contentL.textAlignment = NSTextAlignmentLeft;
    subL.hidden = YES;
    imageV.frame=self.bounds;
    if (feed) {
        contentL.font = [UIFont systemFontOfSize:16];
        CGSize size = [text sizeWithFont:contentL.font constrainedToSize:CGRectInset(self.bounds, 5, 5).size lineBreakMode:NSLineBreakByWordWrapping];
        textBG.frame=CGRectMake(0, self.bounds.size.height-size.height-5, self.bounds.size.width, size.height+5);
        contentL.frame=CGRectInset(textBG.frame, 5, 0);
    }else{
        textBG.frame=CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20);
        contentL.frame=CGRectInset(textBG.frame, 5, 0);
        contentL.font = [UIFont systemFontOfSize:12];
    }
    audio.frame = CGRectMake(0, 0, 50, 50);
    contentL.textColor = [UIColor whiteColor];
    subL.textColor = [UIColor whiteColor];
}
-(void)layoutWithText:(NSString*)text
{
    imageV.image = [UIImage imageNamed:@"story_text_bg"];
    subIV.hidden = YES;
    audio.hidden = YES;
    textBG.hidden = YES;
    contentL.hidden = NO;
    contentL.text = text;
    contentL.frame = self.bounds;
    subL.hidden = YES;
    imageV.frame=self.bounds;
    textBG.frame=CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20);
    contentL.frame= CGRectInset(self.bounds, self.bounds.size.width*15/100, self.bounds.size.height*15/100);
    contentL.textAlignment = NSTextAlignmentLeft;
    contentL.font = [UIFont systemFontOfSize:12];
    contentL.textColor = [UIColor colorWithWhite:128/255.0 alpha:1];
    subL.textColor = [UIColor colorWithWhite:128/255.0 alpha:1];
}
-(void)layoutWithAddress:(NSString*)address lineFeed:(BOOL)feed time:(NSString*)time
{
    imageV.image = [UIImage imageNamed:@"story_a&t_bg"];
    subIV.hidden = YES;
    audio.hidden = YES;
    textBG.hidden = YES;
    contentL.hidden = NO;
    contentL.text = address;
    contentL.textAlignment = NSTextAlignmentRight;
    subL.hidden = NO;
    subL.text = time;
    imageV.frame=self.bounds;
    textBG.frame=CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20);
    if (feed) {
        contentL.font = [UIFont systemFontOfSize:16];
        subL.font = [UIFont systemFontOfSize:22];
        CGSize size = [address sizeWithFont:contentL.font constrainedToSize:CGSizeMake(self.bounds.size.width*8/10, 60) lineBreakMode:NSLineBreakByWordWrapping];
        contentL.frame=CGRectMake(self.bounds.size.width/10, self.bounds.size.height*8/10-size.height, self.bounds.size.width*8/10, size.height);;
        subL.frame = CGRectMake(self.bounds.size.width/10, self.bounds.size.height*3/10, self.bounds.size.width*9/10, 24);
    }else{
        contentL.frame=CGRectMake(self.bounds.size.width/10, self.bounds.size.height*9/10-20, self.bounds.size.width*8/10, 20);;
        subL.frame = CGRectMake(self.bounds.size.width/10, self.bounds.size.height/10, self.bounds.size.width*9/10, 20);
        contentL.font = [UIFont systemFontOfSize:12];
        subL.font = [UIFont systemFontOfSize:12];
    }
    contentL.textColor = [UIColor orangeColor];
    subL.textColor = [UIColor orangeColor];
}
-(void)layoutBackCover
{
    imageV.image = [UIImage imageNamed:@"story_preview_backCover"];
    imageV.frame=self.bounds;
    subIV.hidden = YES;
    audio.hidden = YES;
    textBG.hidden = YES;
    contentL.hidden = YES;
    subL.hidden = YES;
}
@end
