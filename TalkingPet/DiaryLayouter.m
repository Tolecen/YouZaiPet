//
//  DiaryLayouter.m
//  TalkingPet
//
//  Created by wangxr on 15/6/2.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import "DiaryLayouter.h"
#import "DiaryPageViewController.h"
#import "EGOImageView.h"
#import "TalkingBrowse.h"

@interface DiaryLayouter ()
{
    DiaryView * imageView;
    NSInteger _totalPage;
}
@property (nonatomic,copy)TalkingBrowse*(^layoutBlock)(NSInteger index);
@end
@implementation DiaryLayouter
+(BOOL)haveBlankPage:(int)petalkCount
{
    NSInteger totalPage = 0;
    NSInteger issue = petalkCount;
    totalPage += issue/5*3;
    switch (issue%5) {
        case 1:
        case 2:{
            totalPage+=1;
        }break;
        case 3:{
            totalPage+=2;
        }break;
        case 4:{
            totalPage+=3;
        }break;
        default:
            break;
    }
    totalPage += ceil(totalPage/16.0)*2;
    totalPage +=7;
    if (!(totalPage%2)) {
        return YES;
    }
    return NO;
}
+(NSInteger)totalPage:(int)petalkCount
{
    NSInteger totalPage = 0;
    NSInteger issue = petalkCount;
    totalPage += issue/5*3;
    switch (issue%5) {
        case 1:
        case 2:{
            totalPage+=1;
        }break;
        case 3:{
            totalPage+=2;
        }break;
        case 4:{
            totalPage+=3;
        }break;
        default:
            break;
    }
    totalPage += ceil(totalPage/16.0)*2;
    totalPage +=7;
    if (!(totalPage%2)) {
        totalPage +=1;
    }
    return totalPage;
}
-(id)initWithTotalPage:(NSInteger)totalPage LayoutBlock:(TalkingBrowse* (^)(NSInteger index))block;
{
    if (self = [super init]) {
        self.layoutBlock = block;
        _totalPage = totalPage;
    }
    return self;
}
-(void)setLayouterView:(UIView*)view;
{
    imageView = (DiaryView*)view;
}
-(void)layoutDiaryViewWithIndex:(NSInteger)index
{
    if (index>0&&index<_totalPage) {
        if (index%2) {
            [imageView layoutLeftShadowView];
        }else
        {
            [imageView layoutRightShadowView];
        }
    }
    if (index == _totalPage) {
        [imageView setImage:[UIImage imageNamed:@"endPage"]];
        return;
    }
    if (index == _totalPage-1&&_haveBlankPage()) {
        [imageView setImage:nil];
        return;
    }
    if (index == _totalPage+1) {
        imageView.backgroundColor = [UIColor clearColor];
        [imageView setImage:nil];
        return;
    }
    switch (index) {
        case -1:{
            imageView.image = nil;
            imageView.backgroundColor = [UIColor clearColor];
        }break;
        case 0:{
            NSString *path = [[NSBundle mainBundle] pathForResource:@"cover1" ofType:@"png"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
        }break;
        case 1:{
            NSString *path = [[NSBundle mainBundle] pathForResource:@"cover2" ofType:@"png"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
        }break;
        case 2:{
            NSString *path = [[NSBundle mainBundle] pathForResource:@"flyleaf1" ofType:@"png"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
        }break;
        case 3:{
            NSString *path = [[NSBundle mainBundle] pathForResource:@"flyleaf2" ofType:@"png"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
        }break;
        case 4:{
            NSString *path = [[NSBundle mainBundle] pathForResource:@"flyleaf3" ofType:@"png"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
            EGOImageView * header = [self addCurrentPetHeaderView];
            header.frame = CGRectMake(imageView.frame.size.width*376/1819, imageView.frame.size.height*504/2551, imageView.frame.size.width*202/1819, imageView.frame.size.width*202/1819);
            TalkingBrowse * petalk = _layoutBlock(0);
            EGOImageView * fristPetalk = [self addPetaltViewWithURLstring:petalk.imgUrl];
            fristPetalk.frame = CGRectMake(imageView.frame.size.width*517/1819, imageView.frame.size.height*715/2551, imageView.frame.size.width*981/1819, imageView.frame.size.width*981/1819);
            UILabel * nameL = [self addCurrentPetNameLabelWithColour:[UIColor colorWithWhite:136/255.0 alpha:1]];
            nameL.frame = CGRectMake(imageView.frame.size.width*674/1819, imageView.frame.size.height*1753/2551, imageView.frame.size.width*815/1819, imageView.frame.size.height*41/2551);
            UILabel * genderL = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width*673/1819, imageView.frame.size.height*1838/2551, imageView.frame.size.width*328/1819, imageView.frame.size.height*41/2551)];
            genderL.adjustsFontSizeToFitWidth=YES;
            genderL.numberOfLines = 0;
            genderL.text = [[UserServe sharedUserServe].currentPet.gender integerValue]==1?@"男":@"女";
            genderL.textColor = [UIColor colorWithWhite:136/255.0 alpha:1];
            [imageView addSubview:genderL];
            UILabel * birthdayL = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width*673/1819, imageView.frame.size.height*1925/2551, imageView.frame.size.width*818/1819, imageView.frame.size.height*40/2551)];
            birthdayL.adjustsFontSizeToFitWidth=YES;
            birthdayL.numberOfLines = 0;
            NSDate* date = [UserServe sharedUserServe].currentPet.birthday;
            NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
            dateF.dateFormat = @"yyyy-MM-dd";
            birthdayL.text = [dateF stringFromDate:date];
            birthdayL.textColor = [UIColor colorWithWhite:136/255.0 alpha:1];
            [imageView addSubview:birthdayL];
        }break;
        case 5:{
            NSString *path = [[NSBundle mainBundle] pathForResource:@"flyleaf4" ofType:@"png"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
            UILabel * nameL = [self addCurrentPetNameLabelWithColour:[UIColor colorWithRed:244/255.0 green:180/255.0 blue:207/255.0 alpha:1]];
            nameL.frame = CGRectMake(imageView.frame.size.width*215/1819, imageView.frame.size.height*380/2551, imageView.frame.size.width*1251/1819, imageView.frame.size.height*129/2551);
            nameL.textAlignment = NSTextAlignmentRight;
        }break;
        case 6:{
            NSString *path = [[NSBundle mainBundle] pathForResource:@"flyleaf5" ofType:@"png"];
            imageView.image = [UIImage imageWithContentsOfFile:path];
        }break;
        default:{
            NSInteger a= (index-7)%18;
            switch (a) {
                case 0:{
                    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"section_text_%d",((index-7)/18)%12+1] ofType:@"png"];
                    imageView.image = [UIImage imageWithContentsOfFile:path];
                }break;
                case 1:{
                    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat: @"section_NO_%d",((index-7)/18)%12+1] ofType:@"png"];
                    imageView.image = [UIImage imageWithContentsOfFile:path];
                }break;
                default:{
                    NSInteger b = ((a-2)+(index-7)/18*16)%3;
                    switch (b) {
                        case 0:{
                            NSString *path = [[NSBundle mainBundle] pathForResource:@"towPetalkStyle1" ofType:@"png"];
                            imageView.image = [UIImage imageWithContentsOfFile:path];
                            TalkingBrowse * petalk = _layoutBlock(((a-2)+(index-7)/18*16)/3*5);
                            if (petalk) {
                                EGOImageView * header = [self addCurrentPetHeaderView];
                                header.frame = CGRectMake(imageView.frame.size.width*148/1819, imageView.frame.size.height*557/2551, imageView.frame.size.width*168/1819, imageView.frame.size.width*168/1819);
                                EGOImageView * petalkView =  [self addPetaltViewWithURLstring:petalk.imgUrl];
                                petalkView.frame = CGRectMake(imageView.frame.size.width*177/1819, imageView.frame.size.height*817/2551, imageView.frame.size.width*688/1819, imageView.frame.size.width*688/1819);
                                UILabel * nameL = [self addCurrentPetNameLabelWithColour:[UIColor colorWithWhite:113/255.0 alpha:1]];
                                nameL.frame = CGRectMake(imageView.frame.size.width*343/1819, imageView.frame.size.height*614/2551, imageView.frame.size.width*536/1819, imageView.frame.size.height*41/2551);
                                UILabel * textL = [self addTextLabelWithString:petalk.descriptionContent];
                                CGSize size = [textL.text sizeWithFont:textL.font constrainedToSize:CGSizeMake(imageView.frame.size.width*538/1819, imageView.frame.size.height*375/2551) lineBreakMode:NSLineBreakByWordWrapping];
                                textL.frame = CGRectMake(imageView.frame.size.width*292/1819, imageView.frame.size.height*1922/2551, size.width, size.height);
                                UILabel * timeL = [self addTimeLabelWithDate:[NSDate dateWithTimeIntervalSince1970:[petalk.publishTime doubleValue]]];
                                timeL.frame =  CGRectMake(imageView.frame.size.width*340/1819, imageView.frame.size.height*668/2551, imageView.frame.size.width*226/1819, imageView.frame.size.height*23/2551);
                            }
                            
                            petalk = _layoutBlock(((a-2)+(index-7)/18*16)/3*5+1);
                            if (petalk) {
                                EGOImageView * header = [self addCurrentPetHeaderView];
                                header.frame = CGRectMake(imageView.frame.size.width*885/1819, imageView.frame.size.height*547/2551, imageView.frame.size.width*168/1819, imageView.frame.size.width*168/1819);
                                EGOImageView * petalkView =  [self addPetaltViewWithURLstring:petalk.imgUrl];
                                petalkView.frame = CGRectMake(imageView.frame.size.width*1008/1819, imageView.frame.size.height*1188/2551, imageView.frame.size.width*688/1819, imageView.frame.size.width*688/1819);
                                UILabel * nameL = [self addCurrentPetNameLabelWithColour:[UIColor colorWithWhite:113/255.0 alpha:1]];
                                nameL.frame = CGRectMake(imageView.frame.size.width*1081/1819, imageView.frame.size.height*613/2551, imageView.frame.size.width*614/1819, imageView.frame.size.height*41/2551);
                                UILabel * textL = [self addTextLabelWithString:petalk.descriptionContent];
                                CGSize size = [textL.text sizeWithFont:textL.font constrainedToSize:CGSizeMake(imageView.frame.size.width*619/1819, imageView.frame.size.height*276/2551) lineBreakMode:NSLineBreakByWordWrapping];
                                textL.frame = CGRectMake(imageView.frame.size.width*1043/1819, imageView.frame.size.height*877/2551,size.width,size.height);
                                UILabel * timeL = [self addTimeLabelWithDate:[NSDate dateWithTimeIntervalSince1970:[petalk.publishTime doubleValue]]];
                                timeL.frame =  CGRectMake(imageView.frame.size.width*1081/1819, imageView.frame.size.height*667/2551, imageView.frame.size.width*226/1819, imageView.frame.size.height*23/2551);
                            }
                        }break;
                        case 1:{
                            NSString *path = [[NSBundle mainBundle] pathForResource:@"onePetalk" ofType:@"png"];
                            imageView.image = [UIImage imageWithContentsOfFile:path];
                            TalkingBrowse * petalk = _layoutBlock(((a-2)+(index-7)/18*16)/3*5+2);
                            if (petalk) {
                                EGOImageView * petalkView =  [self addPetaltViewWithURLstring:petalk.imgUrl];
                                petalkView.frame = CGRectMake(imageView.frame.size.width*412/1819, imageView.frame.size.height*1099/2551, imageView.frame.size.width*1138/1819, imageView.frame.size.width*1138/1819);
                                EGOImageView * header = [self addCurrentPetHeaderView];
                                header.frame = CGRectMake(imageView.frame.size.width*262/1819, imageView.frame.size.height*484/2551, imageView.frame.size.width*168/1819, imageView.frame.size.width*168/1819);
                                UILabel * nameL = [self addCurrentPetNameLabelWithColour:[UIColor colorWithWhite:113/255.0 alpha:1]];
                                nameL.frame = CGRectMake(imageView.frame.size.width*475/1819, imageView.frame.size.height*542/2551, imageView.frame.size.width*1051/1819, imageView.frame.size.height*41/2551);
                                UILabel * textL = [self addTextLabelWithString:petalk.descriptionContent];
                                CGSize size = [textL.text sizeWithFont:textL.font constrainedToSize:CGSizeMake(imageView.frame.size.width*800/1819, imageView.frame.size.height*241/2551) lineBreakMode:NSLineBreakByWordWrapping];
                                textL.frame = CGRectMake(imageView.frame.size.width*419/1819, imageView.frame.size.height*839/2551, size.width,size.height);
                                UILabel * timeL = [self addTimeLabelWithDate:[NSDate dateWithTimeIntervalSince1970:[petalk.publishTime doubleValue]]];
                                timeL.frame =  CGRectMake(imageView.frame.size.width*475/1819, imageView.frame.size.height*598/2551, imageView.frame.size.width*226/1819, imageView.frame.size.height*23/2551);
                            }
                        }break;
                        default:{
                            NSString *path = [[NSBundle mainBundle] pathForResource:@"towPetalkStyle2" ofType:@"png"];
                            imageView.image = [UIImage imageWithContentsOfFile:path];;
                            TalkingBrowse * petalk = _layoutBlock(((a-2)+(index-7)/18*16)/3*5+3);
                            if (petalk) {
                                EGOImageView * header = [self addCurrentPetHeaderView];
                                header.frame = CGRectMake(imageView.frame.size.width*275/1819, imageView.frame.size.height*530/2551, imageView.frame.size.width*168/1819, imageView.frame.size.width*168/1819);
                                EGOImageView * petalkView =  [self addPetaltViewWithURLstring:petalk.imgUrl];
                                petalkView.frame = CGRectMake(imageView.frame.size.width*1015/1819, imageView.frame.size.height*520/2551, imageView.frame.size.width*688/1819, imageView.frame.size.width*688/1819);
                                UILabel * nameL = [self addCurrentPetNameLabelWithColour:[UIColor colorWithWhite:113/255.0 alpha:1]];
                                nameL.frame = CGRectMake(imageView.frame.size.width*469/1819, imageView.frame.size.height*588/2551, imageView.frame.size.width*524/1819, imageView.frame.size.height*41/2551);
                                UILabel * textL = [self addTextLabelWithString:petalk.descriptionContent];
                                CGSize size = [textL.text sizeWithFont:textL.font constrainedToSize:CGSizeMake(imageView.frame.size.width*462/1819, imageView.frame.size.height*213/2551) lineBreakMode:NSLineBreakByWordWrapping];
                                textL.frame = CGRectMake(imageView.frame.size.width*523/1819, imageView.frame.size.height*865/2551, size.width,size.height);
                                UILabel * timeL = [self addTimeLabelWithDate:[NSDate dateWithTimeIntervalSince1970:[petalk.publishTime doubleValue]]];
                                timeL.frame =  CGRectMake(imageView.frame.size.width*468/1819, imageView.frame.size.height*640/2551, imageView.frame.size.width*226/1819, imageView.frame.size.height*23/2551);
                            }
                            
                            petalk = _layoutBlock(((a-2)+(index-7)/18*16)/3*5+4);
                            if (petalk) {
                                EGOImageView * header = [self addCurrentPetHeaderView];
                                header.frame = CGRectMake(imageView.frame.size.width*1282/1819, imageView.frame.size.height*1447/2551, imageView.frame.size.width*168/1819, imageView.frame.size.width*168/1819);
                                EGOImageView * petalkView =  [self addPetaltViewWithURLstring:petalk.imgUrl];
                                petalkView.frame = CGRectMake(imageView.frame.size.width*193/1819, imageView.frame.size.height*1434/2551, imageView.frame.size.width*688/1819, imageView.frame.size.width*688/1819);
                                UILabel * nameL = [self addCurrentPetNameLabelWithColour:[UIColor colorWithWhite:113/255.0 alpha:1]];
                                nameL.frame = CGRectMake(imageView.frame.size.width*885/1819, imageView.frame.size.height*1509/2551, imageView.frame.size.width*373/1819, imageView.frame.size.height*41/2551);
                                nameL.textAlignment = NSTextAlignmentRight;
                                UILabel * textL = [self addTextLabelWithString:petalk.descriptionContent];
                                CGSize size = [textL.text sizeWithFont:textL.font constrainedToSize:CGSizeMake(imageView.frame.size.width*568/1819, imageView.frame.size.height*455/2551) lineBreakMode:NSLineBreakByWordWrapping];
                                textL.frame = CGRectMake(imageView.frame.size.width*917/1819, imageView.frame.size.height*1812/2551, size.width,size.height);
                                UILabel * timeL = [self addTimeLabelWithDate:[NSDate dateWithTimeIntervalSince1970:[petalk.publishTime doubleValue]]];
                                timeL.frame =  CGRectMake(imageView.frame.size.width*1035/1819, imageView.frame.size.height*1563/2551, imageView.frame.size.width*226/1819, imageView.frame.size.height*23/2551);
                                timeL.textAlignment = NSTextAlignmentLeft;
                            }
                        }break;
                    }
                }break;
            }
        }break;
    }
}
- (EGOImageView*)addCurrentPetHeaderView
{
    EGOImageView * header = [[EGOImageView alloc]init];
    header.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/100",[UserServe sharedUserServe].currentPet.headImgURL]];
    [imageView addSubview:header];
    return header;
}
- (EGOImageView*)addPetaltViewWithURLstring:(NSString*)url
{
    EGOImageView * petaltView = [[EGOImageView alloc]init];
    petaltView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/300",url]];
    [imageView addSubview:petaltView];
    return petaltView;
}
-(UILabel*)addCurrentPetNameLabelWithColour:(UIColor*)colour
{
    UILabel * nameL = [[UILabel alloc] init];
    nameL.font = [UIFont fontWithName:@"DFPWaWaW5" size:14];
    nameL.adjustsFontSizeToFitWidth=YES;
    nameL.numberOfLines = 0;
    nameL.text = [UserServe sharedUserServe].currentPet.nickname;
    nameL.textColor = colour;
    [imageView addSubview:nameL];
    return nameL;
}
-(UILabel*)addTextLabelWithString:(NSString*)str
{
    UILabel * textL = [[UILabel alloc] init];
    CGFloat font = imageView.frame.size.width*5/320;
    textL.font = [UIFont fontWithName:@"DFPWaWaW5" size:font];
    textL.numberOfLines = 0;
    textL.text = str;
    textL.textColor = [UIColor colorWithWhite:131/255.0 alpha:1];
    [imageView addSubview:textL];
    return textL;
}
-(UILabel*)addTimeLabelWithDate:(NSDate *)date
{
    UILabel * timeL = [[UILabel alloc] init];
    timeL.adjustsFontSizeToFitWidth=YES;
    timeL.numberOfLines = 0;
    NSDateFormatter * dateF= [[NSDateFormatter alloc]init];
    dateF.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    timeL.text = [dateF stringFromDate:date];
    timeL.textColor = [UIColor colorWithWhite:131/255.0 alpha:1];
    [imageView addSubview:timeL];
    timeL.textAlignment = NSTextAlignmentRight;
    return timeL;
}
@end
