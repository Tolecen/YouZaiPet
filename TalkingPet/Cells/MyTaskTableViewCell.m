//
//  MyTaskTableViewCell.m
//  TalkingPet
//
//  Created by Tolecen on 15/3/12.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "MyTaskTableViewCell.h"

@implementation MyTaskTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.bgImageV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, ScreenWidth-10, (ScreenWidth-10)*0.3)];
        self.bgImageV.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
        [self.contentView addSubview:self.bgImageV];
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, ScreenWidth-15-5-80-10, 20)];
        self.nameL.backgroundColor = [UIColor clearColor];
        self.nameL.font = [UIFont boldSystemFontOfSize:16];
        self.nameL.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
        [self.contentView addSubview:self.nameL];
        [self.nameL setLineBreakMode:NSLineBreakByCharWrapping];
        self.nameL.numberOfLines = 0;
        self.nameL.text = @"抽奖活动";
        
        self.ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.ruleBtn setFrame:CGRectMake(0, 15, 100, 30)];
        [self.ruleBtn setBackgroundColor:[UIColor clearColor]];
        [self.ruleBtn setTitle:@"查看排名规则" forState:UIControlStateNormal];
        [self.ruleBtn setTitleColor:[UIColor colorWithRed:0.235 green:0.776 blue:1 alpha:1] forState:UIControlStateNormal];
        [self.ruleBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.ruleBtn addTarget:self action:@selector(toRulePage) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.ruleBtn];
        
        self.desL = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, ScreenWidth-15-5-80-10, 20)];
        self.desL.backgroundColor = [UIColor clearColor];
        self.desL.font = [UIFont systemFontOfSize:14];
        self.desL.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
        [self.contentView addSubview:self.desL];
        [self.desL setLineBreakMode:NSLineBreakByCharWrapping];
        self.desL.numberOfLines = 0;
        self.desL.text = @"毛巾萨达金卡三等奖阿斯利康多久啊可视对讲卡死";
        
        self.prizeL = [[UILabel alloc] initWithFrame:CGRectMake(15, 65, ScreenWidth-15-5-80-10, 20)];
        self.prizeL.backgroundColor = [UIColor clearColor];
        self.prizeL.font = [UIFont systemFontOfSize:14];
        self.prizeL.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
        [self.contentView addSubview:self.prizeL];
        [self.prizeL setLineBreakMode:NSLineBreakByCharWrapping];
        self.prizeL.numberOfLines = 0;
        self.prizeL.text = @"大熊大熊大熊大熊大熊";
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(15, 90, ScreenWidth-15-5-80-10, 20)];
        self.timeL.backgroundColor = [UIColor clearColor];
        self.timeL.font = [UIFont systemFontOfSize:14];
        self.timeL.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.timeL];
//        [self.timeL setLineBreakMode:NSLineBreakByCharWrapping];
//        self.timeL.numberOfLines = 0;
        self.timeL.text = @"剩余: 1天12小时23分";
        
        self.statusImageV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-5-80, 5, 80, 80)];
        [self.contentView addSubview:self.statusImageV];
        
        self.pubBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.pubBtn setFrame:CGRectMake(ScreenWidth-10-90, 80, 90, 40)];
        [self.pubBtn setTitle:@"去完成任务>" forState:UIControlStateNormal];
        [self.pubBtn setTitleColor:[UIColor colorWithRed:254/255.0f green:253/255.0f blue:168/255.0f alpha:1] forState:UIControlStateNormal];
        [self.contentView addSubview:self.pubBtn];
        [self.pubBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.pubBtn addTarget:self action:@selector(doSth) forControlEvents:UIControlEventTouchUpInside];
        
        
