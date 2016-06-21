//
//  DraftModel.h
//  TalkingPet
//
//  Created by wangxr on 15/3/5.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DraftModel : NSObject
@property (nonatomic, retain) NSNumber * publishModel;
@property (nonatomic, retain) NSString * publishImgURL;
@property (nonatomic, retain) NSString * thumImgURL;
@property (nonatomic, retain) NSString * publishAudioURL;
@property (nonatomic, retain) NSString * publishImgPath;
@property (nonatomic, retain) NSString * thumImgPath;
@property (nonatomic, retain) NSString * publishAudioPath;
@property (nonatomic, retain) NSString * publishID;
@property (nonatomic, retain) NSString * currentPetID;
@property (nonatomic, retain) NSString * decorationId;
@property (nonatomic, retain) NSString * width;
@property (nonatomic, retain) NSString * height;
@property (nonatomic, retain) NSString * centerX;
@property (nonatomic, retain) NSString * centerY;
@property (nonatomic, retain) NSString * rotationZ;
@property (nonatomic, retain) NSString * tagID;
@property (nonatomic, retain) NSString * audioDuration;
@property (nonatomic, retain) NSString * locationAddress;
@property (nonatomic, retain) NSString * locationLon;
@property (nonatomic, retain) NSString * locationLat;
@property (nonatomic, retain) NSString * textDescription;
@property (nonatomic, retain) NSString * lastEnditDate;
@end
