//
//  PostCardView.m
//  TalkingPet
//
//  Created by Tolecen on 15/6/23.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "PostCardView.h"

@implementation PostCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage * timg = [UIImage imageNamed:@"postcard_template1"];
        [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.width*timg.size.height/timg.size.width)];
        self.backgroundColor = [UIColor clearColor];
//        [self.bgScrollV addSubview:self.imageVBg];
        
        self.spritesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width*timg.size.height/timg.size.width)];
        self.spritesView.backgroundColor = [UIColor colorWithWhite:240/255.0f alpha:1];
        [self addSubview:self.spritesView];
        
        self.templateImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width*timg.size.height/timg.size.width)];
        [self.templateImageV setImage:timg];
        [self addSubview:self.templateImageV];
        
        self.pcJsonDict = [self readPostion];
        
        [self creatAllSprites];
    }
    return self;
}
-(void)creatAllSprites
{
    self.headerV = [[EGOImageView alloc] initWithFrame:CGRectZero];
    self.contentImageV = [[EGOImageView alloc] initWithFrame:CGRectZero];
    self.erweimaV = [[EGOImageView alloc] initWithFrame:CGRectZero];
    self.pcContentL = [[UILabel alloc] initWithFrame:CGRectZero];
    self.pcContentL.numberOfLines = 0;
    self.pcContentL.lineBreakMode = NSLineBreakByCharWrapping;
    self.pcContentL.backgroundColor = [UIColor clearColor];
    self.pcContentL.font = [UIFont fontWithName:@"DFPWaWaW5" size:12];
    self.pcContentL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    self.nicknameL = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nicknameL.backgroundColor = [UIColor clearColor];
    self.nicknameL.textColor = [UIColor colorWithWhite:120/255.0f alpha:1];
    self.nicknameL.font = [UIFont fontWithName:@"DFPWaWaW5" size:16];
    self.timeL = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeL.backgroundColor = [UIColor whiteColor];
    self.timeL.textColor = [UIColor colorWithRed:220/255.0f green:20/255.0f blue:60/255.0f alpha:1];
    self.timeL.textAlignment = NSTextAlignmentCenter;
    self.timeL.adjustsFontSizeToFitWidth=YES;
    self.timeL2 = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeL2.backgroundColor = [UIColor whiteColor];
    self.timeL2.textColor = [UIColor colorWithRed:220/255.0f green:20/255.0f blue:60/255.0f alpha:1];
    self.timeL2.textAlignment = NSTextAlignmentCenter;
    self.timeL2.adjustsFontSizeToFitWidth =YES;
    
    float spriteW = self.spritesView.frame.size.width;
    float spriteH = self.spritesView.frame.size.height;
    float w = [[self.pcJsonDict objectForKey:@"width"] floatValue];
    float h = [[self.pcJsonDict objectForKey:@"height"] floatValue];
    
    
    NSArray * spArray = [self.pcJsonDict objectForKey:@"sprites"];
    for (int i = 0; i<spArray.count; i++) {
        NSDictionary * t = spArray[i];
        float startX = [self getRatioWithNum:[[t objectForKey:@"startX"] floatValue] All:w];
        float startY = [self getRatioWithNum:[[t objectForKey:@"startY"] floatValue] All:h];
        float width = [self getRatioWithNum:[[t objectForKey:@"spriteWidth"] floatValue] All:w];
        float height = [self getRatioWithNum:[[t objectForKey:@"spriteHeight"] floatValue] All:h];
        NSInteger type = [[t objectForKey:@"type"] integerValue];
        //        TalkingBrowse * talking = [self.myShuoShuoArray objectAtIndex:self.selectedIndex];
        //        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //        [dateFormatter setDateFormat:@"MM/dd*yyyy"];
        //        NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[talking.publishTime doubleValue]]];
        if (type==1) {
            [self.headerV setFrame:CGRectMake(spriteW*startX, spriteH*startY, spriteW*width, spriteH*height)];
            //            self.headerV.imageURL = [NSURL URLWithString:[UserServe sharedUserServe].account.headImgURL];
            [self.spritesView addSubview:self.headerV];
        }
        else if (type==2){
            [self.contentImageV setFrame:CGRectMake(spriteW*startX, spriteH*startY, spriteW*width, spriteH*height)];
            
            //            self.contentImageV.imageURL = [NSURL URLWithString:talking.imgUrl];
            [self.spritesView addSubview:self.contentImageV];
        }
        else if (type==3){
            [self.pcContentL setFrame:CGRectMake(spriteW*startX, spriteH*startY, spriteW*width, spriteH*height)];
            //            self.pcContentL.backgroundColor = [UIColor redColor];
            //            [self.pcContentL setText:[@"    " stringByAppendingString:talking.descriptionContent]];
            [self.templateImageV addSubview:self.pcContentL];
        }
        else if (type==4){
            [self.timeL setFrame:CGRectMake(spriteW*startX, spriteH*startY, spriteW*width, spriteH*height)];
            //            self.timeL.backgroundColor = [UIColor redColor];
            //            self.timeL.text = [messageDateStr componentsSeparatedByString:@"*"][0];
            [self.templateImageV addSubview:self.timeL];
            
        }
        else if (type==5){
            
            [self.timeL2 setFrame:CGRectMake(spriteW*startX, spriteH*startY, spriteW*width, spriteH*height)];
            //            self.timeL2.backgroundColor = [UIColor redColor];
            //            self.timeL2.text = [messageDateStr componentsSeparatedByString:@"*"][1];
            [self.templateImageV addSubview:self.timeL2];
            
        }
        else if (type==6)
        {
            [self.nicknameL setFrame:CGRectMake(spriteW*startX, spriteH*startY-8, spriteW*width, 20)];
            //            [self.nicknameL setText:[UserServe sharedUserServe].account.nickname];
            [self.templateImageV addSubview:self.nicknameL];
        }
        
    }
    
    
}
-(NSDictionary *)readPostion
{
    NSString *resText = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"postcardjson" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
    NSDictionary * dict = [resText JSONValue];
    NSLog(@"postcard_json_data:%@",dict);
    return dict;
}
-(void)displaySpritesWithTalking:(TalkingBrowse *)talking
{
    
    NSArray * spArray = [self.pcJsonDict objectForKey:@"sprites"];
    for (int i = 0; i<spArray.count; i++) {
        NSDictionary * t = spArray[i];
        
        NSInteger type = [[t objectForKey:@"type"] integerValue];
//        TalkingBrowse * talking = [self.myShuoShuoArray objectAtIndex:self.selectedIndex];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd*yyyy"];
        NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[talking.publishTime doubleValue]]];
        if (type==1) {
            self.headerV.imageURL = [NSURL URLWithString:[UserServe sharedUserServe].account.headImgURL];
        }
        else if (type==2){
            self.contentImageV.imageURL = [NSURL URLWithString:talking.imgUrl];
        }
        else if (type==3){
            [self.pcContentL setText:[@"    " stringByAppendingString:talking.descriptionContent]];
        }
        else if (type==4){
            self.timeL.text = [messageDateStr componentsSeparatedByString:@"*"][0];
            
        }
        else if (type==5){
            self.timeL2.text = [messageDateStr componentsSeparatedByString:@"*"][1];
            
        }
        else if (type==6)
        {
            [self.nicknameL setText:[UserServe sharedUserServe].account.nickname];
        }
        
    }
    
    
}
-(float)getRatioWithNum:(float)num All:(float)all
{
    return num/all;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