//        self.noPubL = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-10-100, 15, 100, 20)];
//        self.noPubL.backgroundColor = [UIColor clearColor];
//        self.noPubL.font = [UIFont systemFontOfSize:14];
//        self.noPubL.textColor = [UIColor colorWithWhite:140/255.0f alpha:1];
//        [self.contentView addSubview:self.noPubL];
//        [self.noPubL setLineBreakMode:NSLineBreakByCharWrapping];
//        self.noPubL.numberOfLines = 0;
//        self.noPubL.text = @"还未发布";
    }
    return self;
}
-(void)toRulePage
{
    if ([self.delegate respondsToSelector:@selector(toTheRulePage)]) {
        [self.delegate toTheRulePage];
    }
}
-(void)doSth
{
    if ([[self.actDict objectForKey:@"catagory"] isEqualToString:@"1"]||[[self.actDict objectForKey:@"catagory"] isEqualToString:@"3"]) {
        if ([self.delegate respondsToSelector:@selector(toPageForType:TagId:)]) {
            [self.delegate toPageForType:[[self.actDict objectForKey:@"catagory"] intValue] TagId:[self.actDict objectForKey:@"tagId"]];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(toPageForType:TagId:)]) {
            [self.delegate toPageForType:[[self.actDict objectForKey:@"catagory"] intValue] TagId:nil];
        }
    }
}
-(void)layoutSubviews
{
    self.pubBtn.hidden = NO;
    NSString * des = self.status==1?[[self.actDict objectForKey:@"title"] stringByAppendingString:@"(还未发布内容)"]:[self.actDict objectForKey:@"title"];
    NSString * award = [self.actDict objectForKey:@"awardName"];
    CGSize h1 = [des sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenWidth-15-5-80-10, 100) lineBreakMode:NSLineBreakByCharWrapping];
    CGSize h2 = [award sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenWidth-15-5-80-10, 100) lineBreakMode:NSLineBreakByCharWrapping];
    [self.desL setFrame:CGRectMake(15, 40, ScreenWidth-15-5-80-10, h1.height)];
    [self.desL setText:des];
    
    self.timeL.hidden = NO;
    self.hremianTimeS = [self.remainTime doubleValue]/1000;
    
    
    if ([[self.actDict objectForKey:@"catagory"] isEqualToString:@"1"]) {
        [self.nameL setText:@"抽奖活动"];
        self.ruleBtn.hidden = YES;
         [self.pubBtn setTitle:@"去发布说说>" forState:UIControlStateNormal];
        [self.bgImageV setBackgroundColor:[UIColor colorWithRed:255/255.0f green:204/255.0f blue:227/255.0f alpha:1]];
        if (self.status==1) {
            self.pubBtn.hidden = NO;
            [self.statusImageV setImage:[UIImage imageNamed:@"raffleing"]];
        }
        else if (self.status==2){
            self.pubBtn.hidden = YES;
            [self.statusImageV setImage:[UIImage imageNamed:@"iamin_raffle"]];
        }
        else if (self.status==3){
            self.pubBtn.hidden = YES;
            [self.statusImageV setImage:[UIImage imageNamed:@"list_not winning"]];
        }
        else if (self.status==4){
            self.pubBtn.hidden = YES;
            [self.statusImageV setImage:[UIImage imageNamed:@"win"]];
        }
        else
        {
            self.pubBtn.hidden = YES;
            [self.statusImageV setImage:nil];
        }
    }
    else if ([[self.actDict objectForKey:@"catagory"] isEqualToString:@"2"]) {
        [self.nameL setText:@"完成任务获奖"];
        self.ruleBtn.hidden = YES;
         [self.pubBtn setTitle:@"去完成任务>" forState:UIControlStateNormal];
        [self.bgImageV setBackgroundColor:[UIColor colorWithRed:223/255.0f green:206/255.0f blue:255/255.0f alpha:1]];
        if (self.status==2) {
            self.pubBtn.hidden = NO;
            [self.statusImageV setImage:[UIImage imageNamed:@"list_missioning"]];
        }
        else if (self.status==3){
            self.pubBtn.hidden = YES;
            [self.statusImageV setImage:[UIImage imageNamed:@"list_mission lose"]];
        }
        else if (self.status==4){
            self.pubBtn.hidden = YES;
            [self.statusImageV setImage:[UIImage imageNamed:@"list_missioned"]];
        }
        else
        {
            self.pubBtn.hidden = YES;
            [self.statusImageV setImage:nil];
        }
    }
    else if ([[self.actDict objectForKey:@"catagory"] isEqualToString:@"3"]) {
        [self.nameL setText:@"有奖排名"];
        self.ruleBtn.hidden = NO;
        CGSize cn = [self.nameL.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 100) lineBreakMode:NSLineBreakByCharWrapping];
        [self.ruleBtn setFrame:CGRectMake(15+cn.width+10, 10, 100, 30)];
        [self.pubBtn setTitle:@"去发布说说>" forState:UIControlStateNormal];
        [self.bgImageV setBackgroundColor:[UIColor colorWithRed:183/255.0f green:232/255.0f blue:254/255.0f alpha:1]];
        if (self.status==1) {
            self.pubBtn.hidden = NO;
            [self.statusImageV setImage:[UIImage imageNamed:@"list_ranking"]];
        }
        else if (self.status==2){
            self.pubBtn.hidden = YES;
            [self.statusImageV setImage:[UIImage imageNamed:@"iamin_rank"]];
        }
        else if (self.status==3){
            self.pubBtn.hidden = YES;
            [self.statusImageV setImage:[UIImage imageNamed:@"list_not rank"]];
        }
        else if (self.status==4){
            self.pubBtn.hidden = YES;
            [self.statusImageV setImage:[UIImage imageNamed:@"list_rank"]];
        }
        else
        {
            self.pubBtn.hidden = YES;
            [self.statusImageV setImage:nil];
        }
    }
    else
    {
        self.pubBtn.hidden = YES;
        [self.statusImageV setImage:nil];
    }
    

    [self.prizeL setFrame:CGRectMake(15, self.desL.frame.origin.y+h1.height+5, ScreenWidth-15-5-80-10, h2.height)];
    [self.prizeL setText:award];
    [self.timeL setFrame:CGRectMake(15, self.prizeL.frame.origin.y+h2.height+5, ScreenWidth-15-5-80-10, 20)];
    [self.pubBtn setFrame:CGRectMake(ScreenWidth-10-90, self.timeL.frame.origin.y-8, 90, 40)];
    
    [self.bgImageV setFrame:CGRectMake(5, 5, ScreenWidth-10, self.timeL.frame.origin.y+20+5)];
    

    int d = 0;
    int h = 0;
    int m = 0;
    int s = 0;
    if (self.hremianTimeS>=(3600*24)) {
        d = self.hremianTimeS/(3600*24);
        h = (self.hremianTimeS-3600*24*d)/3600;
        m = (self.hremianTimeS-3600*24*d - 3600*h)/60;
        [self.timeL setText:[NSString stringWithFormat:@"距离截止：%d天%d小时%d分",d,h,m]];
    }
    else if(self.hremianTimeS>=3600)
    {
        h = self.hremianTimeS/3600;
        m = (self.hremianTimeS-3600*h)/60;
        s = self.hremianTimeS-h*3600-m*60;
        [self.timeL setText:[NSString stringWithFormat:@"距离截止：%d小时%d分%d秒",h,m,s]];
    }
    else if (self.hremianTimeS>=60){
        m = self.hremianTimeS/60;
        s = self.hremianTimeS-m*60;
        [self.timeL setText:[NSString stringWithFormat:@"距离截止：%d分钟%d秒",m,s]];
    }
    else if (self.hremianTimeS>=0){
        [self.timeL setText:[NSString stringWithFormat:@"距离截止：%d秒",(int)self.hremianTimeS]];
    }
    else
    {
        self.pubBtn.hidden = YES;
        if (self.status!=4&&self.status!=3) {
            [self.statusImageV setImage:nil];
            [self.timeL setText:@"结果统计中"];
            
        }
        else
            self.timeL.hidden = YES;
    }
    
    
    if(remainTimer!=nil)
    {
        [remainTimer invalidate];
        remainTimer=nil;
    }
    if (self.hremianTimeS>0) {

        remainTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showRemainTime) userInfo:nil repeats:YES];
    }

    
    
    
}
-(void)showRemainTime
{
    self.hremianTimeS--;
    self.remainTime = [NSString stringWithFormat:@"%f",self.hremianTimeS*1000];
    int d = 0;
    int h = 0;
    int m = 0;
    int s = 0;
    if (self.hremianTimeS>=(3600*24)) {
        d = self.hremianTimeS/(3600*24);
        h = (self.hremianTimeS-3600*24*d)/3600;
        m = (self.hremianTimeS-3600*24*d - 3600*h)/60;
        [self.timeL setText:[NSString stringWithFormat:@"距离截止：%d天%d小时%d分",d,h,m]];
    }
    else if(self.hremianTimeS>=3600)
    {
        h = self.hremianTimeS/3600;
        m = (self.hremianTimeS-3600*h)/60;
        s = self.hremianTimeS-h*3600-m*60;
        [self.timeL setText:[NSString stringWithFormat:@"距离截止：%d小时%d分%d秒",h,m,s]];
    }
    else if (self.hremianTimeS>=60){
        m = self.hremianTimeS/60;
        s = self.hremianTimeS-m*60;
        [self.timeL setText:[NSString stringWithFormat:@"距离截止：%d分钟%d秒",m,s]];
    }
    else if (self.hremianTimeS>=0){
        [self.timeL setText:[NSString stringWithFormat:@"距离截止：%d秒",(int)self.hremianTimeS]];
    }
    else
        self.timeL.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(resetTimeforIndex:Time:)]) {
        [self.delegate resetTimeforIndex:self.cellIndex Time:self.remainTime];
    }
    if (self.hremianTimeS<=1) {
        self.hremianTimeS = 0;
        if(remainTimer!=nil)
        {
            [remainTimer invalidate];
            remainTimer=nil;
        }
    }
    
}
-(void)dealloc
{
    
}
-(void)removeFromSuperview
{
    [super removeFromSuperview];
    if(remainTimer)
    {
        [remainTimer invalidate];
        remainTimer=nil;
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
