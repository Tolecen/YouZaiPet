//
//  TalkingBrowse.m
//  TalkingPet
//
//  Created by Tolecen on 14-7-11.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "TalkingBrowse.h"

@implementation TalkingBrowse
- (id)initWithHostInfo:(NSDictionary*)info
{
    self = [super init];
    if (self) {
        self.theID = [info objectForKey:@"petalkId"];
        self.thumbImgUrl = [info objectForKey:@"thumbUrl"];
        self.listId = [info objectForKey:@"id"];
        self.relationShip = [info objectForKey:@"rs"];
        self.tagArray = [info objectForKey:@"tags"];
        self.ifZan = [[info objectForKey:@"z"] isEqualToString:@"0"]?NO:YES;
        NSDictionary * aniDict = [[info objectForKey:@"decorations"]  firstObject];
//        self.tagID = [info objectForKey:@"tagID"];
//        self.animationImg = animationImgMake(0,[[aniDict objectForKey:@"width"]floatValue], [[aniDict objectForKey:@"height"]floatValue], [[aniDict objectForKey:@"centerX"]floatValue], [[aniDict objectForKey:@"centerY"]floatValue], [[aniDict objectForKey:@"rotationX"]floatValue],[[aniDict objectForKey:@"rotationY"]floatValue],[[aniDict objectForKey:@"rotationZ"]floatValue]);
        self.playAnimationImg = [[PlayAnimationImg alloc] init];
        self.playAnimationImg.fileName = [[aniDict objectForKey:@"origin"] objectForKey:@"fileName"];
        self.playAnimationImg.fileType = [[aniDict objectForKey:@"origin"] objectForKey:@"fileType"];
        self.playAnimationImg.fileUrlStr = [[aniDict objectForKey:@"origin"] objectForKey:@"url"];
        self.playAnimationImg.width = [[aniDict objectForKey:@"width"] floatValue];
        self.playAnimationImg.height = [[aniDict objectForKey:@"height"] floatValue];
        self.playAnimationImg.centerX = [[aniDict objectForKey:@"centerX"] floatValue];
        self.playAnimationImg.centerY = [[aniDict objectForKey:@"centerY"] floatValue];
        self.playAnimationImg.rotationX = [[aniDict objectForKey:@"rotationX"] floatValue];
        self.playAnimationImg.rotationY = [[aniDict objectForKey:@"rotationY"] floatValue];
        self.playAnimationImg.rotationZ = [[aniDict objectForKey:@"rotationZ"] floatValue];
        
        
        self.petInfo = [[Pet alloc]init];

        
        id petDict = [info objectForKey:@"pet"];
        if (petDict&&[petDict isKindOfClass:[NSDictionary class]]) {
            self.petInfo.petID = [petDict objectForKey:@"id"];
            self.petInfo.nickname = [petDict objectForKey:@"nickname"];
            self.petInfo.headImgURL = [petDict objectForKey:@"head"];
            self.petInfo.gender = [petDict objectForKey:@"gender"];
            //        self.petInfo.breed = [petDict objectForKey:@"type"];
            
            PetCategoryParser * pet = [[PetCategoryParser alloc] init];
            
            self.petInfo.breed = [pet breedWithIDcode:[[petDict objectForKey:@"type"] integerValue]];
            self.petInfo.ageStr = [Common calAgeWithBirthDate:[petDict objectForKey:@"birthday"]];
            self.petInfo.grade = [petDict[@"grade"] stringByReplacingOccurrencesOfString:@"DJ" withString:@""];
            self.petInfo.ifDaren = [petDict[@"star"] isEqualToString:@"1"]?YES:NO;
        }
        else
        {
            self.petInfo.petID = [info objectForKey:@"petId"];
            self.petInfo.nickname = [info objectForKey:@"petNickName"];
            self.petInfo.headImgURL = [info objectForKey:@"petHeadPortrait"];
        }
        
        
        
        
        self.imgUrl = [info objectForKey:@"photoUrl"];
        self.audioUrl = [info objectForKey:@"audioUrl"];
        NSArray * g = [self.audioUrl componentsSeparatedByString:@"/"];
        self.audioName = [g lastObject];
        self.descriptionContent = [info objectForKey:@"description"];
        NSString * lastTime = [info objectForKey:@"audioSecond"];
        if ([lastTime intValue]==0) {
            self.audioDuration = @"1";
        }
        else if ([lastTime floatValue]>1000){
            self.audioDuration = [NSString stringWithFormat:@"%f",[lastTime floatValue]/1000.0f];
        }
        else
            self.audioDuration = lastTime;
//        self.audioDuration = ([[info objectForKey:@"audioSecond"] intValue]==0)?@"1":[info objectForKey:@"audioSecond"];
        self.publishTime = [NSString stringWithFormat:@"%.0f",(double)([[info objectForKey:@"createTime"] longLongValue]/1000)];
        if ([[info objectForKey:@"counter"] isKindOfClass:[NSDictionary class]]) {
            self.forwardNum = [[info objectForKey:@"counter"] objectForKey:@"relay"];
            self.commentNum = [[info objectForKey:@"counter"] objectForKey:@"comment"];
            self.favorNum = [[info objectForKey:@"counter"] objectForKey:@"favour"];
            self.shareNum = [[info objectForKey:@"counter"] objectForKey:@"share"];
            self.browseNum = [[info objectForKey:@"counter"] objectForKey:@"play"];
        }
        
        if ([info objectForKey:@"f"]) {
            self.showZanArray = [NSMutableArray arrayWithArray:[info objectForKey:@"f"]];
        }
        else
            self.showZanArray = [NSMutableArray array];
        
        if ([info objectForKey:@"c"]) {
            self.showCommentArray = [NSMutableArray arrayWithArray:[info objectForKey:@"c"]];
        }
        else
            self.showCommentArray = [NSMutableArray array];
        

        NSString * model = [info objectForKey:@"model"];
        if (model) {
            self.theModel = model;
        }
        else
            self.theModel = @"0";
        
        if ([self.theModel intValue]==2) {
            self.storyDict = [info objectForKey:@"storyPieces"];
        }
        
        self.location = [[Location alloc] init];
        self.location.lat = [[info objectForKey:@"positionLat"] doubleValue];
        self.location.lon = [[info objectForKey:@"positionLon"] doubleValue];
        self.location.address = [info objectForKey:@"positionName"]?[info objectForKey:@"positionName"]:@"";
        
        if ([[info objectForKey:@"type"] isEqualToString:@"R"]) {
            
            
            self.ifForward = YES;
            self.forwardInfo = [[ForwardInfo alloc] init];
            self.forwardInfo.forwardPetId = [info objectForKey:@"aimPetId"];
            self.forwardInfo.forwardPetAvatar = [info objectForKey:@"aimPetHeadPortrait"];
            self.forwardInfo.forwardPetNickname = [info objectForKey:@"aimPetNickName"];
            self.forwardInfo.forwardDescription = [info objectForKey:@"comment"];
            self.forwardInfo.forwardTime = [NSString stringWithFormat:@"%.0f",(double)([[info objectForKey:@"relayTime"] longLongValue]/1000)];
            
        }
        else{
            self.ifForward = NO;
        }
    }
    return self;
}



