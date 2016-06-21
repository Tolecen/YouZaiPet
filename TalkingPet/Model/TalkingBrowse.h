//
//  TalkingBrowse.h
//  TalkingPet
//
//  Created by Tolecen on 14-7-11.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationImg.h"
#import "ForwardInfo.h"
#import "Location.h"
#import "Pet.h"
#import "PlayAnimationImg.h"
#import "PetCategoryParser.h"
#import "Common.h"
@interface TalkingBrowse : NSObject
@property (nonatomic,strong)NSString * theID;
@property (nonatomic,strong)NSString * descriptionContent;
@property (nonatomic,strong)NSString * imgUrl;
@property (nonatomic,strong)NSString * thumbImgUrl;
@property (nonatomic,strong)NSString * audioUrl;
@property (nonatomic,strong)NSString * audioName;
@property (nonatomic,strong)NSString * audioDuration;
//@property (nonatomic,assign)AnimationImg  animationImg;
@property (nonatomic,strong)PlayAnimationImg*  playAnimationImg;
@property (nonatomic,strong)NSString * publishTime;
@property (nonatomic,strong)Location*  location;
@property (nonatomic,strong)NSString * tagID;
@property (nonatomic,strong)NSString * tagName;
@property (nonatomic,strong)NSArray * tagArray;
@property (nonatomic,strong)NSString * forwardNum;
@property (nonatomic,strong)NSString * commentNum;
@property (nonatomic,strong)NSString * favorNum;
@property (nonatomic,strong)NSString * shareNum;
@property (nonatomic,strong)NSString * browseNum;
@property (nonatomic,strong)Pet * petInfo;
@property (nonatomic,assign)BOOL ifForward;
@property (nonatomic,strong)ForwardInfo * forwardInfo;
@property (nonatomic,strong)NSString * listId;
@property (nonatomic,strong)NSString * relationShip;
@property (nonatomic,assign)BOOL ifZan;
@property (nonatomic,assign)float rowHeight;
//@property (nonatomic,assign)int cellIndex;
@property (nonatomic,strong)NSString * theModel;
@property (nonatomic,strong)NSMutableArray * showZanArray;
@property (nonatomic,strong)NSMutableArray * showCommentArray;
@property (nonatomic,strong)NSArray * storyDict;
- (id)initWithHostInfo:(NSDictionary*)info;
- (id)initWithSimpleInfo:(NSDictionary*)info;
@end
