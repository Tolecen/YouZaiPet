//
//  PetalkalkListViewController.h
//  TalkingPet
//
//  Created by wangxr on 14/12/1.
//  Copyright (c) 2014年 wangxr. All rights reserved.
//

#import "BaseViewController.h"
#import "EGOImageButton.h"
typedef enum {
    PetalkListTyepChannel,
    PetalkListTyepPetBreed,
    PetalkListTyepAllPetalk,
    PetalkListTyepMyPublish,
    PetalkListTyepMyForWord,
    PetalkListTyepMyZan
} PetalkListTyep;

@interface PetalkalkListViewController : BaseViewController<EGOImageButtonDelegate>
@property (nonatomic,assign)PetalkListTyep listTyep;
@property (nonatomic,retain)NSString * otherCode;
@property (nonatomic,retain)NSString * detailUrl;
@property (nonatomic,retain)NSString * backGroundURL;
@property (nonatomic, retain) EGOImageButton * dButton;
@property (nonatomic,strong)UIView * bgV;
@end