- (id)initWithSimpleInfo:(NSDictionary*)info
{
    self = [super init];
    if (self) {
        self.theID = [info objectForKey:@"petalkId"];
        self.thumbImgUrl = [info objectForKey:@"thumbUrl"];
        self.listId = [info objectForKey:@"id"];
   


        
        
        self.petInfo = [[Pet alloc]init];
        
        
        id petDict = [info objectForKey:@"pet"];
        if (petDict&&[petDict isKindOfClass:[NSDictionary class]]) {
            self.petInfo.petID = [petDict objectForKey:@"id"];
            self.petInfo.nickname = [petDict objectForKey:@"nickName"];
            self.petInfo.headImgURL = [petDict objectForKey:@"headPortrait"];
            self.petInfo.gender = [petDict objectForKey:@"gender"];
            //        self.petInfo.breed = [petDict objectForKey:@"type"];
            
            PetCategoryParser * pet = [[PetCategoryParser alloc] init];
            
            self.petInfo.breed = [pet breedWithIDcode:[[petDict objectForKey:@"type"] integerValue]];
            self.petInfo.ageStr = [Common calAgeWithBirthDate:[petDict objectForKey:@"birthday"]];
            self.petInfo.grade = [petDict[@"grade"] stringByReplacingOccurrencesOfString:@"DJ" withString:@""];
            self.petInfo.ifDaren = [petDict[@"star"] isEqualToString:@"1"]?YES:NO;
        }
        else
        {
            self.petInfo.petID = [info objectForKey:@"petId"];
            self.petInfo.nickname = [info objectForKey:@"petNickName"];
            self.petInfo.headImgURL = [info objectForKey:@"petHeadPortrait"];
        }
        
        
        
        
        self.imgUrl = [info objectForKey:@"photoUrl"];
        self.audioUrl = [info objectForKey:@"audioUrl"];
        NSArray * g = [self.audioUrl componentsSeparatedByString:@"/"];
        self.audioName = [g lastObject];
        self.descriptionContent = [info objectForKey:@"description"];
        NSString * lastTime = [info objectForKey:@"audioSecond"];
        if ([lastTime intValue]==0) {
            self.audioDuration = @"1";
        }
        else if ([lastTime floatValue]>1000){
            self.audioDuration = [NSString stringWithFormat:@"%f",[lastTime floatValue]/1000.0f];
        }
        else
            self.audioDuration = lastTime;
        //        self.audioDuration = ([[info objectForKey:@"audioSecond"] intValue]==0)?@"1":[info objectForKey:@"audioSecond"];
        self.publishTime = [NSString stringWithFormat:@"%.0f",(double)([[info objectForKey:@"createTime"] longLongValue]/1000)];
        
        NSString * model = [info objectForKey:@"model"];
        if (model) {
            self.theModel = model;
        }
        else
            self.theModel = @"0";
        
        }
    if ([self.theModel intValue]==2) {
        self.storyDict = [info objectForKey:@"storyPieces"];
    }
    return self;
}


@end
